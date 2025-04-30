import lib,strutils,unittest,strformat,sets,sequtils

let input = readFile("test1.txt")
let lines = splitLines(input.strip())
let obstacles = getObstaclesCoord(lines)
let guard = getGuard(lines)
let maxGrid = (lines[0].high, lines.high)
echo &"{guard=}"

test "guard":
    check getGuard(lines) == Guard(vector:Vector(coord:(4,6),direction:Up))

test "level 1":
    var g = guard
    check playTillOut(g, obstacles, maxGrid).len == 41

test "level 2":
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    echo loops
    check loops.len == 6

# test "all path":
#     var g = guard
#     discard playTillOut(g, obstacles, maxGrid)
#     g.vector = guard.vector
#     check findLoops(g, obstacles, maxGrid) == 6

# proc reddit_part_2 (input:int): Hashset[Coord] =
#     let input = readFile(&"testr{input}.txt")
#     let lines = splitLines(input.strip())
#     let obstacles = getObstaclesCoord(lines)
#     var guard = getGuard(lines)
#     let maxGrid = (lines[0].high, lines.high)
#     # echo &"{guard=}"
#     return findLoops(guard, obstacles, maxGrid)

test "reddit corner":
    let input = readFile("testr1.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    discard playTillOut(g, obstacles, maxGrid)
    # echo g
    check g.vector == Vector(coord:(0,2),direction:Down)

test "reddit test 2":
    let input = readFile("testr2.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    echo loops
    check loops.len == 1

test "reddit test 3":
    let input = readFile("testr3.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    # echo loops
    # check loops.len == 3
    echo toSeq(loops)
    check toSeq(loops) == [ (x: 1, y: 1), (x: 0, y: 4), (x: 3, y: 1) ]

test "reddit test 4":
    let input = readFile("testr4.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    # echo loops
    check loops.len == 1
    # echo toSeq(loops)

test "reddit test 5":
    let input = readFile("testr5.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    # echo loops
    check loops.len == 1
    # echo toSeq(loops)

test "reddit test 6":
    let input = readFile("testr6.txt")
    let lines = splitLines(input.strip())
    let obstacles = getObstaclesCoord(lines)
    let guard = getGuard(lines)
    let maxGrid = (lines[0].high, lines.high)
    # echo &"{guard=}"
    var g = guard
    let loops = findLoops(g, obstacles, maxGrid)
    # echo loops
    check loops.len == 0
    # echo toSeq(loops)