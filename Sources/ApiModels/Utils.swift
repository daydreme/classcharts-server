@propertyWrapper
public struct YesNoToBool: Codable, Sendable, Equatable, Hashable {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let yesNoString = try container.decode(String.self)
        self.wrappedValue = yesNoString == "yes"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue ? "yes" : "no")
    }
}

public enum AnyCodableValue: Sendable, Codable, Equatable, Hashable {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case dictionary([String: AnyCodableValue])
    case array([AnyCodableValue])
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let values = try? container.decode([AnyCodableValue].self) {
            self = .array(values)
        } else if let values = try? container.decode([String: AnyCodableValue].self) {
            self = .dictionary(values)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "The container contains an unsupported type.")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .bool(let boolValue):
            try container.encode(boolValue)
        case .dictionary(let dictValue):
            try container.encode(dictValue)
        case .array(let arrayValue):
            try container.encode(arrayValue)
        case .null:
            try container.encodeNil()
        }
    }
}
