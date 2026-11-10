extension ECLI.Date {

    public enum Error: Swift::Error, Sendable, Equatable {

        case invalid(String)

        case monthWithoutDay(String)
    }
}
