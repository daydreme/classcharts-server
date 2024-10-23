import FluentSQLiteDriver
import JWT
import Vapor

enum ConfigurationError: Error {
    case noJWTSecret
}

public func configure(_ app: Application) async throws {
    registerGlobalJSONCoders()
    app.middleware.use(cors(), at: .beginning)

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.asyncCommands.use(SeedCommand(), as: "seed")

    app.migrations.add(allCreationMigrations)
    try await app.autoMigrate()

    guard let jwtSecret = Environment.get("JWT_SECRET") else {
        throw ConfigurationError.noJWTSecret
    }

    await app.jwt.keys.add(hmac: HMACKey(from: jwtSecret), digestAlgorithm: .sha256)

    let handler = RootHandler()
    handler.register(on: handler.router)
    app.mount(ServerRouter(), use: handler.router.request)
}

func cors() -> CORSMiddleware {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    return CORSMiddleware(configuration: corsConfiguration)
}

func registerGlobalJSONCoders() {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    ContentConfiguration.global.use(decoder: decoder, for: .json)
}
