# Usage

```
index="interest_rate"
type="rate"

curl -XDELETE localhost:9200/${index}
curl -XPUT localhost:9200/${index}
curl -XPUT localhost:9200/${index}/${type}/_mapping -d @rate_mapping.json

ruby interest_rate.rb |
  while read line
  do
    id=$(echo $line | jq -c '.id' | tr -d "\n")
    echo "{ \"index\" : { \"_index\" : \"${index}\", \"_type\" : \"${type}\", \"_id\" : ${id}} }\n$line" | curl -XPOST localhost:9200/_bulk --data-binary @-
  done
```
