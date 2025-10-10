import Foundation

@main
struct Day25 {
  static func main() throws {
    let matches = readLine()!.matches(of: /\d+/)
    let targetRow = Int(matches[0].0)!
    let targetColumn = Int(matches[1].0)!

    var code = 20_151_125
    diagonals: for diagonal in 1... {
      for row in (1...diagonal).reversed() {
        let column = diagonal + 1 - row
        if row == targetRow && column == targetColumn {
          break diagonals
        }

        code = (code * 252533) % 33_554_393
      }
    }

    print("Part One: \(code)")
    print("Part Two: You win!!!")
  }
}
