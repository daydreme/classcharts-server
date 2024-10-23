public struct ValidateStudentAccessCodeData: Codable {
    let hasDob: Bool

    public init(hasDob: Bool) {
        self.hasDob = hasDob
    }
}

public typealias StudentLoginData = ApiStudent

public struct StudentLoginMeta: Codable {
    public init(sessionId: String) {
        self.sessionId = sessionId
    }
    public var sessionId: String
}

public typealias StudentLoginResponse = ApiResponse<StudentLoginData, StudentLoginMeta>
