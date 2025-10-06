import Foundation

@main
struct Day20 {
  static func main() throws {
    let target = Int(readLine()!)!
    let startAt = Int(sqrt(Double(target) / 10))

    var targetHouse = Int?.none
    for house in startAt... {
      let houseTotal = (1...Int(sqrt(Double(house))))
        .map({ (elf) in if house % elf == 0 { 10 * elf + 10 * (house / elf) } else { 0 } })
        .reduce(0, +)
      if houseTotal >= target {
        targetHouse = house
        break
      }
    }

    print("Part One: \(targetHouse!)")

    let nextStartAt = Int(sqrt(Double(target) / 11))
    targetHouse = Int?.none
    for house in nextStartAt... {
      let houseTotal = (1...Int(sqrt(Double(house))))
        .map({ (elf) in
          if house % elf == 0 {
            var total = 0
            if house / elf <= 50 {
              total += 11 * elf
            }
            if elf <= 50 {
              total += 11 * (house / elf)
            }
            return total
          } else {
            return 0
          }
        })
        .reduce(0, +)
      if houseTotal >= target {
        targetHouse = house
        break
      }
    }

    print("Part Two: \(targetHouse!)")
  }
}
