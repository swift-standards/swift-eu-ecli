import ISO_8601

extension ECLI {

    public init(_ text: some StringProtocol) throws(ECLI.Error) {
        let string = String(text)
        let slashed = !string.contains(":") && string.contains("/")
        let parts = string.split(separator: slashed ? "/" : ":", omittingEmptySubsequences: false)
        guard parts.count == 5 else {
            throw .componentCount(parts.count)
        }
        if slashed, string.utf8.contains(where: { (UInt8(ascii: "A")...UInt8(ascii: "Z")).contains($0) }) {
            throw .uppercaseInSlashSyntax(string)
        }
        guard parts[0].uppercased() == "ECLI" else {
            throw .scheme(String(parts[0]))
        }
        let country: ECLI.Country
        do throws(ECLI.Country.Error) {
            country = try ECLI.Country(parts[1])
        } catch {
            throw .country(error)
        }
        let court: ECLI.Court
        do throws(ECLI.Court.Error) {
            court = try ECLI.Court(parts[2])
        } catch {
            throw .court(error)
        }
        let date = try Self.date(parts[3])
        let number: ECLI.Number
        do throws(ECLI.Number.Error) {
            number = try ECLI.Number(parts[4])
        } catch {
            throw .number(error)
        }
        try self.init(country: country, court: court, date: date, number: number)
    }

    private static func date(_ text: Substring) throws(ECLI.Error) -> ISO_8601.CalendarDate.Reduced {
        if text.utf8.count == 4, text.utf8.allSatisfy(ECLI.isDigit), let year = Int(text),
            let reduced = try? ISO_8601.CalendarDate.Reduced(year: year)
        {
            return reduced
        }
        if let day = ISO_8601.CalendarDate(basic: text) {
            return ISO_8601.CalendarDate.Reduced(day)
        }
        throw .date(.invalid(String(text)))
    }
}

extension ECLI {

    public var colonSyntax: String {
        ["ECLI", country.code, court.code, dateText, number.code].joined(separator: ":")
    }

    public var slashSyntax: String {
        ["ecli", country.code, court.code, dateText, number.code].joined(separator: "/").lowercased()
    }

    private var dateText: String {
        date.date?.basic ?? date.extended
    }
}

extension ECLI: CustomStringConvertible {

    public var description: String { colonSyntax }
}
