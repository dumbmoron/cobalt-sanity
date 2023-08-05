# co: ffprobe, 1 point
POST https://{{host}}/api/json
content-type: application/json
accept: application/json

{
  "url": "https://vine.co/v/huwVJIEJW50",
  "isAudioOnly": false,
  "aFormat": "mp3",
  "isAudioMuted": true
}

HTTP 200
[Asserts]
duration < 5000
header "Content-Type" startsWith "application/json"
jsonpath "$.status" == "stream"

[Captures]
stream_url: jsonpath "$.url"

# stream_continue
GET {{stream_url}}&p=1
HTTP 200
[Asserts]
duration < 5000
header "Content-Type" startsWith "application/json"
jsonpath "$.status" == "continue"

# stream
GET {{stream_url}}
HTTP 200
[Asserts]
duration < 10000
header "Content-Disposition" startsWith "attachment"
header "Content-Disposition" endsWith ".mp4\""
bytes count > 500000