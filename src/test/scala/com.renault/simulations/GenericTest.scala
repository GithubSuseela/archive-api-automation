package com.renault.simulations

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.commons.stats.assertion.Assertion
import io.gatling.core.structure.PopulationBuilder

import scala.util.Properties
import scala.collection.mutable._
import scala.concurrent.duration._
import scala.io.Source._
import java.util.UUID

import com.renault.utils._
import ujson._

class GenericTest extends Simulation {
  val INJECTION_AT_ONCE                 = "at-once"
  val INJECTION_RAMP                    = "ramp"
  val INJECTION_CONSTANT_PER_SEC        = "constant-per-sec"
  val INJECTION_CONSTANT_PER_SEC_RANDOM = "constant-per-sec-random"
  val INJECTION_RAMP_PER_SEC            = "ramp-per-sec"
  val INJECTION_RAMP_PER_SEC_RANDOM     = "ramp-per-sec-random"
  val INJECTION_HEAVISIDE               = "heaviside"

  val FEATURES_PATH                     = "com/renault/ACTIVE"

  // Before hook

  before {
    println("[BEFORE] Before hook starting...")

    Features
      .getList(FEATURES_PATH)
      .map(Features.runFeature(_, "@before-hook"))

    println("[BEFORE] Done")
  }

  // After hook

  after {
    println("[AFTER] After hook starting...")

    Features
      .getList(FEATURES_PATH)
      .map(Features.runFeature(_, "@after-hook"))

    println("[AFTER] Done")
  }

  // Scenarios setup

  val configurationPath : String = Properties.envOrElse("TEST_CONFIGURATION_PATH", "")
  if (configurationPath.isEmpty) {
    throw new IllegalArgumentException("Environment variable TEST_CONFIGURATION_PATH was not set")
  }

  val config = read(fromFile(configurationPath).mkString)

  val assertSuccessfulRequestsPercent   : Double = if (config.obj.contains("successfulRequestsPercent"))   config("successfulRequestsPercent").asInstanceOf[Num].value  else 100.0
  val assertResponseTimeMin             : Double = if (config.obj.contains("responseTimeMin"))             config("responseTimeMin").asInstanceOf[Num].value            else -1
  val assertResponseTimeMax             : Double = if (config.obj.contains("responseTimeMax"))             config("responseTimeMax").asInstanceOf[Num].value            else -1
  val assertResponseTimeMean            : Double = if (config.obj.contains("responseTimeMean"))            config("responseTimeMean").asInstanceOf[Num].value           else -1
  val assertResponseTimeStdDev          : Double = if (config.obj.contains("responseTimeStdDev"))          config("responseTimeStdDev").asInstanceOf[Num].value         else -1
  val assertResponseTimePercentile50th  : Double = if (config.obj.contains("responseTimePercentile50th"))  config("responseTimePercentile50th").asInstanceOf[Num].value else -1
  val assertResponseTimePercentile75th  : Double = if (config.obj.contains("responseTimePercentile75th"))  config("responseTimePercentile75th").asInstanceOf[Num].value else -1
  val assertResponseTimePercentile95th  : Double = if (config.obj.contains("responseTimePercentile95th"))  config("responseTimePercentile95th").asInstanceOf[Num].value else -1
  val assertResponseTimePercentile99th  : Double = if (config.obj.contains("responseTimePercentile99th"))  config("responseTimePercentile99th").asInstanceOf[Num].value else -1
  val assertRequestsPerSecond           : Double = if (config.obj.contains("requestsPerSecond"))           config("requestsPerSecond").asInstanceOf[Num].value          else -1

  var assertions = new ListBuffer[Assertion]()
  assertions += global.successfulRequests.percent.gte (assertSuccessfulRequestsPercent.toInt)

  if (assertResponseTimeMin             >= 0) { assertions += global.responseTime.min.lte         (assertResponseTimeMin.toInt)  }
  if (assertResponseTimeMax             >= 0) { assertions += global.responseTime.max.lte         (assertResponseTimeMax.toInt)  }
  if (assertResponseTimeMean            >= 0) { assertions += global.responseTime.mean.lte        (assertResponseTimeMean.toInt) }
  if (assertResponseTimeStdDev          >= 0) { assertions += global.responseTime.stdDev.lte      (assertResponseTimeStdDev.toInt) }
  if (assertResponseTimePercentile50th  >= 0) { assertions += global.responseTime.percentile1.lte (assertResponseTimePercentile50th.toInt) }
  if (assertResponseTimePercentile75th  >= 0) { assertions += global.responseTime.percentile2.lte (assertResponseTimePercentile75th.toInt) }
  if (assertResponseTimePercentile95th  >= 0) { assertions += global.responseTime.percentile3.lte (assertResponseTimePercentile95th.toInt) }
  if (assertResponseTimePercentile99th  >= 0) { assertions += global.responseTime.percentile4.lte (assertResponseTimePercentile99th.toInt) }
  if (assertRequestsPerSecond           >= 0) { assertions += global.requestsPerSec.gte           (assertRequestsPerSecond.toInt)  }

  val simulations: List[Value] = if (config.obj.contains("simulations")) config("simulations").asInstanceOf[Arr].value.toList else List[Value]()

  val builders: List[PopulationBuilder] = simulations.map((simulation: Value) => {
    val tag       : String  = if (simulation.obj.contains("tag"))               simulation("tag").asInstanceOf[Str].str               else "*"
    val users     : Int     = if (simulation.obj.contains("users"))             simulation("users").asInstanceOf[Num].value.toInt     else 1
    val profile   : String  = if (simulation.obj.contains("injection_profile")) simulation("injection_profile").asInstanceOf[Str].str else INJECTION_AT_ONCE
    val duration  : Int     = if (simulation.obj.contains("duration"))          simulation("duration").asInstanceOf[Num].value.toInt  else 0

    println("[SIMULATION] tag '" + tag + "'" +
      " => " + users + " user(s)" +
      " => " + profile +
      " => " + duration + " seconds"
    )

    var builder = scenario(tag + "_" + UUID.randomUUID.toString())
      .exec(UserFeeder.get())
      .exec(DynatraceFeeder.get("gatling_" + UUID.randomUUID.toString(), tag))

    Features
      .getList(FEATURES_PATH)
      .map(if (tag.equals("*")) karateFeature(_, "~@ignore") else karateFeature(_, "@" + tag))
      .foreach {
        feature => {
          builder =
            builder
              .exec(feature)
        }
      }

    profile match {
      case INJECTION_AT_ONCE  => builder.inject(atOnceUsers(users))
      case INJECTION_RAMP  => builder.inject(rampUsers(users) during (duration seconds))
      case INJECTION_CONSTANT_PER_SEC  => builder.inject(constantUsersPerSec(users) during (duration seconds))
      case INJECTION_CONSTANT_PER_SEC_RANDOM  => builder.inject(constantUsersPerSec(users) during (duration seconds) randomized)
      case INJECTION_RAMP_PER_SEC  => builder.inject(rampUsersPerSec(0) to users during (duration seconds))
      case INJECTION_RAMP_PER_SEC_RANDOM  => builder.inject(rampUsersPerSec(0) to users during (duration seconds) randomized)
      case INJECTION_HEAVISIDE  => builder.inject(heavisideUsers(users) during (duration seconds))
      case _  => builder.inject(atOnceUsers(users))
    }
  })

  setUp(builders)
  .protocols(karateProtocol())
  .assertions(assertions.toList)
}
