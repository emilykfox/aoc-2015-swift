import MD5

@main
struct Day04 {
  static func main() {
    let input = readLine()!
    var partA: Int?
    var partB: Int?
    for i in 1... {
      let toHash = input + String(i)
      let digest = MD5.digest(toHash.utf8)
      if partA == nil && digest.starts(with: "00000") {
        partA = i
      }
      if digest.starts(with: "000000") {
        partB = i
        break
      }
    }

    print("Part One: \(partA!)")
    print("Part Two: \(partB!)")
  }
}
