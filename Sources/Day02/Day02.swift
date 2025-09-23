// The Swift Programming Language
// https://docs.swift.org/swift-book

@available(macOS 15, *)
@main
struct Day02 {
    static func main() {
        var measurements: Array<(length: Int, width: Int, height: Int)> = []
        while let line = readLine(strippingNewline: true) {
            let parts = line.split(separator: "x")
            if parts.count != 3 {
                continue
            }
            guard let length = Int(parts[0]), let width = Int(parts[1]), let height = Int(parts[2]) else {
                continue
            }
            measurements.append((length: length, width: width, height: height))
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
