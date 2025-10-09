import Foundation

@main
struct Day24 {
  static func main() throws {
    var weights = [Int]()
    while let line = readLine() {
      weights.append(Int(line)!)
    }
    let groupTarget = weights.reduce(0, +) / 3

    var minEntanglements = [[[(Int, Int)??]]](
      repeating: [[(Int, Int)??]](
        repeating: [(Int, Int)??](repeating: nil, count: weights.count + 1), count: groupTarget + 1),
      count: groupTarget + 1)  // [group 1 weight][group 2 weight][lowest index]
    minEntanglements[0][0][weights.count] = (0, 1)
    for group1Target in (0...groupTarget) {
      for group2Target in (0...groupTarget) {
        if group1Target != 0 || group2Target != 0 {
          minEntanglements[group1Target][group2Target][weights.count] = (Int, Int)?.none
        }
        for minIndex in (0..<weights.count).reversed() {
          var best = minEntanglements[group1Target][group2Target][minIndex + 1]!
          if weights[minIndex] <= group2Target {
            if let try2 = minEntanglements[group1Target][group2Target - weights[minIndex]][
              minIndex + 1]!
            {
              if let bestUnwrapped = best {
                if try2.0 < bestUnwrapped.0
                  || (try2.0 == bestUnwrapped.0 && try2.1 < bestUnwrapped.1)
                {
                  best = try2
                }
              } else {
                best = try2
              }
            }
          }
          if weights[minIndex] <= group1Target {
            if let try1 = minEntanglements[group1Target - weights[minIndex]][group2Target][
              minIndex + 1]!
            {
              let try1Total = (try1.0 + 1, try1.1 * weights[minIndex])
              if let bestUnwrapped = best {
                if try1Total.0 < bestUnwrapped.0
                  || (try1Total.0 == bestUnwrapped.0 && try1Total.1 < bestUnwrapped.1)
                {
                  best = try1Total
                }
              } else {
                best = try1Total
              }
            }
          }
          minEntanglements[group1Target][group2Target][minIndex] = best
        }
      }
    }

    print("Part One: \(minEntanglements[groupTarget][groupTarget][0]!!.1)")

    let quadTarget = weights.reduce(0, +) / 4

    let newLayer = [[[(UInt8, Int)??]]](
      repeating: [[(UInt8, Int)??]](
        repeating: [(UInt8, Int)??](
          repeating: (UInt8, Int)??.none,
          count: quadTarget + 1
        ),
        count: quadTarget + 1), count: quadTarget + 1)  // [group 1 weight][group 2 weight][group 3 weight][lowest index]
    var prevLayer = newLayer
    for group1Target in (0...quadTarget) {
      for group2Target in (0...quadTarget) {
        for group3Target in (0...quadTarget) {
          prevLayer[group1Target][group2Target][group3Target] =
            (UInt8, Int)?.none
        }
      }
    }
    prevLayer[0][0][0] = (0, 1)
    for minIndex in (0..<weights.count).reversed() {
      var currentLayer = newLayer
      for group1Target in (0...quadTarget) {
        for group2Target in (0...quadTarget) {
          for group3Target in (0...quadTarget) {
            var best = prevLayer[group1Target][group2Target][group3Target]!
            if weights[minIndex] <= group3Target {
              if let try3 = prevLayer[group1Target][group2Target][group3Target - weights[minIndex]]!
              {
                if let bestUnwrapped = best {
                  if try3.0 < bestUnwrapped.0
                    || (try3.0 == bestUnwrapped.0 && try3.1 < bestUnwrapped.1)
                  {
                    best = try3
                  }
                } else {
                  best = try3
                }
              }
            }
            if weights[minIndex] <= group2Target {
              if let try2 = prevLayer[group1Target][group2Target - weights[minIndex]][group3Target]!
              {
                if let bestUnwrapped = best {
                  if try2.0 < bestUnwrapped.0
                    || (try2.0 == bestUnwrapped.0 && try2.1 < bestUnwrapped.1)
                  {
                    best = try2
                  }
                } else {
                  best = try2
                }
              }
            }
            if weights[minIndex] <= group1Target {
              if let try1 = prevLayer[group1Target - weights[minIndex]][group2Target][group3Target]!
              {
                let try1Total = (try1.0 + 1, try1.1 * weights[minIndex])
                if let bestUnwrapped = best {
                  if try1Total.0 < bestUnwrapped.0
                    || (try1Total.0 == bestUnwrapped.0 && try1Total.1 < bestUnwrapped.1)
                  {
                    best = try1Total
                  }
                } else {
                  best = try1Total
                }
              }
            }
            currentLayer[group1Target][group2Target][group3Target] = best
          }
        }
      }
      prevLayer = currentLayer
    }

    print("Part Two: \(prevLayer[quadTarget][quadTarget][quadTarget]!!.1)")
  }
}
