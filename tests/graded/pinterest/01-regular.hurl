# co: request, 1 point
POST https://{{host}}/api/json
content-type: application/json
accept: application/json

{
  "url": "https://www.pinterest.com/pin/70437485604616/"
}

# redirect
HTTP 200
[Asserts]
duration < 5000
header "Content-Type" startsWith "application/json"
jsonpath "$.status" == "redirect"