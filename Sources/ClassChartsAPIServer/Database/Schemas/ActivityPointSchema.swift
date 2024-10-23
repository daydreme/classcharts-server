import Fluent
import Foundation

public final class ActivityPoint: Model, @unchecked Sendable {
    public static let schema = "activity_points"

    public init() {}
    public init(
        id: Int?,
        studentID: Student.IDValue,
        activityPointTypeID: ActivityPointType.IDValue
    ) {
        self.id = id
        self.$student.id = studentID
        self.$activityPointType.id = activityPointTypeID
    }

    @Parent(key: "student_id")
    public var student: Student

    @Parent(key: "activity_point_type")
    public var activityPointType: ActivityPointType

    @ID(custom: "id")
    public var id: Int?
    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?
}

public final class ActivityPointType: Model, @unchecked Sendable {
    public static let schema = "activity_point_types"

    public init() {}
    public init(
        id: Int?,
        schoolID: School.IDValue,
        name: String,
        value: Int
    ) {
        self.id = id
        self.$school.id = schoolID
        self.name = name
        self.value = value
    }

    @Parent(key: "school_id")
    public var school: School

    @Children(for: \.$activityPointType)
    public var activityPoints: [ActivityPoint]

    @ID(custom: "id")
    public var id: Int?

    @Field(key: "name")
    public var name: String

    @Field(key: "value")
    public var value: Int
}

struct CreateActivityPoint: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("activity_points")
            .field("id", .int, .identifier(auto: true))
            .field("created_at", .datetime, .required)
            .field("student_id", .int, .required, .references("students", "id"))
            .field(
                "activity_point_type", .int, .required, .references("activity_point_types", "id")
            )
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("activity_points").delete()
    }
}

struct CreateActivityPointType: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("activity_point_types")
            .field("id", .int, .identifier(auto: true))
            .field("school_id", .int, .required, .references("schools", "id"))
            .field("name", .string, .required)
            .field("value", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("activity_point_types").delete()
    }
}
