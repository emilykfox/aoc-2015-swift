import Foundation

@main
struct Day11 {
  static func main() {
    let password = readLine()!

    var firstPassword: String?
    var secondPassword: String?

    var candidate = [UnicodeScalar](password.unicodeScalars)
    while true {
      candidate = nextPassword(candidate)
      var straight = false
      var confusingLetter = false
      var twoPairs = false
      var firstPairEnd: Int? = nil
      for index in 0..<8 {
        if ["i", "o", "l"].contains(candidate[index]) {
          confusingLetter = true
          break
        }

        if index > 0 && candidate[index - 1] == candidate[index] {
          if let firstPairEnd {
            if firstPairEnd < index - 1 {
              twoPairs = true
            }
          } else {
            firstPairEnd = index
          }
        }

        if index > 1 && candidate[index - 2].value == candidate[index - 1].value - 1
          && candidate[index - 1].value == candidate[index].value - 1
        {
          straight = true
        }
      }

      if straight && !confusingLetter && twoPairs {
        if firstPassword == nil {
          firstPassword = String(String.UnicodeScalarView(candidate))
        } else {
          secondPassword = String(String.UnicodeScalarView(candidate))
          break
        }
      }
    }

    print("Part One: \(firstPassword!)")

    print("Part Two: \(secondPassword!)")
  }

  static func nextPassword(_ password: [UnicodeScalar]) -> [UnicodeScalar] {
    precondition(password.count == 8)

    var index = 7
    var newPassword = password
    while true {
      if newPassword[index] == UnicodeScalar("z") {
        newPassword[index] = UnicodeScalar("a")
        index -= 1
      } else {
        newPassword[index] = UnicodeScalar(newPassword[index].value + 1)!
        break
      }
    }

    return newPassword
  }
}
