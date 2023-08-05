# co: request, 1 point
POST https://{{host}}/api/json
content-type: application/json
accept: application/json

{
  "url": "https://vimeo.com/847420027",
  "vQuality": 2160
}

# redirect
HTTP 200
[Asserts]
duration < 5000
header "Content-Type" startsWith "application/json"
jsonpath "$.status" == "redirect"