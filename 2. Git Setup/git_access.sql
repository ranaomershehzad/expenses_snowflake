-- 1: Create the API Integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/ranaomershehzad/')
  ENABLED = TRUE;

-- 2: Create the GitHub Secret using a Personal Access Token (PAT)
CREATE OR REPLACE SECRET github_password_secret
  TYPE = PASSWORD
  USERNAME = 'ranaomershehzad'  -- GitHub username
  PASSWORD = 'my-access-token';  -- actual GitHub PAT

-- 3: Authorise the Secret for the Integration
ALTER API INTEGRATION git_api_integration
  SET ALLOWED_AUTHENTICATION_SECRETS = (github_password_secret);

-- 4: Create the Git Repository in Snowflake
CREATE OR REPLACE GIT REPOSITORY expenses_repo
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = github_password_secret
  ORIGIN = 'https://github.com/ranaomershehzad/expenses_snowflake';

-- 5: Confirm Setup
SHOW GIT BRANCHES IN GIT REPOSITORY expenses_repo;

-- 6: Can check your secrets info here - this will show the record of the APIs and secrets in there:
SHOW SECRETS IN SCHEMA EXPENSES_DB.PUBLIC;
SHOW API INTEGRATIONS;


