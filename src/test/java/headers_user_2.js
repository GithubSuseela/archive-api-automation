function headers() {
  var headers = {};

  headers['Accept'] = 'application/json';
  headers['Authorization'] = 'Bearer ' + karate.get('access_token_2');

  if (typeof __gatling !== 'undefined') {
    var dynatraceHeader = '';

    dynatraceHeader += 'VU=' + __gatling.VIRTUAL_USER_ID;
    dynatraceHeader += ';';
    dynatraceHeader += 'SI=' + __gatling.SOURCE_ID;
    dynatraceHeader += ';';
    dynatraceHeader += 'TSN=' + __gatling.TEST_STEP_NAME;
    dynatraceHeader += ';';
    dynatraceHeader += 'LSN=' + __gatling.LOAD_SCRIPT_NAME;
    dynatraceHeader += ';';
    dynatraceHeader += 'LTN=' + __gatling.LOAD_TEST_NAME;

    headers['x-dynatrace-test'] = dynatraceHeader;
  }

  // karate.log('[KARATE HEADERS]', headers);

  return headers;
}
