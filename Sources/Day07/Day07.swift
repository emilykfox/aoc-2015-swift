import Foundation

struct Wire {
  enum Incoming {
    case input(UInt16)
    case wire(String)
  }
  enum Gate {
    case direct(Incoming)
    case and((Incoming, Incoming))
    case or((Incoming, Incoming))
    case lShift((Incoming, Int))
    case rShift((Incoming, Int))
    case not((Incoming))
  }

  var signal: UInt16? = nil
  let inputs: Gate
}

@main
struct Day07 {
  static func main() {
    let re =
      /^(?:(?<direct>\w+)|(?<binary>(?<left>\w+) (?:(?<and>AND)|(?<or>OR)) (?<right>\w+))|(?<shift>(?<toShift>\w+) (?:(?<lShift>LSHIFT)|(?<rShift>RSHIFT)) (?<shiftAmount>\d+))|(?<not>NOT (?<negated>\w+))) -> (?<to>\w+)$/
    var wires: [String: Wire] = [:]
    var numPendingInputs: [String: Int] = [:]
    var neededFor: [String: [String]] = [:]
    var toProcess: [String] = []
    while let instruction = readLine() {
      let match = instruction.firstMatch(of: re)!
      let to = String(match.to)
      numPendingInputs[to] = 0
      var wire: Wire

      let makeIncoming = { (string: Substring) -> Wire.Incoming in
        if let input = UInt16(string) {
          return .input(input)
        } else {
          numPendingInputs[to]! += 1
          neededFor[String(string), default: []].append(to)
          return .wire(String(string))
        }
      }

      if let direct = match.direct {
        wire = Wire(inputs: .direct(makeIncoming(direct)))
      } else if match.binary != nil {
        let left = makeIncoming(match.left!)
        let right = makeIncoming(match.right!)

        if match.and != nil {
          wire = Wire(inputs: .and((left, right)))
        } else {
          _ = match.or!
          wire = Wire(inputs: .or((left, right)))
        }
      } else if match.shift != nil {
        let toShift = makeIncoming(match.toShift!)
        let shiftAmount = Int(match.shiftAmount!)!

        if match.lShift != nil {
          wire = Wire(inputs: .lShift((toShift, shiftAmount)))
        } else {
          _ = match.rShift!
          wire = Wire(inputs: .rShift((toShift, shiftAmount)))
        }
      } else {
        _ = match.not!
        let negated = makeIncoming(match.negated!)

        wire = Wire(inputs: .not(negated))
      }

      wires[to] = wire
      if case .direct(.input(_)) = wire.inputs {
        toProcess.append(to)
      }
    }

    let fetchIncoming = { (incoming: Wire.Incoming) -> UInt16 in
      switch incoming {
      case .input(let signal): signal
      case .wire(let name): wires[name]!.signal!
      }
    }
    while let wireName = toProcess.popLast() {
      var wire = wires[wireName]!
      switch wire.inputs {
      case .direct(let direct): wire.signal = fetchIncoming(direct)
      case .and((let left, let right)):
        wire.signal = fetchIncoming(left) & fetchIncoming(right)
      case .or((let left, let right)):
        wire.signal = fetchIncoming(left) | fetchIncoming(right)
      case .lShift((let toShift, let shiftAmount)):
        wire.signal = fetchIncoming(toShift) << shiftAmount
      case .rShift((let toShift, let shiftAmount)):
        wire.signal = fetchIncoming(toShift) >> shiftAmount
      case .not(let negated):
        wire.signal = ~fetchIncoming(negated)
      }

      wires[wireName] = wire

      if let needings = neededFor[wireName] {
        for needing in needings {
          numPendingInputs[needing]! -= 1
          if numPendingInputs[needing]! == 0 {
            toProcess.append(needing)
          }
        }
      }
    }

    print("Part One: \(wires["a"]!.signal!)")
    // print("Part Two: \(totalBrightness)")
  }
}
