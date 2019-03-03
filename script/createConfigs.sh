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
      file="/data/configs/tlspass.conf"
      cp /data/templates/TLSPASS.conf $file
      sed -i "/#RULES/a $pattern $target;" $file
    fi
    

    if [[ "$mode" == "TLSTERM" ]]; then
      file="/data/configs/tlsterm.conf"
      cp /data/templates/TLSTERM.conf $file
      sed -i "/#RULES/a $pattern $target;" $file
    fi
      
  fi
   
done

