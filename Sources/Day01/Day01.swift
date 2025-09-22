// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct Day01 {
    static func main() {
        let input = readLine(strippingNewline: true)!

        var currentFloor = 0
        var firstBasement: Int? = nil
        var currentPosition = 0
        input.forEach {
            currentPosition += 1
            switch $0 {
                case "(": currentFloor += 1
                default: currentFloor -= 1
            }
            if firstBasement == nil && currentFloor < 0 {
                firstBasement = currentPosition
            }
        }


        print("Part One: \(currentFloor)")

        print("Part Two: \(firstBasement!)")
    }
}
