extension ECLI.Country {

    public enum Error: Swift::Error, Sendable, Equatable {

        case invalidLength(Int)

        case invalidCharacter(String)

        case notTheStyleGuideCode(String, styleGuide: String)
    }
}
