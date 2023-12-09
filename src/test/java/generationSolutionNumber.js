function generationSolutionNumber(count) {
  result = []
  from = new Date("2020-10-10T13:19:11+0000").getTime();
  for(idx = 0; idx < count; idx++){
    result.push(buildSolutionNumber(from))
  }
  return result
}

function sleep(milliseconds) {
  date = new Date().getTime();
  currentDate = null;
  do {
    currentDate = new Date().getTime();
  } while (currentDate - date < milliseconds);
}

function buildSolutionNumber(fromDate) {
  diff = (new Date().getTime() - fromDate).toString();
  sleep(1)
  return diff.substring(diff.length - 9, diff.length);
}