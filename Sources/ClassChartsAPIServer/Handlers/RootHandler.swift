import ApiModels
import CasePaths
import Vapor

extension ApiResponse: Content {}

class StudentHandler: RouteHandling<ServerRoute.Student> {
    func register(on router: Aggregator) {
        PingHandler().register(on: router)
    }
}

class RootHandler: RouteHandling<ServerRoute> {
    func register(on router: Aggregator) {
        router.register(\.student, withHandler: StudentHandler())
    }
}
