GET https://{{host}}/api/serverInfo

HTTP 200
[Asserts]
duration < 3000
header "Content-Type" startsWith "application/json"
jsonpath "$.cors" == 1
