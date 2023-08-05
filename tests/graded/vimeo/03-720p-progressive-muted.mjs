import check from '../../../bin/ffcheck/check.mjs'

check({
    video: {
        codec_name: 'h264',
        width: 1280,
        height: 720,
        codec_tag_string: 'avc1'
    }
})