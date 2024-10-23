import Fluent

public final class School: Model, @unchecked Sendable {
    public final class Modules: Fields, @unchecked Sendable {
        @Field(key: "behaviour_enabled")
        public var behaviourEnabled: Bool
        public init() {}
        public init(behaviourEnabled: Bool = true) {
            self.behaviourEnabled = behaviourEnabled
        }
    }

    public static let schema = "schools"

    public init() {}
    public init(id: Int? = nil, name: String, modules: Modules = .init()) {
        self.id = id
        self.name = name
        self.modules = modules
    }

    @ID(custom: "id")
    public var id: Int?

    @Field(key: "name")
    public var name: String

    @Group(key: "modules")
    public var modules: Modules
}

struct CreateSchool: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("schools")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("modules_behaviour_enabled", .bool, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("schools").delete()
    }
}

struct SeedSchool: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        School(
            id: 1000,
            name: "Test School",
            modules: School.Modules(behaviourEnabled: true)
        ).save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        School.query(on: database).filter(\.$id == 1000).delete()
    }
}
