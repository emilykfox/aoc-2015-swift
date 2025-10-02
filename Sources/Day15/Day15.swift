import Foundation

struct Ingredient {
  let capacity: Int
  let durability: Int
  let flavor: Int
  let texture: Int

  let calories: Int
}

@main
struct Day15 {
  static func main() throws {
    let regex =
      /^\w+: capacity (?<capacity>-?\d+), durability (?<durability>-?\d+), flavor (?<flavor>-?\d+), texture (?<texture>-?\d+), calories (?<calories>\d+)$/

    var ingredients = [Ingredient]()

    while let line = readLine() {
      let matches = line.firstMatch(of: regex)!
      ingredients.append(
        Ingredient(
          capacity: Int(matches.capacity)!,
          durability: Int(matches.durability)!,
          flavor: Int(matches.flavor)!,
          texture: Int(matches.texture)!,
          calories: Int(matches.calories)!,
        ))
    }

    func bestCookie(measurements: [Int], goal: Int? = nil) -> Int? {
      if measurements.count == ingredients.count {
        var capacity = 0
        var durability = 0
        var flavor = 0
        var texture = 0
        var calories = 0
        for index in 0..<ingredients.count {
          capacity += measurements[index] * ingredients[index].capacity
          durability += measurements[index] * ingredients[index].durability
          flavor += measurements[index] * ingredients[index].flavor
          texture += measurements[index] * ingredients[index].texture
          calories += measurements[index] * ingredients[index].calories
        }

        if goal == nil || calories == goal! {
          return max(capacity, 0) * max(durability, 0) * max(flavor, 0) * max(texture, 0)
        } else {
          return nil
        }
      }

      let room = 100 - measurements.makeIterator().reduce(0, +)
      if measurements.count == ingredients.count - 1 {
        var moreMeasurements = measurements
        moreMeasurements.append(room)
        return bestCookie(measurements: moreMeasurements, goal: goal)
      } else {
        var best: Int? = nil
        for next in 0...room {
          var moreMeasurements = measurements
          moreMeasurements.append(next)
          let attempt = bestCookie(measurements: moreMeasurements, goal: goal)
          if let attempt {
            if best == nil {
              best = attempt
            } else {
              best = max(best!, attempt)
            }
          }
        }
        return best
      }
    }

    let best = bestCookie(measurements: [Int]())!
    print("Part One: \(best)")

    let bestDiet = bestCookie(measurements: [Int](), goal: 500)!
    print("Part Two: \(bestDiet)")
  }
}
