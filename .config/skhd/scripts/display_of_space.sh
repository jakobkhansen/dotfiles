#! /bin/bash

echo $(yabai -m query --spaces | jq -r "sort_by(.index) | .[] | select(.[\"is-visible\"] == true) | select(.index == $@) | .display")
