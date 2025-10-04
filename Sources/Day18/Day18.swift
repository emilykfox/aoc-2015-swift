import Foundation

@main
struct Day18 {
  static func main() throws {
    var originalGrid = [Array(repeating: "." as Character, count: 102)]
    while let line = readLine() {
      var row = ["." as Character]
      row.append(contentsOf: line)
      row.append(".")
      originalGrid.append(row)
    }
    originalGrid.append(Array(repeating: "." as Character, count: 102))

    var grid = originalGrid
    for _ in 1...100 {
      var nextGrid = grid
      for rowIndex in 1...100 {
        for columnIndex in 1...100 {
          let numLit = (-1...1).flatMap({ (rowDelta) in
            (-1...1).map({ (columnDelta) in (rowDelta, columnDelta) })
          })
          .filter({ (deltas) in
            deltas != (0, 0) && grid[rowIndex + deltas.0][columnIndex + deltas.1] == "#"
          }).count
          if grid[rowIndex][columnIndex] == "#" {
            if numLit != 2 && numLit != 3 {
              nextGrid[rowIndex][columnIndex] = "."
            }
          } else {
            if numLit == 3 {
              nextGrid[rowIndex][columnIndex] = "#"
            }
          }
        }
      }
      grid = nextGrid
    }

    var numLit =
      (1...100).flatMap({ (rowDelta) in
        (1...100).map({ (columnDelta) in (rowDelta, columnDelta) })
      })
      .filter({ (indices) in grid[indices.0][indices.1] == "#" })
      .count
    print("Part One: \(numLit)")

    grid = originalGrid
    grid[1][1] = "#"
    grid[1][100] = "#"
    grid[100][1] = "#"
    grid[100][100] = "#"

    for _ in 1...100 {
      var nextGrid = grid
      for rowIndex in 1...100 {
        for columnIndex in 1...100 {
          if ![(1, 1), (1, 100), (100, 1), (100, 100)].contains(where: {
            $0 == (rowIndex, columnIndex)
          }) {
            let numLit = (-1...1).flatMap({ (rowDelta) in
              (-1...1).map({ (columnDelta) in (rowDelta, columnDelta) })
            })
            .filter({ (deltas) in
              deltas != (0, 0) && grid[rowIndex + deltas.0][columnIndex + deltas.1] == "#"
            }).count
            if grid[rowIndex][columnIndex] == "#" {
              if numLit != 2 && numLit != 3 {
                nextGrid[rowIndex][columnIndex] = "."
              }
            } else {
              if numLit == 3 {
                nextGrid[rowIndex][columnIndex] = "#"
              }
            }
          }
        }
      }
      grid = nextGrid
    }

    numLit =
      (1...100).flatMap({ (rowDelta) in
        (1...100).map({ (columnDelta) in (rowDelta, columnDelta) })
      })
      .filter({ (indices) in grid[indices.0][indices.1] == "#" })
      .count
    print("Part Two: \(numLit)")
  }
}
