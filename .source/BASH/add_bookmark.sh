#!/bin/bash

# EDIT THIS PART OF THE SCRIPT
# enter your GitHub repository
gh_repo=user/repo
# enter a PAT for your GitHub repository
gh_pat=github_personal_access_token

# DO NOT EDIT THE REST OF THE SCRIPT
echo Adding a new bookmark to $gh_repo
# enter new_link interactively
read -p 'Bookmark URL (required): ' new_link
if [ -z "$new_link" ]; then
  echo "Error: You didn't provide the new bookmark's URL."; exit
fi
# enter new_title interactively
read -p 'Bookmark title (optional): ' new_title
if [ -z "$new_title" ]; then
  echo "Warning: You didn't provide the new bookmark's title. It will be looked up."
fi
# enter new_tags interactively
read -p 'Bookmark tags (optional, comma separated): ' new_tags
# dispatch workflow
curl --request POST \
  --header 'Accept: application/vnd.github.v3+json' \
  --header "Authorization: token $gh_pat" \
  --url "https://api.github.com/repos/$gh_repo/actions/workflows/add_bookmark.yml/dispatches" \
  --data "{ \"inputs\":{
    \"link\":\"$new_link\",
    \"title\":\"$new_title\",
    \"tags\":\"$new_tags\"
  }, \"ref\":\"main\" }"
