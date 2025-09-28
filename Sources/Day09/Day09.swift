import Foundation

struct LocationPair: Hashable {
  let first: String
  let second: String
}

struct BestTotalKey: Hashable {
  let startIndex: Int
  let toCover: [Bool]
}

@main
struct Day09 {
  static func main() {
    let regex = /(?<first>\w+) to (?<second>\w+) = (?<distance>\d+)/

    var locations = Set<String>()
    var distances: [LocationPair: Int] = [:]

    while let line = readLine(strippingNewline: true) {
      let matches = line.firstMatch(of: regex)!
      let first = String(matches.first)
      let second = String(matches.second)
      let distance = Int(matches.distance)!

      distances[LocationPair(first: first, second: second)] = distance
      distances[LocationPair(first: second, second: first)] = distance

      locations.insert(first)
      locations.insert(second)
    }

    let orderedLocations = Array(locations)
    var bestTotalTable: [BestTotalKey: Int] = [:]
    var worstTotalTable: [BestTotalKey: Int] = [:]

    func bestTotal(startIndex: Int, toCover: [Bool]) -> Int {
      precondition(toCover[startIndex])

      let bestTotalKey = BestTotalKey(startIndex: startIndex, toCover: toCover)
      if let memoized = bestTotalTable[bestTotalKey] {
        return memoized
      }

      var answer: Int
      if toCover.filter({ $0 }).count == 1 {
        answer = 0
      } else {
        answer = Int.max
      }

      let startLocation = orderedLocations[startIndex]

      var newToCover = toCover
      newToCover[startIndex] = false
      for (candidateIndex, _) in toCover.enumerated().filter({ index, included in
        included && index != startIndex
      }) {
        let firstStop = orderedLocations[candidateIndex]
        answer = min(
          answer,
          distances[LocationPair(first: startLocation, second: firstStop)]!
            + bestTotal(startIndex: candidateIndex, toCover: newToCover))
      }

      bestTotalTable[bestTotalKey] = answer
      return answer
    }

    func worstTotal(startIndex: Int, toCover: [Bool]) -> Int {
      precondition(toCover[startIndex])

      let bestTotalKey = BestTotalKey(startIndex: startIndex, toCover: toCover)
      if let memoized = worstTotalTable[bestTotalKey] {
        return memoized
      }

      var answer: Int
      if toCover.filter({ $0 }).count == 1 {
        answer = 0
      } else {
        answer = Int.min
      }

      let startLocation = orderedLocations[startIndex]

      var newToCover = toCover
      newToCover[startIndex] = false
      for (candidateIndex, _) in toCover.enumerated().filter({ index, included in
        included && index != startIndex
      }) {
        let firstStop = orderedLocations[candidateIndex]
        answer = max(
          answer,
          distances[LocationPair(first: startLocation, second: firstStop)]!
            + worstTotal(startIndex: candidateIndex, toCover: newToCover))
      }

      worstTotalTable[bestTotalKey] = answer
      return answer
    }

    let toCover = Array(repeating: true, count: orderedLocations.count)
    var answer = Int.max
    for startIndex in 0..<orderedLocations.count {
      answer = min(
        answer, bestTotal(startIndex: startIndex, toCover: toCover))
    }

    print("Part One: \(answer)")

    var awful = Int.min
    for startIndex in 0..<orderedLocations.count {
      awful = max(
        answer, worstTotal(startIndex: startIndex, toCover: toCover))
    }

    print("Part Two: \(awful)")
  }
}
