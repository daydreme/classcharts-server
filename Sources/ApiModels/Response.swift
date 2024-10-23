public enum ApiResponse<Data: Codable, Meta: Codable> {
    case success(data: Data, meta: Meta)
    case failure(message: String, expired: Bool)

    private enum CodingKeys: String, CodingKey {
        case data
        case meta

        case success
        case error
        case expired
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let data = try container.decodeIfPresent(Data.self, forKey: .data),
            let meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        {
            self = .success(data: data, meta: meta)
            return
        }

        if let code = try container.decodeIfPresent(Int8.self, forKey: .success),
            code == 0,
            let message = try container.decodeIfPresent(String.self, forKey: .error)
        {
            let expired = try? container.decodeIfPresent(Bool.self, forKey: .expired)
            self = .failure(message: message, expired: expired ?? false)
            return
        }

        throw DecodingError.dataCorruptedError(
            forKey: .error, in: container,
            debugDescription: "Could not find `error` or `data` in response")
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .failure(message, expired):
            try container.encode(0, forKey: .success)
            try container.encode(message, forKey: .error)
            try container.encode(AnyCodableValue.array([]), forKey: .meta)
            try container.encode(expired ? 1 : 0, forKey: .expired)

        case let .success(data, meta):
            try container.encode(1, forKey: .success)
            try container.encode(data, forKey: .data)
            try container.encode(meta, forKey: .meta)
        }
    }
}

extension ApiResponse where Meta == AnyCodableValue {
    public static func success(data: Data) -> Self {
        .success(data: data, meta: .array([]))
    }
}

extension ApiResponse where Meta == AnyCodableValue, Data == AnyCodableValue {
    public static func error(message: String, expired: Bool = false) -> Self {
        .failure(message: message, expired: expired)
    }
}
