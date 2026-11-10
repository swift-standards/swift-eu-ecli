extension ECLI {

    public struct Court: Sendable, Hashable {

        public let code: String

        public init(_ code: some StringProtocol) throws(ECLI.Court.Error) {
            let text = String(code)
            guard text.utf8.allSatisfy(ECLI.isLatinAlphanumeric) else {
                throw .invalidCharacter(text)
            }
            guard (1...7).contains(text.utf8.count) else {
                throw .invalidLength(text.utf8.count)
            }
            guard let first = text.utf8.first, ECLI.isLatinLetter(first) else {
                throw .startsWithDigit(text)
            }
            self.code = text.uppercased()
        }
    }
}

extension ECLI.Court {

    public static let unlisted = try! ECLI.Court("XX")

    public var isUnlisted: Bool { self == .unlisted }
}

extension ECLI.Court: CustomStringConvertible {

    public var description: String { code }
}
