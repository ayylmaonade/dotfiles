#!/bin/bash
#
# Written by Chris Arceneaux
# GitHub: https://github.com/carceneaux
# Email: carcenea@gmail.com
# Website: http://arsano.ninja
#
# Note: This code is a stop-gap to erase Job Artifacts for a project. I HIGHLY recommend you leverage
#       "artifacts:expire_in" in your .gitlab-ci.yml
#
# https://docs.gitlab.com/ee/ci/yaml/#artifactsexpire_in
#
# Software Requirements: curl, jq
#
# This code has been released under the terms of the Apache-2.0 license
# http://opensource.org/licenses/Apache-2.0


# project_id, find it here: https://gitlab.com/[organization name]/[repository name] at the top underneath repository name
project_id="29874791"

# token, find it here: https://gitlab.com/profile/personal_access_tokens
token="glpat--qsEhzbyyLB5Nsj1e4TV"
server="gitlab.com"

# Retrieving Jobs list page count
total_pages=$(curl -sD - -o /dev/null -X GET \
  "https://$server/api/v4/projects/$project_id/jobs?per_page=100" \
  -H "PRIVATE-TOKEN: ${token}" | grep -Fi X-Total-Pages | sed 's/[^0-9]*//g')

# Creating list of Job IDs for the Project specified with Artifacts
job_ids=()
echo ""
echo "Creating list of all Jobs that currently have Artifacts..."
echo "Total Pages: ${total_pages}"
for ((i=2;i<=${total_pages};i++)) #starting with page 2 skipping most recent 100 Jobs
do
  echo "Processing Page: ${i}/${total_pages}"
  response=$(curl -s -X GET \
    "https://$server/api/v4/projects/$project_id/jobs?per_page=100&page=${i}" \
    -H "PRIVATE-TOKEN: ${token}")
  length=$(echo $response | jq '. | length')
  for ((j=0;j<${length};j++))
  do
    if [[ $(echo $response | jq ".[${j}].artifacts_file | length") > 0 ]]; then
        echo "Job found: $(echo $response | jq ".[${j}].id")"
        job_ids+=($(echo $response | jq ".[${j}].id"))
    fi
  done
done

# Loop through each Job erasing the Artifact(s)
echo ""
echo "${#job_ids[@]} Jobs found. Commencing removal of Artifacts..."
for job_id in ${job_ids[@]};
do
  response=$(curl -s -X DELETE \
    -H "PRIVATE-TOKEN:${token}" \
    "https://$server/api/v4/projects/$project_id/jobs/$job_id/artifacts")
  echo "Processing Job ID: ${job_id} - Status: $(echo $response | jq '.status')"
done
