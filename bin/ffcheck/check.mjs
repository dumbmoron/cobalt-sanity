import { spawnSync } from 'child_process'

const match = (a, b) => {
    if (typeof b !== 'object')
        return false

    Object.keys(a).forEach(key => {
        if (typeof a[key] === 'function' && !a[key](b[key]))
            return false

        if (a[key] !== b[key])
            return false
    })

    return true
}

const err = msg => console.error(`err: ${msg}`) || process.exit(1)

const check = async expects => {
    const probe = await spawnSync('ffprobe', [
        '-v', 'error',
        '-show_streams',
        '-print_format', 'json',
        '-i', process.argv[2]
    ])

    let streams = []
    try {
        streams = JSON.parse(probe.stdout)?.streams
    } catch {
        console.error('stdout=', JSON.stringify(probe.stdout.toString()))
        err(`could not parse json, ffprobe: ${JSON.stringify(probe.stderr.toString())}`)
    }

    if (probe.stderr.length > 0) {
        console.error('stderr=', JSON.stringify(probe.stderr.toString()))
    }

    Object.keys(expects).forEach(streamType => {
        let templates = expects[streamType]
        if (!Array.isArray(templates))
            templates = [ templates ]
        
        templates.forEach(t => {
            t.stream_type = streamType

            const matched = streams.find(s => match(t, s))
            if (!matched)
                err('no match found for: ' + JSON.stringify(t))

            delete streams[matched.index]
        })
    })

    if (streams.filter(Boolean).length > 0)
        err(`excess/unmatched streams: ${JSON.stringify(streams)}`)
}

export default check