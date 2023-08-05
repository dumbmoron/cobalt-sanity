import check from '../../../bin/ffcheck/check.mjs'

check({
    video: {
        codec_name: 'h264',
        width: 480,
        height: 480,
        codec_tag_string: 'avc1'
    }
})