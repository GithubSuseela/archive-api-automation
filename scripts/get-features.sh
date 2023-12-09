###  execute with the variables:
### ./get-features.sh [JIRA_XRAY_LOGIN] [JIRA_XRAY_LOGIN] [XC_DEFAULT_TEST_PLAN] ###

if [[ "$#" -ne 3 ]]; then
echo "Get karate features via jira xray"
echo "Usage:  get karate features from jira"
echo "      * JIRA_XRAY_LOGIN : login xray jira"
echo "      * JIRA_XRAY_LOGIN : logini xray password"
echo "      * XC_DEFAULT_TEST_PLAN : jira number of test plan to retrieve"
    exit 1
fi

export JIRA_XRAY_LOGIN=$1
export JIRA_XRAY_PASSWD=$2
export XC_DEFAULT_TEST_PLAN=$3
export JIRA_XRAY_HOST=jira.dt.renault.com
export XC_USE_XRAY_FEATURE_FILES=true
export XC_FEATURES_DOWNLOAD_DIRECTORY=../../src/test/java/com/renault
export XC_TEST_PLAN_FILE=../../src/test/java/test-plan.json

rm -rf ../src/test/java/com/renault/ACTIVE/*.feature
cd ../tools/xray-connector
npm install
npm run xc:get-features
