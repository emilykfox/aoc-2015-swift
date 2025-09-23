// The Swift Programming Language
// https://docs.swift.org/swift-book

import RegexBuilder

@available(macOS 15, *)
@main
struct Day02 {
    static func main() {
        let lengthRef = Reference(Int.self)
        let widthRef = Reference(Int.self)
        let heightRef = Reference(Int.self)
        
        let regex = Regex {
            Anchor.startOfLine
            TryCapture(as: lengthRef) {
                OneOrMore(.digit)
            } transform: { Int($0) }
            "x"
            TryCapture(as: widthRef) {
                OneOrMore(.digit)
            } transform: { Int($0) }
            "x"
            TryCapture(as: heightRef) {
                OneOrMore(.digit)
            } transform: { Int($0) }
            Anchor.endOfLine
        }

        var measurements: Array<(length: Int, width: Int, height: Int)> = []
        while let line = readLine(strippingNewline: true) {
            if let lineMatch = line.wholeMatch(of: regex) {
                measurements.append((length: lineMatch[lengthRef], width: lineMatch[widthRef], height: lineMatch[heightRef]))
            }
        }

        let paperNeeded = measurements.map { (length: Int, width: Int, height: Int) -> Int in
            let lengthWidth = length * width
            let widthHeight = width * height
            let lengthHeight = length * height

            return 2 * lengthWidth + 2 * widthHeight + 2 * lengthHeight + min(lengthWidth, widthHeight, lengthHeight)
        }.reduce(0, +)

        print("Part One: \(paperNeeded)")

        let ribbonNeeded = measurements.map { (length: Int, width: Int, height: Int) -> Int in
            return 2 * (length + width + height - max(length, width, height)) + length * width * height
        }.reduce(0, +)

        print("Part Two: \(ribbonNeeded)")
    }
}
