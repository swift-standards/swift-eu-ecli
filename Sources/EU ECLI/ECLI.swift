public import ISO_8601

public struct ECLI: Sendable, Hashable {

    public let country: ECLI.Country

    public let court: ECLI.Court

    public let date: ISO_8601.CalendarDate.Reduced

    public let number: ECLI.Number

    public init(
        country: ECLI.Country,
        court: ECLI.Court,
        date: ISO_8601.CalendarDate.Reduced,
        number: ECLI.Number
    ) throws(ECLI.Error) {
        guard date.precision != .month else {
            throw .date(.monthWithoutDay(date.extended))
        }
        self.country = country
        self.court = court
        self.date = date
        self.number = number
    }
}

extension ECLI {

    public var year: Int { date.year }
}
