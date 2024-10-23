import ApiModels
import CryptoKit
import Fluent
import Foundation

public final class Student: Model, @unchecked Sendable {
    public static let schema = "students"

    public init() {}
    public init(
        id: Int?,
        schoolID: School.IDValue,
        name: String,
        firstName: String,
        lastName: String,
        avatarUrl: String? = nil,
        isDisabled: Bool = false,
        birthday: Date?,
        accessCodeHash: String
    ) {
        self.id = id
        self.$school.id = schoolID
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
        self.isDisabled = isDisabled
        self.birthday = birthday
        self.accessCodeHash = accessCodeHash
    }

    @Parent(key: "school_id")
    public var school: School

    @ID(custom: "id")
    public var id: Int?
    @Field(key: "access_code_hash")
    public var accessCodeHash: String
    @Field(key: "name")
    public var name: String
    @Field(key: "first_name")
    public var firstName: String
    @Field(key: "last_name")
    public var lastName: String
    @Field(key: "avatar_url")
    public var avatarUrl: String?
    @Field(key: "is_disabled")
    public var isDisabled: Bool
    @Timestamp(key: "birthday", on: .none)
    public var birthday: Date?

    public func toApiModel(with database: any Database) async throws -> ApiStudent {
        guard let id else {
            throw DatabaseModelError.nilIDField
        }

        let school = try await $school.get(on: database).get()

        return .init(
            id: id, name: name, firstName: firstName, lastName: lastName,
            avatarUrl: avatarUrl ?? "",
            displayBehaviour: school.modules.behaviourEnabled, displayParentBehaviour: false,
            displayHomework: false,
            displayRewards: false, displayDetentions: false, displayReportCards: false,
            displayClasses: false, displayAnnouncements: false, displayAttendance: false,
            displayAttendanceType: "", displayAttendancePercentage: false,
            displayActivity: false,
            displayMentalHealth: false, displayTimetable: false, isDisabled: false,
            displayTwoWayCommunications: false, displayAbsences: false,
            canUploadAttachments: false,
            displayEventBadges: false, displayAvatars: false, displayConcernSubmission: false,
            displayCustomFields: false, pupilConcernsHelpText: "",
            allowPupilsAddTimetableNotes: false, announcementsCount: 0, messagesCount: 0,
            pusherChannelName: "", hasBirthday: birthday != nil, hasNewSurvey: false,
            surveyId: nil,
            detentionAliasPluralUc: "detentions"
        )
    }
}

struct CreateStudent: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("students")
            .field("id", .int, .identifier(auto: true))
            .field("school_id", .int, .required, .references("schools", "id"))
            .field("name", .string, .required)
            .field("access_code_hash", .string, .required)
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("avatar_url", .string)
            .field("is_disabled", .bool, .required)
            .field("birthday", .date, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("students").delete()
    }
}

struct SeedStudent: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let digest = SHA256.hash(data: "TEST".data(using: .utf8)!)
        return Student(
            id: 1000, schoolID: 1000, name: "Test Student", firstName: "Test", lastName: "Student",
            birthday: Date.from(year: 2000, month: 1, day: 1),
            accessCodeHash: digest.hexEncodedString()
        ).save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        Student.query(on: database).filter(\.$id == 1000).delete()
    }
}
