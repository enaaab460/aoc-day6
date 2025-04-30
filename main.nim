import lib,strutils,strformat,sets,json

let input = readFile("input.txt")
let lines = splitLines(input.strip())
let obstacles = getObstaclesCoord(lines)
let guard = getGuard(lines)
let maxGrid = (lines[0].high, lines.high)

echo &"{guard=}"

var g = guard
echo lib.playTillOut(g, obstacles, maxGrid).len
g = guard
let loops = lib.findLoops(g, obstacles, maxGrid)
echo loops.len

writeFile("myloops.txt", $loops)