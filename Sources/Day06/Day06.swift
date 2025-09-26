import Foundation
import RegexBuilder

enum Instruction: String {
  case turnOn = "turn on"
  case turnOff = "turn off"
  case toggle = "toggle"
}

@main
struct Day06 {
  static func main() {

    let instructionRef = Reference<Instruction>()
    let lowColumnRef = Reference<Int>()
    let lowRowRef = Reference<Int>()
    let highColumnRef = Reference<Int>()
    let highRowRef = Reference<Int>()
    let regex = Regex {
      Anchor.startOfSubject
      Capture(as: instructionRef) {
        ChoiceOf {
          "turn on"
          "turn off"
          "toggle"
        }
      } transform: {
        Instruction(rawValue: String($0))!
      }
      " "
      Capture(as: lowColumnRef) {
        OneOrMore(.digit)
      } transform: {
        Int($0)!
      }
      ","
      Capture(as: lowRowRef) {
        OneOrMore(.digit)
      } transform: {
        Int($0)!
      }
      " through "
      Capture(as: highColumnRef) {
        OneOrMore(.digit)
      } transform: {
        Int($0)!
      }
      ","
      Capture(as: highRowRef) {
        OneOrMore(.digit)
      } transform: {
        Int($0)!
      }
      Anchor.endOfSubject
    }

    var lit = InlineArray<1000, InlineArray<1000, Bool>>(
      repeating: InlineArray<1000, Bool>(repeating: false))
    var brightness = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

    while let line = readLine() {
      guard let match = line.firstMatch(of: regex) else { continue }
      for row in match[lowRowRef]...match[highRowRef] {
        for column in match[lowColumnRef]...match[highColumnRef] {
          switch match[instructionRef] {
          case .turnOff:
            lit[row][column] = false
            brightness[row][column] = max(brightness[row][column], 1) - 1
          case .turnOn:
            lit[row][column] = true
            brightness[row][column] += 1
          case .toggle:
            lit[row][column].toggle()
            brightness[row][column] += 2
          }
        }
      }
    }

    var numLit = 0
    var totalBrightness = 0
    for row in lit.indices {
      for column in lit[row].indices {
        if lit[row][column] {
          numLit += 1
        }
        totalBrightness += brightness[row][column]
      }
    }
    print("Part One: \(numLit)")
    print("Part Two: \(totalBrightness)")
  }
}
