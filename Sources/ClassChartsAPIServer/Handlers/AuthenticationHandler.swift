import ApiModels
import CryptoKit
import Fluent
import Foundation
import JWT

public enum AuthenticationError: Error {
    case invalidAccessCode
}

class AuthenticationHandler: RouteHandling<ServerRoute> {
    func register(on router: Aggregator) {
        router.register(\.authenticateStudent) { request, params in
            guard let accessCodeData = params.accessCode.uppercased().data(using: .utf8) else {
                throw AuthenticationError.invalidAccessCode
            }
            let digest = SHA256.hash(data: accessCodeData)
            let hash = digest.hexEncodedString()

            let dbStudent = try await Student.query(on: request.db)
                .filter(\.$birthday == params.dateOfBirth.toNil())
                .filter(\.$accessCodeHash == hash)
                .first()

            guard let dbStudent else {
                return ApiResponse.error(message: "Incorrect")
            }

            let student = try await dbStudent.toApiModel(with: request.db)
            let payload = StudentAuthPayload(
                subject: SubjectClaim(value: String(student.id)),
                expiration: .init(value: Date.now.adding(days: 365))
            )
            let sessionId = try await request.jwt.sign(payload)

            return StudentLoginResponse.success(data: student, meta: .init(sessionId: sessionId))
        }

        router.register(\.validateStudentAccessCode) { request, accessCode in
            guard let accessCodeData = accessCode.uppercased().data(using: .utf8) else {
                throw AuthenticationError.invalidAccessCode
            }
            let digest = SHA256.hash(data: accessCodeData)
            let hash = digest.hexEncodedString()

            let dbStudent = try await Student.query(on: request.db)
                .filter(\.$accessCodeHash == hash)
                .first()

            return ApiResponse.success(
                data: ValidateStudentAccessCodeData(hasDob: dbStudent?.birthday != nil))
        }
    }
}
