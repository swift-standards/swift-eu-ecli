import EU_ECLI
import ISO_3166
import ISO_8601
import Testing

enum `ECLI Tests` {}

extension `ECLI Tests` {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension `ECLI Tests`.Test.Unit {

    @Test
    func `a Dutch Supreme Court ruling reads its five components`() throws {
        let ruling = try ECLI("ECLI:NL:HR:2026:123")
        #expect(ruling.country == .country(.nl))
        #expect(ruling.court.code == "HR")
        #expect(ruling.year == 2026)
        #expect(ruling.date.precision == .year)
        #expect(ruling.number.code == "123")
    }

    @Test(arguments: [
        "ECLI:NL:HR:2026:123",
        "ECLI:EU:C:2019:1145",
        "ECLI:DE:BVERFG:2020:RS20200505.2BVR085915",
        "ECLI:EL:COS:2015:0402A1",
        "ECLI:CE:ECHR:2016:0426JUD001051110",
        "ECLI:EP:BA:2002:D000300.20020503",
        "ECLI:BE:CASS:2014:ARR.20140204.1",
        "ECLI:NL:XX:2026:1",
    ])
    func `the colon syntax prints as it was read`(text: String) throws {
        #expect(try ECLI(text).description == text)
    }

    @Test
    func `the slash syntax is the same identifier in lowercase`() throws {
        let ruling = try ECLI("ecli/nl/hr/2026/123")
        #expect(ruling == (try ECLI("ECLI:NL:HR:2026:123")))
        #expect(ruling.slashSyntax == "ecli/nl/hr/2026/123")
        #expect(try ECLI("ECLI:EU:C:2019:1145").slashSyntax == "ecli/eu/c/2019/1145")
    }

    @Test
    func `capitalisation makes no difference in meaning and prints in capitals`() throws {
        let ruling = try ECLI("ecli:nl:hr:2026:12a")
        #expect(ruling == (try ECLI("ECLI:NL:HR:2026:12A")))
        #expect(ruling.description == "ECLI:NL:HR:2026:12A")
    }

    @Test
    func `the fourth component may be the exact date of the decision`() throws {
        let ruling = try ECLI("ECLI:NL:HR:20260310:123")
        #expect(ruling.date.precision == .day)
        #expect(ruling.date.date == (try ISO_8601.CalendarDate(year: 2026, month: 3, day: 10)))
        #expect(ruling.year == 2026)
        #expect(ruling.description == "ECLI:NL:HR:20260310:123")
        #expect(ruling != (try ECLI("ECLI:NL:HR:2026:123")))
    }

    @Test
    func `the country is the style guide code, ISO 3166 otherwise, EU for the Union and an organisation code`() throws {
        #expect(try ECLI("ECLI:EL:COS:2015:1").country == .country(.gr))
        #expect(try ECLI("ECLI:EU:C:2019:1145").country == .europeanUnion)
        #expect(try ECLI("ECLI:UK:SC:2019:1").country == .exceptional(.uk))
        #expect(try ECLI("ECLI:CH:BGER:2019:1").country == .country(.ch))
        #expect(try ECLI("ECLI:CE:ECHR:2016:1").country.code == "CE")
        #expect(ECLI.Country.country(.gr).code == "EL")
    }

    @Test
    func `XX is the court code reserved for unlisted courts`() throws {
        #expect(try ECLI("ECLI:NL:XX:2026:1").court.isUnlisted)
        #expect(try ECLI("ECLI:NL:HR:2026:1").court.isUnlisted == false)
    }

    @Test
    func `an ECLI is built from its components`() throws {
        let ruling = try ECLI(
            country: .country(.nl),
            court: ECLI.Court("RBAMS"),
            date: ISO_8601.CalendarDate.Reduced(year: 2026),
            number: ECLI.Number("1234")
        )
        #expect(ruling.description == "ECLI:NL:RBAMS:2026:1234")
    }
}

extension `ECLI Tests`.Test.`Edge Case` {

    @Test
    func `an ECLI has exactly five components`() {
        #expect(throws: ECLI.Error.componentCount(4)) { try ECLI("ECLI:NL:HR:2026") }
        #expect(throws: ECLI.Error.componentCount(6)) { try ECLI("ECLI:NL:HR:2026:123:4") }
        #expect(throws: ECLI.Error.componentCount(1)) { try ECLI("") }
    }

    @Test
    func `the first component is ECLI`() {
        #expect(throws: ECLI.Error.scheme("ELI")) { try ECLI("ELI:NL:HR:2026:123") }
    }

    @Test
    func `the slash syntax is written in lowercase`() {
        #expect(throws: ECLI.Error.uppercaseInSlashSyntax("ecli/NL/hr/2026/123")) {
            try ECLI("ecli/NL/hr/2026/123")
        }
    }

    @Test
    func `the country code is two Latin letters, and Greece is EL`() {
        #expect(throws: ECLI.Error.country(.invalidLength(3))) { try ECLI("ECLI:NLD:HR:2026:1") }
        #expect(throws: ECLI.Error.country(.invalidCharacter("N1"))) { try ECLI("ECLI:N1:HR:2026:1") }
        #expect(throws: ECLI.Error.country(.notTheStyleGuideCode("GR", styleGuide: "EL"))) {
            try ECLI("ECLI:GR:COS:2015:1")
        }
    }

    @Test
    func `the court code has one to seven Latin alphanumerics and starts with a letter`() {
        #expect(throws: ECLI.Error.court(.invalidLength(0))) { try ECLI("ECLI:NL::2026:1") }
        #expect(throws: ECLI.Error.court(.invalidLength(8))) { try ECLI("ECLI:NL:ABCDEFGH:2026:1") }
        #expect(throws: ECLI.Error.court(.startsWithDigit("1HR"))) { try ECLI("ECLI:NL:1HR:2026:1") }
        #expect(throws: ECLI.Error.court(.invalidCharacter("H-R"))) { try ECLI("ECLI:NL:H-R:2026:1") }
        #expect(throws: ECLI.Error.court(.invalidCharacter("HÖ"))) { try ECLI("ECLI:NL:HÖ:2026:1") }
    }

    @Test
    func `the date is four digits or a real yyyymmdd date`() {
        #expect(throws: ECLI.Error.date(.invalid("26"))) { try ECLI("ECLI:NL:HR:26:1") }
        #expect(throws: ECLI.Error.date(.invalid("20260230"))) { try ECLI("ECLI:NL:HR:20260230:1") }
        #expect(throws: ECLI.Error.date(.invalid("2026-03-10"))) { try ECLI("ECLI:NL:HR:2026-03-10:1") }
        #expect(throws: ECLI.Error.date(.invalid("+026"))) { try ECLI("ECLI:NL:HR:+026:1") }
    }

    @Test
    func `a month without a day is not an ECLI date`() throws {
        #expect(throws: ECLI.Error.date(.monthWithoutDay("2026-03"))) {
            try ECLI(
                country: .country(.nl),
                court: ECLI.Court("HR"),
                date: ISO_8601.CalendarDate.Reduced(year: 2026, month: 3),
                number: ECLI.Number("1")
            )
        }
    }

    @Test
    func `the number has at most 25 Latin alphanumerics or dots and no other punctuation`() {
        #expect(throws: ECLI.Error.number(.invalidLength(0))) { try ECLI("ECLI:NL:HR:2026:") }
        #expect(throws: ECLI.Error.number(.invalidLength(26))) {
            try ECLI("ECLI:NL:HR:2026:12345678901234567890123456")
        }
        #expect(throws: ECLI.Error.number(.invalidCharacter("12-3"))) { try ECLI("ECLI:NL:HR:2026:12-3") }
        #expect(throws: ECLI.Error.number(.invalidCharacter("123 "))) { try ECLI("ECLI:NL:HR:2026:123 ") }
    }

    @Test
    func `ECLI-XL extensions are not part of an ECLI`() {
        #expect(throws: ECLI.Error.componentCount(6)) { try ECLI("ECLI:NL:HR:2026:123(:NLD)") }
        #expect(throws: ECLI.Error.number(.invalidCharacter("123#para1"))) { try ECLI("ECLI:NL:HR:2026:123#para1") }
    }
}
