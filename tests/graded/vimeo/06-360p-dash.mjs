import check from '../../../bin/ffcheck/check.mjs'

check({
    video: {
        codec_name: 'h264',
        width: 640,
        height: 360,
        codec_tag_string: 'avc1'
    },
    audio: {
        codec_name: 'aac',
        codec_tag_string: 'mp4a',
        channels: 2
    }
})