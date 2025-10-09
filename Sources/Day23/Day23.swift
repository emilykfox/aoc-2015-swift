import Foundation

@main
struct Day23 {
  static func main() throws {
    var lines = [String]()
    while let line = readLine() {
      lines.append(line)
    }

    var registers = [Character("a"): 0, Character("b"): 0]
    var PC = 0

    while PC < lines.count {
      let pieces = lines[PC].split(separator: " ")
      switch pieces[0] {
      case "hlf":
        registers[pieces[1].first!]! /= 2
        PC += 1
      case "tpl":
        registers[pieces[1].first!]! *= 3
        PC += 1
      case "inc":
        registers[pieces[1].first!]! += 1
        PC += 1
      case "jmp":
        PC += Int(pieces[1])!
      case "jie":
        if registers[pieces[1].first!]! % 2 == 0 {
          PC += Int(pieces[2])!
        } else {
          PC += 1
        }
      case "jio":
        if registers[pieces[1].first!]! == 1 {
          PC += Int(pieces[2])!
        } else {
          PC += 1
        }
      default:
        assertionFailure("Bad instruction!")
      }
    }

    print("Part One: \(registers["b"]!)")

    registers = [Character("a"): 1, Character("b"): 0]
    PC = 0

    while PC < lines.count {
      let pieces = lines[PC].split(separator: " ")
      switch pieces[0] {
      case "hlf":
        registers[pieces[1].first!]! /= 2
        PC += 1
      case "tpl":
        registers[pieces[1].first!]! *= 3
        PC += 1
      case "inc":
        registers[pieces[1].first!]! += 1
        PC += 1
      case "jmp":
        PC += Int(pieces[1])!
      case "jie":
        if registers[pieces[1].first!]! % 2 == 0 {
          PC += Int(pieces[2])!
        } else {
          PC += 1
        }
      case "jio":
        if registers[pieces[1].first!]! == 1 {
          PC += Int(pieces[2])!
        } else {
          PC += 1
        }
      default:
        assertionFailure("Bad instruction!")
      }
    }
    print("Part Two: \(registers["b"]!)")
  }
}
