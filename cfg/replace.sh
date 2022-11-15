#!/bin/bash
# generate default mappings from the spec with:
# cat cfg/openapi3.yaml | yq '.paths.*.*.operationId | {(path | join(".")):.}'

mappings=$1
target=$2
result=$(cat $target)

while read line; do
  IFS=':' read -ra pattern <<< "$line"
  IFS='.' read -ra uri <<< "${pattern[0]}"
  key=".${uri[0]}.[\"${uri[1]}\"]".${uri[2]}.${uri[3]} # escape {}
  value=$(echo ${pattern[1]} | xargs) # remove whitespace
  echo "replacing: ${key}"
  result=$(echo "${result}" | yq "${key} = \"${value}\"")
done < $mappings

echo "${result}" > ${target}