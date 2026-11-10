extension ECLI.Number {

    public enum Error: Swift::Error, Sendable, Equatable {

        case invalidLength(Int)

        case invalidCharacter(String)
    }
}
