# co: request, 1 point
POST https://{{host}}/api/json
content-type: application/json
accept: application/json

{
  "url": "https://vine.co/v/huwVJIEJW50",
  "isAudioOnly": false,
  "isAudioMuted": false
}

# redirect
HTTP 200
[Asserts]
duration < 5000
header "Content-Type" startsWith "application/json"
jsonpath "$.status" == "redirect"
jsonpath "$.url" startsWith "https://mtc.cdn.vine.co/r/videos/"
