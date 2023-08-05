#!/usr/bin/env node
import { readFile } from "fs/promises";
const MIN_POINTS = 1

console.log(
    JSON.stringify(
        (await readFile('./instances.csv', 'utf8'))
            .split('\n')
            .slice(1)
            .map(r => r.split(','))
            .filter(([pts]) => Number(pts) >= MIN_POINTS)
            .map(([,host]) => host)
            .filter(String)
        , null, 2
    )
)