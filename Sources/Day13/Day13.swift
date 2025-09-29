import Algorithms
import Foundation

@main
struct Day13 {
  static func main() throws {
    let regex =
      /^(?<subject>\w+) would (?:(?<gain>gain)|(?<lose>lose)) (?<number>\d+) happiness units by sitting next to (?<object>\w+).$/

    var lines = [String]()
    while let line = readLine() {
      lines.append(line)
    }

    var changes = [Substring: [Substring: Int]]()

    for line in lines {
      let match = line.firstMatch(of: regex)!

      let number = Int(match.number)!
      let change = if match.gain != nil { number } else { -number }
      changes[match.subject, default: [:]][match.object] = change
    }

    let guests = Array(changes.keys)

    var maxHappiness = Int.min
    for permutation in guests.permutations() {
      let happiness: Int = (1..<permutation.count).map({
        changes[permutation[$0 - 1]]![permutation[$0]]! + changes[permutation[$0]]![
          permutation[$0 - 1]]!
      })
      .reduce(
        changes[permutation[permutation.count - 1]]![permutation[0]]! + changes[permutation[0]]![
          permutation[permutation.count - 1]]!, +)

      maxHappiness = max(maxHappiness, happiness)
    }

    print("Part One: \(maxHappiness)")

    var maxHappinessWithMe = Int.min
    for permutation in guests.permutations() {
      let happiness: Int = (1..<permutation.count).map({
        changes[permutation[$0 - 1]]![permutation[$0]]! + changes[permutation[$0]]![
          permutation[$0 - 1]]!
      })
      .reduce(
        0, +)

      maxHappinessWithMe = max(maxHappinessWithMe, happiness)
    }

    print("Part Two: \(maxHappinessWithMe)")
  }
}
