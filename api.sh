# get company
company_id=$(curl -X GET -H "Accept: application/json" -H "Authorization: Basic $2" "$1/current" | jq -r '.id')

# get cluster
cluster_id=$(curl -X GET -H "Accept: application/json" -H "Authorization: Basic $2" "$1/$company_id/clusters" | jq -r '.data[0].id')

# get services list (we have traefik and apachephp, we select the second one)
service_id=$(curl -X GET -H "Accept: application/json" -H "Authorization: Basic $2" "$1/$company_id/clusters/$cluster_id/services" | jq -r '. | .data[1].id')

# create a $SECRET on Medstack's cluster (it's set on Travis CI)
curl -X POST -s -H "Accept: application/json" -H "Authorization: Basic $2" -H "Content-Type: application/json" "$1/$company_id/clusters/$cluster_id/secrets" --data "{\"name\":\"mysecret\",\"data\":\"$3\"}" | jq -r '.id'

# update the service with the new secret
curl -X PATCH -s -H "Accept: application/json" -H "Authorization: Basic $2" -H "Content-Type: application/json" "$1/$company_id/clusters/$cluster_id/services/$service_id" --data "{\"secrets\":[{\"name\":\"mysecret\",\"file_name\":\"mysecret\",\"uid\":\"0\",\"gid\":\"0\",\"mode\":\"420\"}]}"
