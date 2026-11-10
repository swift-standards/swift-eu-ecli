extension ECLI {

    public enum Error: Swift::Error, Sendable, Equatable {

        case componentCount(Int)

        case scheme(String)

        case uppercaseInSlashSyntax(String)

        case country(ECLI.Country.Error)

        case court(ECLI.Court.Error)

        case date(ECLI.Date.Error)

        case number(ECLI.Number.Error)
    }
}
