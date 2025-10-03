import Foundation

struct MemoKey: Hashable {
  let target: Int
  let suffixStart: Int
}

@main
struct Day17 {
  static func main() throws {
    var sizes = [Int]()
    while let line = readLine() {
      sizes.append(Int(line)!)
    }

    var memoTable = [MemoKey: Int]()

    for target in 0...150 {
      for suffixStart in (0...sizes.count).reversed() {
        let key = MemoKey(target: target, suffixStart: suffixStart)
        if target == 0 {
          memoTable[key] = 1
        } else if suffixStart == sizes.count {
          memoTable[key] = 0
        } else {
          if sizes[suffixStart] <= target {
            memoTable[key] =
              memoTable[MemoKey(target: target, suffixStart: suffixStart + 1)]! + memoTable[
                MemoKey(target: target - sizes[suffixStart], suffixStart: suffixStart + 1)]!
          } else {
            memoTable[key] = memoTable[MemoKey(target: target, suffixStart: suffixStart + 1)]!
          }
        }
      }
    }

    let numCombinations = memoTable[MemoKey(target: 150, suffixStart: 0)]!

    print("Part One: \(numCombinations)")

    var minMemoTable = [MemoKey: (min: Int?, count: Int)]()

    for target in 0...150 {
      for suffixStart in (0...sizes.count).reversed() {
        let key = MemoKey(target: target, suffixStart: suffixStart)
        if target == 0 {
          minMemoTable[key] = (min: 0, count: 1)
        } else if suffixStart == sizes.count {
          minMemoTable[key] = (min: nil, count: 0)
        } else {
          if sizes[suffixStart] <= target {
            let skipped = minMemoTable[MemoKey(target: target, suffixStart: suffixStart + 1)]!
            let took = minMemoTable[
              MemoKey(target: target - sizes[suffixStart], suffixStart: suffixStart + 1)]!
            if skipped.min != nil && took.min != nil {
              if skipped.min! == took.min! + 1 {
                minMemoTable[key] = (skipped.min!, skipped.count + took.count)
              } else if skipped.min! < took.min! + 1 {
                minMemoTable[key] = (skipped.min!, skipped.count)
              } else {
                minMemoTable[key] = (took.min! + 1, took.count)
              }
            } else if skipped.min != nil {
              minMemoTable[key] = (skipped.min!, skipped.count)
            } else if took.min != nil {
              minMemoTable[key] = (took.min! + 1, took.count)
            } else {
              minMemoTable[key] = (nil, 0)
            }
          } else {
            minMemoTable[key] = minMemoTable[MemoKey(target: target, suffixStart: suffixStart + 1)]!
          }
        }
      }
    }

    let numMinCombinations = minMemoTable[MemoKey(target: 150, suffixStart: 0)]!.count
    print("Part Two: \(numMinCombinations)")
  }
}
