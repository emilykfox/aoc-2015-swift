import Foundation

let s: InlineArray<64, UInt8> = [
  7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
  5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
  4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
  6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21,
]

let k: InlineArray<64, UInt32> = InlineArray<64, UInt32> {
  UInt32(Double(1 << 32) * abs(sin(Double($0 + 1))))
}

let initialA: UInt32 = 0x6745_2301
let initialB: UInt32 = 0xefcd_ab89
let initialC: UInt32 = 0x98ba_dcfe
let initialD: UInt32 = 0x1032_5476

func leftRotate(_ x: UInt32, _ s: UInt8) -> UInt32 {
  x << s | x >> (32 - s)
}

public func md5(_ bytes: some Sequence<UInt8>) -> UInt128 {
  // Uses algorithm and notation as given on Wikipedia plus streaming code by the file author.

  var a0 = initialA
  var b0 = initialB
  var c0 = initialC
  var d0 = initialD

  var iter = bytes.makeIterator()
  var totalLength: UInt64 = 0
  var doneReading = false
  var startedLength = false
  while !startedLength {
    var m = InlineArray<16, UInt32>(repeating: 0)
    for j in 0..<16 {
      if doneReading {
        if j == 14 {
          startedLength = true
          m[j] = UInt32(totalLength)
        } else if j == 15 && startedLength {
          m[j] = UInt32(totalLength >> 32)
        }
      } else {
        for wordByte in 0..<4 {
          var byte: UInt8
          if let readByte = iter.next() {
            byte = readByte
            totalLength = totalLength &+ 8
          } else if !doneReading {
            doneReading = true
            byte = 0x80
          } else {
            byte = 0
          }
          m[j] |= (UInt32(byte) << (8 * wordByte))
        }
      }
    }

    var (a, b, c, d) = (a0, b0, c0, d0)
    for i in 0..<64 {
      var f: UInt32
      var g: Int
      switch i {
      case 0..<16:
        f = b & c | ~b & d
        g = i
      case 16..<32:
        f = d & b | ~d & c
        g = (5 * i + 1) % 16
      case 32..<48:
        f = b ^ c ^ d
        g = (3 * i + 5) % 16
      default:
        f = c ^ (b | ~d)
        g = (7 * i) % 16
      }

      f = f &+ a &+ k[i] &+ m[g]
      a = d
      d = c
      c = b
      b = b &+ leftRotate(f, s[i])
    }

    a0 &+= a
    b0 &+= b
    c0 &+= c
    d0 &+= d
  }

  return UInt128(a0) | (UInt128(b0) << 32) | (UInt128(c0) << 64) | (UInt128(d0) << 96)
}
