import sets,strformat,sugar

type Coord* = tuple[x: int, y: int]
type Direction* = enum Up, Right, Down, Left
type Vector* = object
    coord*: Coord
    direction*: Direction
type Guard* = object
    vector*: Vector
    path*: HashSet[Vector]

func getObstaclesCoord*(lines: seq[string]): seq[Coord] =
    for y, line in lines:
        for x, char in line:
            if char == '#':
                result.add((x: x, y: y))

func getGuard*(lines: seq[string]): Guard =
    for y, line in lines:
        for x, char in line:
            if char in {'^', 'v', '<', '>'}:
                result.vector.coord = (x: x, y: y)
                break

    case lines[result.vector.coord.y][result.vector.coord.x]:
        of '^': result.vector.direction = Up
        of '>': result.vector.direction = Right
        of 'v': result.vector.direction = Down
        of '<': result.vector.direction = Left
        else: discard

func move*(guard: var Guard) =
    case guard.vector.direction:
        of Up: guard.vector.coord.y -= 1
        of Down: guard.vector.coord.y += 1
        of Left: guard.vector.coord.x -= 1
        of Right: guard.vector.coord.x += 1

func moveBack*(guard: var Guard) =
    case guard.vector.direction:
        of Up: guard.vector.coord.y += 1
        of Down: guard.vector.coord.y -= 1
        of Left: guard.vector.coord.x += 1
        of Right: guard.vector.coord.x -= 1

func turnRight*(guard: var Guard) =
    case guard.vector.direction:
        of Up: guard.vector.direction = Right
        of Down: guard.vector.direction = Left
        of Left: guard.vector.direction = Up
        of Right: guard.vector.direction = Down

func isAtObstacle*(guard: Guard, obstacles: seq[Coord]): bool =
    var g = Guard(vector:guard.vector)
    g.move()
    for obstacle in obstacles:
        if obstacle.x == g.vector.coord.x and obstacle.y == g.vector.coord.y:
            return true

func isGuardinGrid(guard: Guard, maxGrid: Coord): bool =
    return guard.vector.coord.x >= 0 and guard.vector.coord.x <= maxGrid.x and guard.vector.coord.y >= 0 and guard.vector.coord.y <= maxGrid.y

func playRound*(guard: var Guard, obstacles: seq[Coord]) =
    guard.path.incl(guard.vector)
    # guard.move()
    # if guard.isAtObstacle(obstacles):
    #     guard.moveBack()
    #     guard.turnRight()
    # guard.move()
    while guard.isAtObstacle(obstacles):
        # guard.moveBack()
        guard.turnRight()
    guard.move()

func playTillOut*(guard: var Guard, obstacles: seq[Coord], maxGrid: Coord): HashSet[Coord]=
    while isGuardinGrid(guard, maxGrid):
        playRound(guard, obstacles)
    let positions = guard.path.map(x=>x.coord)
    return positions

func playTillVector*(guard: var Guard, obstacles: seq[Coord], maxGrid: Coord, stopVector: Vector)=
    var inside = true
    var atStop = false
    while inside and (not atStop):
        playRound(guard, obstacles)
        inside = isGuardinGrid(guard, maxGrid)
        atStop = guard.vector == stopVector

func addObstacleAhead*(guard: Guard): Coord =
    # debugEcho &"before obstacle: {guard.vector=}"
    let obs = 
        case guard.vector.direction:
            of Up: (x: guard.vector.coord.x, y: guard.vector.coord.y - 1)
            of Down: (x: guard.vector.coord.x, y: guard.vector.coord.y + 1)
            of Left: (x: guard.vector.coord.x - 1, y: guard.vector.coord.y)
            of Right: (x: guard.vector.coord.x + 1, y: guard.vector.coord.y)
    # debugEcho &"{obs=}"
    let path_coords = guard.path.map(x=>x.coord)
    if obs notin path_coords:
        return obs

func trySpectre*(guard: Guard, obstacles: seq[Coord],maxGrid: Coord): Coord =
    # var spectre = guard
    var spectre = Guard(vector:guard.vector)
    let new_obstacle = guard.addObstacleAhead()
    let temp_obstacles = obstacles & new_obstacle
    spectre.turnRight()
    while spectre.isGuardinGrid(maxGrid):
        if spectre.vector in guard.path or spectre.vector in spectre.path:
            return new_obstacle
            # return true
        spectre.playRound(temp_obstacles)
    # return ((0,0),false)

func findLoops*(guard: var Guard, obstacles: seq[Coord], maxGrid: Coord): HashSet[Coord]=
    var loopObstacles = initHashSet[Coord](0)
    var round = 0
    while isGuardinGrid(guard, maxGrid):
        inc round
        let new_obstacle = trySpectre(guard, obstacles, maxGrid)
        # if new_obstacle != (0,0):
        if new_obstacle != (0,0):
            loopObstacles.incl(new_obstacle)
        playRound(guard, obstacles)
        # debugEcho &"{round=} {guard.vector=}"
    # debugEcho loopObstacles
    return loopObstacles

# func check_positions*(guard: Guard,path: HashSet[Coord], obstacles: seq[Coord], maxGrid: Coord): HashSet[Coord]=
#     #[
#         for every position
#         place an obstacle
#         play round
#         check if guard returns to previous position
#     ]#
#     let correct_path = path - { guard.vector.coord }
#     for p in path:
#         let temp_obstacles = obstacles & p
#         var g = Guard(vector:guard.vector)
#         while g.isGuardinGrid(maxGrid):
#             g.playRound(temp_obstacles)
#             if g.path.contains(g.vector):
#                 result.incl(p)