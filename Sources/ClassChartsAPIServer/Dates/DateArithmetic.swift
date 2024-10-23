import Foundation

extension Date {
    public func adding(days: Double) -> Date {
        let seconds = Double(days) * 60 * 60 * 24
        return addingTimeInterval(seconds)
    }

    public func adding(hours: Double) -> Date {
        let seconds = Double(hours) * 60 * 60
        return addingTimeInterval(seconds)
    }

    public func adding(minutes: Double) -> Date {
        let seconds = Double(minutes) * 60
        return addingTimeInterval(seconds)
    }

    public func adding(seconds: Double) -> Date {
        addingTimeInterval(Double(seconds))
    }

    public func removing(days: Double) -> Date {
        adding(days: -days)
    }

    public func removing(hours: Double) -> Date {
        adding(hours: -hours)
    }

    public func removing(minutes: Double) -> Date {
        adding(minutes: -minutes)
    }

    public func removing(seconds: Double) -> Date {
        adding(seconds: -seconds)
    }
}
