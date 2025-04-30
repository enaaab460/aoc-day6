import lib,strutils,strformat,benchy

let input = readFile("input.txt")
let lines = splitLines(input.strip())
let obstacles = getObstaclesCoord(lines)
let maxGrid = (lines[0].high, lines.high)
let guard = getGuard(lines)

timeIt "Level 1":
    var g = guard
    discard lib.playTillOut(g, obstacles, maxGrid)

timeIt "Level 2":
    var g = guard
    discard lib.findLoops(g, obstacles, maxGrid)