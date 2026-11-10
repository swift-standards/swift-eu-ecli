extension ECLI {

    public struct Number: Sendable, Hashable {

        public let code: String

        public init(_ code: some StringProtocol) throws(ECLI.Number.Error) {
            let text = String(code)
            guard text.utf8.allSatisfy({ ECLI.isLatinAlphanumeric($0) || $0 == UInt8(ascii: ".") }) else {
                throw .invalidCharacter(text)
            }
            guard (1...25).contains(text.utf8.count) else {
                throw .invalidLength(text.utf8.count)
            }
            self.code = text.uppercased()
        }
    }
}

extension ECLI.Number: CustomStringConvertible {

    public var description: String { code }
}
