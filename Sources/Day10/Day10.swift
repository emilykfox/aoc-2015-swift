import Foundation

@main
struct Day10 {
  static func main() {
    let start = readLine(strippingNewline: true)!
    var current = start
    var atForty: Int? = nil
    for i in 0..<50 {
      var next = String()
      var reading: Character? = nil
      var numRead = 0
      for character in current {
        if character == reading {
          numRead += 1
        } else {
          if let reading {
            next.append(contentsOf: "\(numRead)\(reading)")
          }
          reading = character
          numRead = 1
        }
      }
      next.append(contentsOf: "\(numRead)\(reading!)")

      current = next
      if i == 39 {
        atForty = current.count
      }
    }

    print("Part One: \(atForty!)")

    print("Part Two: \(current.count)")
  }
}
