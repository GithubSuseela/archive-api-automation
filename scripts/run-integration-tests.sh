###  execute with the variables:
### run-integration-tests.sh [api_url] [api_client_secret] [api_client_username] [api_client_password]###

if [[ "$#" -lt 4 ]]; then
echo "execute karate features downloaded by get-features.sh"
echo "Usage:  execute karate features"
echo "      * api_url : login xray jira"
echo "      * api_client_secret : auth client secret"
echo "      * api_client_username : auth login"
echo "      * api_client_password : auth password"
echo "      * external_urls : optional argument. external url used by scenario. ex: tdaApiUrl=http://localhost:7080;tdaTeamsUrl=http://localhost:7063"
    exit 1
fi

source ../config/api-env/LOC
cd ..
env
./gradlew --no-daemon test --tests --scan AllApiTestsRunner
