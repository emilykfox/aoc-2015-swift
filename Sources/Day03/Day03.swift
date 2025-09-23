struct Coordinates: Hashable {
    let row: Int
    let column: Int
}

@available(macOS 15, *)
@main
struct Day03 {
    static func main() {
        let directions = readLine()!

        var visited = Set<Coordinates>()
        var current = Coordinates(row: 0, column: 0)
        visited.insert(current)

        for direction in directions {
            current = switch direction {
                case "^": Coordinates(row: current.row + 1, column: current.column)
                case "v": Coordinates(row: current.row - 1, column: current.column)
                case ">": Coordinates(row: current.row, column: current.column + 1)
                default: Coordinates(row: current.row, column: current.column - 1)
            }
            visited.insert(current)
        }

        print("Part One: \(visited.count)")

        visited = Set<Coordinates>()
        var santaCurrent = Coordinates(row: 0, column: 0)
        var robotCurrent = Coordinates(row: 0, column: 0)
        visited.insert(santaCurrent)
        var santaNext = true

        for direction in directions {
            let (rowDelta, columnDelta) = switch direction {
                case "^": (1, 0)
                case "v": (-1, 0)
                case ">": (0, 1)
                default: (0, -1)
            }
            if santaNext {
                santaCurrent = Coordinates(row: santaCurrent.row + rowDelta, column: santaCurrent.column + columnDelta)
                visited.insert(santaCurrent)
            } else {
                robotCurrent = Coordinates(row: robotCurrent.row + rowDelta, column: robotCurrent.column + columnDelta)
                visited.insert(robotCurrent)
            }

            santaNext = !santaNext
        }

        print("Part Two: \(visited.count)")
    }
}
