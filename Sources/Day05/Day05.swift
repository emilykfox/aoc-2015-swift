import Foundation

struct Pair: Hashable {
  let first: Character
  let second: Character
}

@main
struct Day05 {
  static func main() {
    var niceStrings = 0
    var nicerStrings = 0
    while let string = readLine(strippingNewline: true) {
      var numVowels = 0
      var doubleLetter = false
      var badPairs = false

      var repeatPair = false
      var closeRepeat = false

      var lastLetter: Character? = nil
      var secondLastLetter: Character? = nil

      var pairSightings: [Pair: Int] = [:]

      for (index, letter) in string.enumerated() {
        if ["a", "e", "i", "o", "u"].contains(letter) {
          numVowels += 1
        }
        if letter == lastLetter {
          doubleLetter = true
        }
        if let lastLetter {
          let pair = (lastLetter, letter)
          if pair == ("a", "b") || pair == ("c", "d") || pair == ("p", "q") || pair == ("x", "y") {
            badPairs = true
          }

          let hashPair = Pair(first: lastLetter, second: letter)
          if let sighting = pairSightings[hashPair] {
            if sighting <= index - 2 {
              repeatPair = true
            }
          } else {
            pairSightings[hashPair] = index
          }

          if let secondLastLetter {
            if secondLastLetter == letter {
              closeRepeat = true
            }
          }
        }

        secondLastLetter = lastLetter
        lastLetter = letter
      }

      if numVowels >= 3 && doubleLetter && !badPairs {
        niceStrings += 1
      }
      if repeatPair && closeRepeat {
        nicerStrings += 1
      }
    }

    print("Part One: \(niceStrings)")
    print("Part Two: \(nicerStrings)")
  }
}
