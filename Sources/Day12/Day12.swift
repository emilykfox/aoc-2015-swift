import Foundation

@main
struct Day12 {
  static func main() throws {
    let regex = /-?\d+/
    let redex =
      /(?<openArray>\[)|(?<closeArray>\])|(?<openObject>\{)|(?<closeObject>\})|(?<red>"red")|(?<number>-?\d+)/

    let input = readLine()!

    let matches = input.matches(of: regex)
    var sum = 0
    for match in matches {
      sum += Int(match.0)!
    }

    print("Part One: \(sum)")

    var tokens = input.matches(of: redex).makeIterator()

    func notRedSum(inObject: Bool) -> Int {
      var sum = 0
      var red = false
      while let token = tokens.next() {
        if token.openArray != nil {
          sum += notRedSum(inObject: false)
        } else if token.closeArray != nil {
          assert(!inObject)
          break
        } else if token.openObject != nil {
          sum += notRedSum(inObject: true)
        } else if token.closeObject != nil {
          assert(inObject)
          break
        } else if token.red != nil {
          if inObject {
            red = true
          }
        } else {
          sum += Int(token.number!)!
        }
      }

      if red {
        return 0
      } else {
        return sum
      }
    }

    let newSum = notRedSum(inObject: false)

    print("Part Two: \(newSum)")
  }
}
