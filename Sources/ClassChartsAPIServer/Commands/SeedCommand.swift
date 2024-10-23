import Vapor

struct SeedCommand: AsyncCommand {
    struct Signature: CommandSignature {}

    var help: String {
        "Seeds database"
    }

    func run(using context: CommandContext, signature: Signature) async throws {
        context.application.migrations.add(allSeedMigrations)
        try await context.application.autoMigrate()
    }
}
