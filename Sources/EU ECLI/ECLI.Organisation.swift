extension ECLI {

    public struct Organisation: Sendable, Hashable {

        public let code: String

        internal init(unchecked code: String) {
            self.code = code
        }
    }
}

extension ECLI.Organisation: CustomStringConvertible {

    public var description: String { code }
}
