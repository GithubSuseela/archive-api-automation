Feature: Sample demo feature
  Scenario Outline: sample demo scenarios
    * def petIDValue = 12
    Given url 'https://petstore.swagger.io/v2'
    * print '/pet/'+ petIDValue

    Examples:
    |envVal|
    |qua.tda.dev.aws.|
