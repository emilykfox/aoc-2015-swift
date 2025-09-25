import MD5
import Testing

let lorumIpsem =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

@Test("Empty string") func emptyString() {
  #expect(MD5.digest("".utf8) == "d41d8cd98f00b204e9800998ecf8427e")
}

@Test(
  "Correct hashes",
  arguments: [
    (
      "The quick brown fox jumps over the lazy dog", "9e107d9d372bb6826bd81d3542a419d6"
    ),
    (
      "The quick brown fox jumps over the lazy dog.", "e4d909c290d0fb1ca068ffaddf22cbd0"
    ),
    (lorumIpsem, "db89bb5ceab87f9c0fcc2ab36c189c2c"),
    (
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit,", "572be236390dc0bca92bb5c5999d2290"
    ),
  ]) func correctHashes(_ pair: (String, String))
{
  let (string, expectedHash) = pair
  #expect(MD5.digest(string.utf8) == expectedHash)
}
