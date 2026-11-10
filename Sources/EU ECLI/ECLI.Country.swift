public import ISO_3166

extension ECLI {

    public enum Country: Sendable, Hashable {

        case country(ISO_3166.Alpha2)

        case exceptional(ISO_3166.Exceptional)

        case organisation(ECLI.Organisation)
    }
}

extension ECLI.Country {

    public init(_ code: some StringProtocol) throws(ECLI.Country.Error) {
        let text = String(code)
        guard text.utf8.allSatisfy(ECLI.isLatinLetter) else {
            throw .invalidCharacter(text)
        }
        guard text.utf8.count == 2 else {
            throw .invalidLength(text.utf8.count)
        }
        let upper = text.uppercased()
        if upper == Self.greece {
            self = .country(.gr)
            return
        }
        if upper == "GR" {
            throw .notTheStyleGuideCode(upper, styleGuide: Self.greece)
        }
        do throws(ISO_3166.Territory.Error) {
            switch try ISO_3166.Territory(upper) {
            case .country(let alpha2):
                self = .country(alpha2)

            case .exceptional(let exceptional):
                self = .exceptional(exceptional)

            case .subdivision:
                self = .organisation(ECLI.Organisation(unchecked: upper))
            }
        } catch {
            self = .organisation(ECLI.Organisation(unchecked: upper))
        }
    }

    public var code: String {
        switch self {
        case .country(let alpha2):
            alpha2 == .gr ? Self.greece : alpha2.value.uppercased()

        case .exceptional(let exceptional):
            exceptional.value.uppercased()

        case .organisation(let organisation):
            organisation.code
        }
    }

    public static let europeanUnion = ECLI.Country.exceptional(.eu)

    private static let greece = "EL"
}

extension ECLI.Country: CustomStringConvertible {

    public var description: String { code }
}
