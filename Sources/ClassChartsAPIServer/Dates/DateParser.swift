import Foundation

extension Date {
    public static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: string) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            return date
        }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withFullDate, .withTime, .withTimeZone, .withDashSeparatorInDate,
            .withColonSeparatorInTime, .withColonSeparatorInTimeZone,
        ]
        if let date = isoFormatter.date(from: string) {
            return date
        }

        return nil
    }
}
