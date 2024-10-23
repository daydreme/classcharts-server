import Foundation
import VaporRouting

enum ConversionError: Error {
    case invalidDate
}

extension Conversions {
    public struct SubstringToBoolean: Conversion {
        @inlinable
        public init() {}

        @inlinable
        public func apply(_ input: Substring) -> Bool {
            String(input) == "true" ? true : false
        }

        @inlinable
        public func unapply(_ output: Bool) -> Substring {
            Substring(output == true ? "true" : "false")
        }
    }
}

extension Conversion where Self == Conversions.SubstringToBoolean {
    public static var boolean: Self { .init() }
}

extension Conversions {
    public struct SubstringToDate: Conversion {
        let dateFormatter: DateFormatter

        public init(dateFormatter: DateFormatter) {
            self.dateFormatter = dateFormatter
        }

        public func apply(_ input: Substring) throws -> Date {
            guard let result = dateFormatter.date(from: String(input)) else {
                throw ConversionError.invalidDate
            }

            return result
        }

        public func unapply(_ output: Date) throws -> Substring {
            Substring(dateFormatter.string(from: output))
        }
    }
}

extension Conversion where Self == Conversions.SubstringToDate {
    public static func date(formatter: DateFormatter) -> Self { .init(dateFormatter: formatter) }
}

public enum OptionalField<Value: Equatable>: Equatable {
    case some(Value)
    case valueless

    func toNil() -> Value? {
        switch self {
        case .some(let value):
            return value
        case .valueless:
            return nil
        }
    }
}

extension Conversion where Output: Equatable {
    public func optional()
        -> Conversions.Map<
            Self,
            AnyConversion<Output, OptionalField<Output>>
        >
    {
        self.map(
            .convert {
                OptionalField.some($0)
            } unapply: {
                $0.toNil()
            })
    }
}
