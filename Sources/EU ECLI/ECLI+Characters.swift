extension ECLI {

    internal static func isLatinLetter(_ byte: UInt8) -> Bool {
        (UInt8(ascii: "A")...UInt8(ascii: "Z")).contains(byte) || (UInt8(ascii: "a")...UInt8(ascii: "z")).contains(byte)
    }

    internal static func isDigit(_ byte: UInt8) -> Bool {
        (UInt8(ascii: "0")...UInt8(ascii: "9")).contains(byte)
    }

    internal static func isLatinAlphanumeric(_ byte: UInt8) -> Bool {
        isLatinLetter(byte) || isDigit(byte)
    }
}
