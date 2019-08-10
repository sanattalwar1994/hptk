#!/bin/bash
echo `grep "version" 1c.json` > 1c.json
vi 1c.json -c ':%s/"version"://g' -c ':%s/"//g' -c ':%s/\s//g' -c ':wq!'
var=$(cat ~/priv/1c.json)
IFS=', ' read -r -a array <<< "$var";
for element in "${array[@]}"
do
  if [ "$(echo "$element" | cut -d. -f2 | wc -c)" -eq "4" ]
  then
    echo $element;
  else
    echo "number not found";
  fi
done
