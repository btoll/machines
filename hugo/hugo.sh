#!/bin/sh

# NOTE: This shell script will be running in an Alpine Linux container
# where this is no Bash shell!

# TODO:
# - Set METHOD if only ARTICLE is given?  Or better to be explicit
#   and expect METHOD to be set?
# - Don't like that you have to be in the project dir to create a new article.

set -eu

BASE_URL="${BASE_URL:=/}"
DESTINATION="${DESTINATION:=public}"
METHOD="${METHOD:=publish}"
SOURCE="${SOURCE:=/src}"
THEME="${THEME:=hugo-lithium-theme}"

echo "BASE_URL: $BASE_URL"
echo "DESTINATION: $DESTINATION"
echo "METHOD: $METHOD"
if [ "$METHOD" = new ]
then
    echo "ARTICLE: $ARTICLE"
fi
echo "THEME: $THEME"
echo

if [ "$METHOD" = new ]
then
    # Assumes it's in the root of the project and that there is a `post` child directory of
    # `content` that contains all the articles.
    #
    # For example:
    #
    #       $HOME/projects/benjamintoll.com/content/post
    #
    hugo new "post/$ARTICLE.md" --theme "/themes/$THEME"
else
    # Publishing.
    if [ ! -d "/themes/$THEME" ]
    then
        echo "[$0][ERROR] The $THEME theme does not exist in /themes, exiting."
        exit 1
    fi

    hugo --source "$SOURCE" --theme "/themes/$THEME" --destination "$DESTINATION" --baseURL "$BASE_URL"
fi

