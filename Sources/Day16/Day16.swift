import Foundation

enum ComparisonType {
  case greaterThan
  case fewerThan
  case equalTo
}

let analysis: [String: (Int, ComparisonType)] = [
  "children": (3, .equalTo),
  "cats": (7, .greaterThan),
  "samoyeds": (2, .equalTo),
  "pomeranians": (3, .fewerThan),
  "akitas": (0, .equalTo),
  "vizslas": (0, .equalTo),
  "goldfish": (5, .fewerThan),
  "trees": (3, .greaterThan),
  "cars": (2, .equalTo),
  "perfumes": (1, .equalTo),
]

@main
struct Day16 {
  static func main() throws {
    let sueEx = /^Sue (?<number>\d+):/
    let compoundRegex = /(?<compound>\w+): (?<numKinds>\d+)/

    var correctSue: Substring? = nil
    var realSue: Substring? = nil
    while let line = readLine() {
      let sueNumber = line.firstMatch(of: sueEx)!.number

      let compoundMatches = line.matches(of: compoundRegex)
      if compoundMatches
        .makeIterator()
        .allSatisfy({ analysis[String($0.compound)]!.0 == Int($0.numKinds)! })
      {
        correctSue = sueNumber
      }
      if compoundMatches
        .makeIterator()
        .allSatisfy({
          let compound = String($0.compound)
          let numKinds = Int($0.numKinds)!
          let (tested, comparisonType) = analysis[compound]!
          return switch comparisonType {
          case .fewerThan: numKinds < tested
          case .greaterThan: numKinds > tested
          case .equalTo: numKinds == tested
          }
        })
      {
        realSue = sueNumber
      }
    }

    print("Part One: \(correctSue!)")

    print("Part Two: \(realSue!)")
  }
}
