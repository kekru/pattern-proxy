#!/bin/sh
set -e

mkdir /data/configs

printenv | while IFS='=' read -r envName envValue
do

  rulePrefix=$(echo $envName | cut -d'_' -f1)
  ruleName=$(echo $envName | cut -d'_' -f2)
  rulePart=$(echo $envName | cut -d'_' -f3)

  if [[ "$rulePrefix" == "RULE" && "$rulePart" == "MODE" ]]; then

    eval mode='$RULE_'$ruleName'_MODE'
    eval pattern='$RULE_'$ruleName'_PATTERN'
    eval target='$RULE_'$ruleName'_TARGET'

    echo "Configuring rule $ruleName, mode: $mode, pattern: $pattern, target: $target"

    if [[ "$mode" == "TLSPASS" ]]; then
      echo "MODE TLSPASS is not yet implemented"
      exit 1

      file="/data/configs/tlspass.conf"
      cp /data/templates/TLSPASS.conf $file
      sed -i "/#RULES/a $pattern $target;" $file
    fi

    if [[ "$mode" == "TLSTERM" ]]; then
      echo "MODE TLSTERM is not yet implemented"
      exit 1

      file="/data/configs/tlsterm.conf"
      cp /data/templates/TLSTERM.conf $file
      sed -i "/#RULES/a $pattern $target;" $file
    fi

    if [[ "$mode" == "HTTP" ]]; then
      file="/data/configs/http.conf"
      cp /data/templates/HTTP.conf $file
      sed -i "s|PATTERN|$pattern|g" $file
      sed -i "s|TARGET|$target|g" $file
      sed -i "s|DNS_RESOLVER|$DNS_RESOLVER|g" $file
    fi
      
    if [[ "$mode" == "HTTPS" ]]; then
      echo "MODE HTTPS is not yet implemented"
      exit 1

      file="/data/configs/https.conf"
      cp /data/templates/HTTPS.conf $file
      sed -i "/#RULES/a $pattern $target;" $file
    fi
  fi
   
done

if [ -z "$(ls -A /data/configs)" ]; then
  echo "No config files were written"
  echo "check your env vars:"
  printenv
  exit 1
fi
