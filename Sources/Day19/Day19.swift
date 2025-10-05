import Foundation
import RegexBuilder

struct MemoParams: Hashable {
  let targetStart: Int
  let targetEnd: Int
  let source: [String]
  let sourceChoiceStart: Int
}

@main
struct Day19 {
  static func main() throws {
    let elementRegex = /[A-Z][a-z]?/

    let sequence = Reference([String].self)
    let elementSequence = Regex {
      Capture(as: sequence) {
        OneOrMore(elementRegex)
      } transform: { (substring) in
        Array(substring.matches(of: elementRegex).map { String($0.0) })
      }
    }

    let input = Reference(String.self)
    let output = Reference([String].self)
    let replacementRegex = Regex {
      Anchor.startOfSubject
      Capture(OneOrMore(.word), as: input, transform: { String($0) })
      " => "
      Capture(
        elementSequence, as: output,
        transform: { (substring) in
          substring.firstMatch(of: elementSequence)![sequence]
        })
      Anchor.endOfSubject
    }

    var replacements = [String: [[String]]]()
    var antireplacements = [[String]: String]()
    while let line = readLine() {
      if line.isEmpty {
        break
      }

      let match = line.firstMatch(of: replacementRegex)!
      replacements[match[input], default: []].append(match[output])
      antireplacements[match[output]] = match[input]
    }

    let line = readLine()!
    let medicine = line.firstMatch(of: elementSequence)![sequence]

    var distinctMolecules = Set<[String]>()
    for (index, element) in medicine.enumerated() {
      for replacement in replacements[element, default: []] {
        var newMolecule = medicine
        newMolecule.replaceSubrange(index...index, with: replacement)
        distinctMolecules.insert(newMolecule)
      }
    }

    print("Part One: \(distinctMolecules.count)")

    var memoTable = [MemoParams: Int?]()
    func fewestSteps(_ params: MemoParams) -> Int? {
      if memoTable[params] == Optional<Int?>.none {
        if params.targetStart == params.targetEnd && params.source.count == 1 {
          if params.source[0] == medicine[params.targetStart] {
            memoTable[params] = 0
          } else {
            memoTable[params] = Int?.none
          }
        } else if params.source.count == 1 {
          var best = Int?.none
          for replacement in replacements[params.source[0], default: []] {
            let newParams = MemoParams(
              targetStart: params.targetStart, targetEnd: params.targetEnd, source: replacement,
              sourceChoiceStart: 0)
            if let attempt = fewestSteps(newParams) {
              best = min(attempt + 1, best ?? Int.max)
            }
          }
          memoTable[params] = best
        } else if params.sourceChoiceStart == params.source.count - 1 {
          let newParams = MemoParams(
            targetStart: params.targetStart, targetEnd: params.targetEnd,
            source: [params.source[params.sourceChoiceStart]],
            sourceChoiceStart: 0)
          memoTable[params] = fewestSteps(newParams)
        } else {
          var best = Int?.none
          for prefixEnd in params.targetStart..<params.targetEnd {
            let prefixParams = MemoParams(
              targetStart: params.targetStart, targetEnd: prefixEnd,
              source: [params.source[params.sourceChoiceStart]], sourceChoiceStart: 0)
            if let leftAttempt = fewestSteps(prefixParams) {
              let suffixParams = MemoParams(
                targetStart: prefixEnd + 1, targetEnd: params.targetEnd, source: params.source,
                sourceChoiceStart: params.sourceChoiceStart + 1)
              if let rightAttempt = fewestSteps(suffixParams) {
                best = min(leftAttempt + rightAttempt, best ?? Int.max)
              }
            }
          }
          memoTable[params] = best
        }
      }

      return memoTable[params]!
    }

    let initialParams = MemoParams(
      targetStart: 0, targetEnd: medicine.count - 1, source: ["e"], sourceChoiceStart: 0)
    print("Part Two: \(fewestSteps(initialParams)!)")
  }
}
