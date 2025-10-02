import Foundation

class Reindeer {
  let speed: Int
  let flyDuration: Int
  let restDuration: Int

  var flyingFor: Int = 0
  var restingFor: Int
  var totalDistance: Int = 0

  var totalPoints: Int = 0

  init(speed: Int, flyDuration: Int, restDuration: Int) {
    self.speed = speed
    self.flyDuration = flyDuration
    self.restDuration = restDuration

    self.restingFor = restDuration
  }
}

@main
struct Day14 {
  static func main() throws {
    let regex =
      #/^\w+ can fly (?<speed>\d+) km/s for (?<flyDuration>\d+) seconds, but then must rest for (?<restDuration>\d+) seconds.$/#

    var reindeer = [Reindeer]()
    while let line = readLine() {
      let match = line.firstMatch(of: regex)!
      reindeer.append(
        Reindeer(
          speed: Int(match.speed)!, flyDuration: Int(match.flyDuration)!,
          restDuration: Int(match.restDuration)!))
    }

    for _ in 0..<2503 {
      for deer in reindeer {
        if deer.restingFor == deer.restDuration {
          deer.restingFor = 0
          deer.flyingFor = 0
        }

        if deer.flyingFor == deer.flyDuration {
          deer.restingFor += 1
        } else {
          deer.totalDistance += deer.speed
          deer.flyingFor += 1
        }
      }

      let winningDistance = reindeer.makeIterator().map({ $0.totalDistance }).max()!
      for deer in reindeer {
        if deer.totalDistance == winningDistance {
          deer.totalPoints += 1
        }
      }
    }

    let maxDistance = reindeer.makeIterator().map({ $0.totalDistance }).max()!

    print("Part One: \(maxDistance)")

    let maxPoints = reindeer.makeIterator().map({ $0.totalPoints }).max()!
    print("Part Two: \(maxPoints)")
  }
}
