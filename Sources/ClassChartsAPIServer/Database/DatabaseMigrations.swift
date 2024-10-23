import Fluent

let allSeedMigrations: [any Migration] = [SeedSchool(), SeedStudent()]
let allCreationMigrations: [any Migration] = [
    CreateSchool(), CreateStudent(), CreateActivityPointType(), CreateActivityPoint(),
]
