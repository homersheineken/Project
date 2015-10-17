#!/bin/bash
FAIL=0

# todo

### Check map images are all present
#
## - Check xml has normalized map name.
## - Download the latest release and verify it is there
##   - Verify the images are present and are not corrupt
##   - Verify the file counts of what is in the map folder matches the zip
##   - Verify image file size? (not too small, not too big)
##   - Check total zip file size? (not larger than 100MB?)
## - Map version checks?


function usage() {
  
  echo "usage: $(basename $0) -t <token_file> -m <map_repository>"
  echo "   token: a file containing one line, a github personal access token."
  echo "   map_repository: relative path to a local map repository clone."
  exit 1
}


##
## Handle Args
## 

if [ $# == 0 ]; then
  usage
fi

while [[ $# -gt 1 ]]
do
  key="$1"
  case "$key" in
    -t|--token)
      TOKEN_FILE="$2"
      shift 2
      ;;
    -m|--map)
      MAP=$(echo "$2" | sed 's|^\./||')
      shift 2
      ;;
    *)
      echo "Unrecognized argument: $key"
      usage
      ;;
  esac
done


function checkLocalState() {
  if [ -z "$TOKEN_FILE" ]; then
    echo "Error, token parameter missing"
    usage
    exit 1
  fi

  if [ ! -f "$TOKEN_FILE" ]; then
    echo "Error, token file does not exist: $TOKEN_FILE"
    usage
    exit 1
  fi
  
  ACCESS_TOKEN=$(cat "$TOKEN_FILE")
  if [ -z "$ACCESS_TOKEN" ]; then
    echo "Error, no token found in file: $TOKEN_FILE"
    exit 1 
  fi
  
  curl --silent -u "${ACCESS_TOKEN}:x-oauth-basic" https://api.github.com/user | grep -q login || \
      { echo "Failed to authenticate against GitHub with the admin token provided."; exit 1; }
  if [[ -z "$MAP" ]] || [[ ! -d "$MAP" ]]; then
    echo "Error, not a map folder: $MAP"
    exit 1
  fi
}


function setGlobals() {
  GITHUB_AUTH="Authorization: token $ACCESS_TOKEN"
  ORG_NAME="triplea-maps"
  MAP_ADMIN_TEAM_ID=1797261
  PAGING="?page=1&per_page=10000"
  
  GIT_FILES=".git .gitignore map .travis.yml build.gradle"
  MAP_FILES="map/place.txt map/polygons.txt map/polygons.txt map/baseTiles"
  MAP_FOLDERS="map/games"

  TRAVIS_SLUG="$ORG_NAME/$MAP"
  TRAVIS_LOGIN="travis login -g $ACCESS_TOKEN"
  EXPECTED_TRAVIS_KEYS="language jdk script before_deploy deploy provider api_key secure file skip_cleanup prerelease"
}


function fail() {
   local FAIL_MSG=$1
   echo "$MAP - FAILED - $FAIL_MSG"
   FAIL=1
}




##
## Functions for checking all expected file and folders are present
##

function checkFileExists() {
  local FILE=$1

  if [ ! -e "$FILE" ]; then
    fail "File or folder missing: $FILE"
  fi
}

function checkExpectedFilesAndFoldersPresent() {
  local mapFolder=$1

  for file in $GIT_FILES $MAP_FILES $MAP_FOLDERS; do
    checkFileExists $mapFolder/$file
  done
}


##
## Map XML checks
##

function checkMapXml() {
  local mapFolder=$1
  
  if [ ! -d "$mapFolder/map/games" ]; then
    fail "Did not find folder $mapFolder/map/games"
  else
    ## check for at least one map xml
    XML_COUNT=$(find "$mapFolder/map/games" -name "*.xml" | grep -c "^")
    if [ $XML_COUNT == 0 ]; then
      fail "Found $XML_COUNT map xmls, expected at least one in $mapFolder/map/games."
    fi
    
  fi
}


##
## CheckFolderContents
##

function checkFolderContents() {
  local mapFolder=$1
  ### Check that local folder contains no zip folders
  ZIP_COUNT=$(find "$mapFolder" -name "*.zip" | wc -l)
  if [ $ZIP_COUNT -gt 0 ]; then
    fail "Found ($ZIP_COUNT) zip files, expected zero."
  fi

}

##
## Check local git setup
## 

function checkGitSetup() {
  local mapFolder=$1

  ## Check remote origin repository has been set up
  if [ -d ".git" ]; then
    REMOTE_ORIGIN_COUNT=$(git remote -v | grep -c "^origin.*git@github.com:${ORG_NAME}/$MAP.git")
    if [ ! $REMOTE_ORIGIN_COUNT == 2 ]; then
      fail "Did not find two remote origins with 'git remote -v', found: $REMOTE_ORIGIN_COUNT"
    fi
  fi
}

##
## Check remote git setup
## 

function checkRemoteSetup() {
  local mapFolder=$1
  ## Check github org has the repository
  GITHUB_ORG_REPO_COUNT=$(curl "https://api.github.com/orgs/${ORG_NAME}/repos?${PAGING}" 2>&1 | grep -c "full_name.*$TRAVIS_SLUG\"") 
  if [ $GITHUB_ORG_REPO_COUNT == 0 ]; then
    fail "GitHub - Repository does not exist with GitHub organization ${ORG_NAME}"
  fi
}

##
## Check git teams
## 

function checkGitTeams() {
  local mapFolder=$1
  
  ## Check admin team has been added to this repository
  local ADMIN_TEAM_ADDED=$(curl -H "$GITHUB_AUTH" "https://api.github.com/teams/$MAP_ADMIN_TEAM_ID/repos?${PAGING}" 2>&1 | grep -c "clone_url.*$MAP.git")
  if [ $ADMIN_TEAM_ADDED == 0 ]; then
    fail "GitHub Teams - Map admin team not added"
  fi

  ## Check admin team has write access to this repository
  local ADMIN_TEAM_PUSH_GRANTED=$(curl -H "$GITHUB_AUTH" "https://api.github.com/teams/1797261/repos?${PAGING}" 2>&1 | grep -A25 "clone_url.*$MAP.git" | grep -c "push.*true")

  if [ "$ADMIN_TEAM_PUSH_GRANTED" == 0 ]; then
    fail "GitHub Teams - Map admin team write access not granted"
  fi
}

##
## Check Travis
##



function checkTravisKey() {
  local KEY_TO_CHECK=$1
  local KEY_COUNT=$(grep -c "$KEY_TO_CHECK:" .travis.yml)
  if [ "$KEY_COUNT" == 0 ]; then
     fail "Travis yml config - failed to find key $KEY_TO_CHECK"
  fi 
}

function checkTravisValue() {
  local VALUE_TO_CHECK="$1"
  local VALUE_COUNT=$(grep -c "$VALUE_TO_CHECK" .travis.yml)
  if [ "$VALUE_COUNT" == 0 ]; then
     fail "Travis yml config - failed to find exact value: $VALUE_TO_CHECK"
  fi
}


function checkTravis() {
  local mapFolder=$1

  local TRAVIS_YML_LENGTH=$(cat "$mapFolder/.travis.yml" | sed '/^ *$/d' | grep -c "^")
  if [ -f ".travis.yml" ]; then
    if [ "$TRAVIS_YML_LENGTH" -lt 20 ]; then
      fail "Travis yml length is too short to be correct."
    else
  
      for key in $EXPECTED_TRAVIS_KEYS; do
        checkTravisKey "$key"
      done 
  
      checkTravisValue "tags: false"
      checkTravisValue "all_branches: true"
      checkTravisValue "gradle zipMap"
  
      ### check travis slug name is correct in the .git/config file
      SLUG_COUNT=$(grep -c "slug = $TRAVIS_SLUG" .git/config)
      if [ "$SLUG_COUNT" == 0 ]; then
       fail "Travis Config - Did not find correct slug name in .git/config"
      fi
    
      ### Check travis builds for a successful build
      PASSED=$(travis status -r "$TRAVIS_SLUG"  | grep -c "passed$")
      if [ "$PASSED" == 0 ]; then
       fail "Travis Build - Last travis build did not succeed"
      fi
    fi
  fi
}

### Check Travis Variables Are Set Correctly

TRAVIS_EXPECTED_ENV_VALUES="REPO_NAME=$MAP MAP_VERSION GITHUB_PERSONAL_ACCESS_TOKEN_FOR_TRAVIS"

function checkTravisEnvironmentVariables() {
  local TRAVIS_ENV=$(travis env list -r "$TRAVIS_SLUG")
  
  for envVariable in $TRAVIS_EXPECTED_ENV_VALUES; do
    local ENV_FOUND_COUNT=$(echo "$TRAVIS_ENV" | grep -c "$envVariable")
    if [ "$ENV_FOUND_COUNT" == 0 ]; then
      fail "Missing Travis Environment Variable: $envVariable"
    fi
  done
}



###

checkLocalState
setGlobals
if [ -f .travis.yml ]; then
  "$TRAVIS_LOGIN"
fi
echo "-- Checking $MAP"
checkExpectedFilesAndFoldersPresent "$MAP"
checkMapXml "$MAP"
checkFolderContents "$MAP"
checkGitSetup "$MAP"
checkRemoteSetup "$MAP"
checkGitTeams "$MAP"
checkTravis "$MAP" 
checkTravisEnvironmentVariables

if [ "$FAIL" == 1 ]; then
  echo "$MAP result: FAILED" 
  exit -1
fi

echo "$MAP result: PASSED."
exit 0