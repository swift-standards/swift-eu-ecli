extension ECLI.Court {

    public enum Error: Swift::Error, Sendable, Equatable {

        case invalidLength(Int)

        case invalidCharacter(String)

        case startsWithDigit(String)
    }
}
