# swift-eu-ecli

Use this package when you take a European Case Law Identifier as text, such as `ECLI:NL:HR:2026:123`, and need its country, court, year and number, or need to print one you built from those parts. Start from `ECLI`. It follows Part I of Annex I to the Council conclusions on ECLI of 2019 (OJ C 360, 24.10.2019, p. 1), which keep the format of the 2011 conclusions (OJ C 127, 29.4.2011, p. 1) and add the slash syntax and the full date. A value that parses is well-formed. It is not necessarily issued.

## Laws

- An ECLI has exactly five components: `ECLI`, the country code, the court code, the year or date, and the number. More or fewer are refused, and the first must read `ECLI`.
- Components are separated by colons, or all by slashes. In the slash syntax every letter must be lowercase, so `ecli/NL/hr/2026/123` is refused.
- Capitalisation makes no difference in meaning: `ecli:nl:hr:2026:12a` and `ECLI:NL:HR:2026:12A` are equal. `description` prints the colon syntax in capitals, and `slashSyntax` prints the slash syntax in lowercase.
- The country is two Latin letters. The Interinstitutional style guide code `EL` reads as Greece (`.country(.gr)`) and prints as `EL`. `GR` is refused, because the conclusions give Member States the style guide code. Other ISO 3166 alpha-2 codes read as `.country`, and ISO 3166's exceptionally reserved codes, among them `EU` for the European Union and `UK`, read as `.exceptional`. Any other two letters read as `.organisation`, a code the Commission assigns to an international organisation, such as `CE` for the Council of Europe or `EP` for the European Patent Office.
- The court code has one to seven Latin letters and digits and starts with a letter. `XX` is the code reserved for courts not on the national list, and `ECLI.Court.isUnlisted` says so.
- The fourth component is four digits for the year, or eight digits `yyyymmdd` for a date the calendar has. A date reads as an `ISO_8601.CalendarDate.Reduced` at day precision, a year as one at year precision. A month without a day is refused when building an ECLI from parts. An ECLI with a date and one with only its year are different identifiers.
- The number has one to 25 Latin letters, digits and dots, and no other punctuation.
- Only the identifier at the work level is covered. ECLI-XL, the expression, manifestation and fragment extensions of Part II, and the ECLI metadata of Part III are not, and an ECLI followed by an extension is refused.
- Only ASCII counts: letters and digits from other scripts are refused, and text is never trimmed.
