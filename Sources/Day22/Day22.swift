import Foundation

struct FighterStats {
  let hitPoints: Int
  let damage: Int
}

struct MinManaParameters: Hashable {
  var playerHP: Int = 50  // assume > 0
  var playerMana: Int = 500
  var bossHP: Int  // assume > 0

  var shieldTimer: Int = 0
  var poisonTimer: Int = 0
  var rechargeTimer: Int = 0

  var playerTurn: Bool = true

  var hardMode: Bool
}

@main
struct Day22 {
  static func main() throws {
    let bossHP = Int(readLine()!.firstMatch(of: /\d+/)!.0)!
    let bossDamage = Int(readLine()!.firstMatch(of: /\d+/)!.0)!
    var minManaMemo = [MinManaParameters: Int?]()

    func minManaToWin(_ parameters: MinManaParameters) -> Int? {
      if minManaMemo[parameters] == (Int??).none {
        let toReturn: Int?
        var newParameters = parameters
        var armor = 0
        if newParameters.shieldTimer > 0 {
          armor += 7
          newParameters.shieldTimer -= 1
        }
        if newParameters.rechargeTimer > 0 {
          newParameters.playerMana += 101
          newParameters.rechargeTimer -= 1
        }
        if newParameters.poisonTimer > 0 {
          newParameters.bossHP -= 3
          newParameters.poisonTimer -= 1
        }

        if newParameters.bossHP <= 0 {
          toReturn = 0
        } else {
          if newParameters.playerTurn {
            if newParameters.hardMode {
              newParameters.playerHP -= 1
            }

            if newParameters.playerHP <= 0 {
              toReturn = Int?.none
            } else {
              newParameters.playerTurn.toggle()

              var best = Int?.none

              // Magic Missle
              if newParameters.playerMana >= 53 {
                var missleParameters = newParameters
                missleParameters.playerMana -= 53
                missleParameters.bossHP -= 4
                if let attempt = minManaToWin(missleParameters) {
                  best = min(attempt + 53, best ?? Int.max)
                }
              }

              // Drain
              if newParameters.playerMana >= 73 {
                var drainParameters = newParameters
                drainParameters.playerMana -= 73
                drainParameters.bossHP -= 2
                drainParameters.playerHP += 2
                if let attempt = minManaToWin(drainParameters) {
                  best = min(attempt + 73, best ?? Int.max)
                }
              }

              // Shield
              if newParameters.shieldTimer == 0
                && newParameters.playerMana >= 113
              {
                var shieldParameters = newParameters
                shieldParameters.playerMana -= 113
                shieldParameters.shieldTimer = 6
                if let attempt = minManaToWin(shieldParameters) {
                  best = min(attempt + 113, best ?? Int.max)
                }
              }

              // Poison
              if newParameters.poisonTimer == 0
                && newParameters.playerMana >= 173
              {
                var poisonParameters = newParameters
                poisonParameters.playerMana -= 173
                poisonParameters.poisonTimer = 6
                if let attempt = minManaToWin(poisonParameters) {
                  best = min(attempt + 173, best ?? Int.max)
                }
              }

              // Recharge
              if newParameters.rechargeTimer == 0
                && newParameters.playerMana >= 229
              {
                var rechargeParameters = newParameters
                rechargeParameters.playerMana -= 229
                rechargeParameters.rechargeTimer += 5
                if let attempt = minManaToWin(rechargeParameters) {
                  best = min(attempt + 229, best ?? Int.max)
                }
              }

              toReturn = best
            }
          } else {
            newParameters.playerTurn.toggle()
            newParameters.playerHP -= max(bossDamage - armor, 1)
            if newParameters.playerHP <= 0 {
              toReturn = Int?.none
            } else {
              toReturn = minManaToWin(newParameters)
            }
          }
        }
        minManaMemo[parameters] = toReturn
      }

      return minManaMemo[parameters]!
    }

    let parameters = MinManaParameters(bossHP: bossHP, hardMode: false)
    let minMana = minManaToWin(parameters)
    print("Part One: \(minMana!)")

    let hardParameters = MinManaParameters(bossHP: bossHP, hardMode: true)
    let hardMana = minManaToWin(hardParameters)
    print("Part Two: \(hardMana!)")
  }
}
