class PingHandler: RouteHandling<ServerRoute.Student> {
    func register(on router: Aggregator) {
        router.register(\.ping) { request, refreshToken, metadata in
            "Pong"
        }
    }
}
