import MD5
import Testing

let lorumIpsem =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

@Test("Empty string") func emptyString() {
  #expect(MD5.md5("".utf8) == UInt128(bigEndian: 0xd41d_8cd9_8f00_b204_e980_0998_ecf8_427e))
}

@Test(
  "Correct hashes",
  arguments: [
    (
      "The quick brown fox jumps over the lazy dog",
      UInt128(bigEndian: 0x9e10_7d9d_372b_b682_6bd8_1d35_42a4_19d6)
    ),
    (
      "The quick brown fox jumps over the lazy dog.",
      UInt128(bigEndian: 0xe4d9_09c2_90d0_fb1c_a068_ffad_df22_cbd0)
    ),
    ("abcdef609043", UInt128(bigEndian: 0x0000_01db_bfa3_a5c8_3a2d_5064_29c7_b00e)),
    ("pqrstuv1048970", UInt128(bigEndian: 0x0000_0613_6ef2_ff3b_291c_8572_5f17_325c)),
    (lorumIpsem, UInt128(bigEndian: 0xdb89_bb5c_eab8_7f9c_0fcc_2ab3_6c18_9c2c)),
    (
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
      UInt128(bigEndian: 0x572b_e236_390d_c0bc_a92b_b5c5_999d_2290)
    ),
  ]) func correctHashes(_ pair: (String, UInt128))
{
  let (string, expectedHash) = pair
  #expect(MD5.md5(string.utf8) == expectedHash)
}
