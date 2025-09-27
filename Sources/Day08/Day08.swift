import Foundation

@main
struct Day08 {
  static func main() {
    var totalCode = 0
    var totalValues = 0
    var totalReencoded = 0
    while let literal = readLine(strippingNewline: true) {
      var characters = literal.makeIterator()

      totalCode += 1  // "
      _ = characters.next()

      while let character = characters.next() {
        totalCode += 1
        if character != "\"" {
          totalValues += 1
        }

        if character == "\\" {
          totalCode += 1
          let escaped = characters.next()
          if escaped == "x" {
            totalCode += 2
            _ = characters.next()
            _ = characters.next()
          }
        }
      }

      totalReencoded += 2 + literal.count + literal.count(where: { $0 == "\\" || $0 == "\"" })
    }

    let waste = totalCode - totalValues
    print("Part One: \(waste)")

    let superWaste = totalReencoded - totalCode
    print("Part Two: \(superWaste)")
  }
}
