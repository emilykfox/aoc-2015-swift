import Foundation

struct Item {
  let cost: Int
  let damage: Int
  let armor: Int
}

struct FighterStats {
  let hitPoints: Int
  let damage: Int
  let armor: Int
}

@main
struct Day21 {
  static let shopDetails: String = """
    Weapons:    Cost  Damage  Armor
    Dagger        8     4       0
    Shortsword   10     5       0
    Warhammer    25     6       0
    Longsword    40     7       0
    Greataxe     74     8       0
    \n\
    Armor:      Cost  Damage  Armor
    Leather      13     0       1
    Chainmail    31     0       2
    Splintmail   53     0       3
    Bandedmail   75     0       4
    Platemail   102     0       5
    \n\
    Rings:      Cost  Damage  Armor
    Damage +1    25     1       0
    Damage +2    50     2       0
    Damage +3   100     3       0
    Defense +1   20     0       1
    Defense +2   40     0       2
    Defense +3   80     0       3
    """
  static func main() throws {
    let shopLines = shopDetails.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
    var shopIterator = shopLines.makeIterator()
    let itemRegex = /^\w+(?: \+\d)?\s+(?<cost>\d+)\s+(?<damage>\d+)\s+(?<armor>\d+)$/

    var weapons = [Item]()
    _ = shopIterator.next()
    while let line = shopIterator.next() {
      if line.isEmpty {
        break
      }
      let match = line.firstMatch(of: itemRegex)!
      weapons.append(
        Item(cost: Int(match.cost)!, damage: Int(match.damage)!, armor: Int(match.armor)!))
    }

    var armor = [Item(cost: 0, damage: 0, armor: 0)]
    _ = shopIterator.next()
    while let line = shopIterator.next() {
      if line.isEmpty {
        break
      }
      let match = line.firstMatch(of: itemRegex)!
      armor.append(
        Item(cost: Int(match.cost)!, damage: Int(match.damage)!, armor: Int(match.armor)!))
    }

    var rings = [
      Item(cost: 0, damage: 0, armor: 0),
      Item(cost: 0, damage: 0, armor: 0),
    ]
    _ = shopIterator.next()
    while let line = shopIterator.next() {
      let match = line.firstMatch(of: itemRegex)!
      rings.append(
        Item(cost: Int(match.cost)!, damage: Int(match.damage)!, armor: Int(match.armor)!))
    }

    let bossHitPoints = Int(readLine()!.firstMatch(of: /\d+/)!.0)!
    let bossDamage = Int(readLine()!.firstMatch(of: /\d+/)!.0)!
    let bossArmor = Int(readLine()!.firstMatch(of: /\d+/)!.0)!
    let boss = FighterStats(hitPoints: bossHitPoints, damage: bossDamage, armor: bossArmor)

    var minCost = Int?.none
    for weapon in weapons {
      for armor in armor {
        for leftRingIndex in 0..<(rings.count - 1) {
          for rightRingIndex in (leftRingIndex + 1)..<rings.count {
            let cost =
              weapon.cost + armor.cost + rings[leftRingIndex].cost + rings[rightRingIndex].cost
            let damage =
              weapon.damage + armor.damage + rings[leftRingIndex].damage
              + rings[rightRingIndex].damage
            let armor =
              weapon.armor + armor.armor + rings[leftRingIndex].armor + rings[rightRingIndex].armor
            let player = FighterStats(hitPoints: 100, damage: damage, armor: armor)
            if win(player: player, boss: boss) {
              minCost = min(cost, minCost ?? Int.max)
            }
          }
        }
      }
    }

    print("Part One: \(minCost!)")

    var maxCost = Int?.none
    for weapon in weapons {
      for armor in armor {
        for leftRingIndex in 0..<(rings.count - 1) {
          for rightRingIndex in (leftRingIndex + 1)..<rings.count {
            let cost =
              weapon.cost + armor.cost + rings[leftRingIndex].cost + rings[rightRingIndex].cost
            let damage =
              weapon.damage + armor.damage + rings[leftRingIndex].damage
              + rings[rightRingIndex].damage
            let armor =
              weapon.armor + armor.armor + rings[leftRingIndex].armor + rings[rightRingIndex].armor
            let player = FighterStats(hitPoints: 100, damage: damage, armor: armor)
            if !win(player: player, boss: boss) {
              maxCost = max(cost, maxCost ?? Int.min)
            }
          }
        }
      }
    }

    print("Part Two: \(maxCost!)")
  }

  static func win(player: FighterStats, boss: FighterStats) -> Bool {
    var playerHitPoints = player.hitPoints
    var bossHitPoints = boss.hitPoints

    while true {
      bossHitPoints -= max(player.damage - boss.armor, 1)
      if bossHitPoints <= 0 {
        return true
      }

      playerHitPoints -= max(boss.damage - player.armor, 1)
      if playerHitPoints <= 0 {
        return false
      }
    }
  }
}
