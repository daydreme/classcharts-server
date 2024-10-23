import CasePaths
import Vapor

class RouteHandlingClass<Route> {
    typealias Aggregator = RouteAggregator<Route>
    lazy var router = Aggregator()
}

protocol RouteHandlingProtocol {
    associatedtype Route
    var router: RouteAggregator<Route> { get }
    func register(on router: RouteAggregator<Route>)
}

typealias RouteHandling<Route> = RouteHandlingProtocol & RouteHandlingClass<Route>

protocol Routable {
    associatedtype Route: CasePathable
    var route: Route { get }
}

final class RouteAggregator<A>: @unchecked Sendable {
    typealias RequestFn = @Sendable (Request, A) async throws -> AsyncResponseEncodable
    var request: RequestFn = { _, _ in "" }
}

extension RouteAggregator where A: Routable {
    func register<Value>(
        _ matchingRoute: CaseKeyPath<A.Route, Value>,
        withResponse response: @escaping @Sendable (Request, Value) async throws ->
            AsyncResponseEncodable
    ) {
        self.request = { @Sendable [self] request, value in
            if let route = value.route[case: matchingRoute] {
                return try await response(request, route)
            } else {
                return try await self.request(request, value)
            }
        }
    }

    func register<Value>(
        _ matchingRoute: CaseKeyPath<A.Route, Value>,
        withResponse response: @escaping @Sendable (Request, Value, A) async throws ->
            AsyncResponseEncodable
    ) {
        self.request = { @Sendable [self] request, value in
            if let route = value.route[case: matchingRoute] {
                return try await response(request, route, value)
            } else {
                return try await self.request(request, value)
            }
        }
    }
}

extension RouteAggregator where A: CasePathable {
    func register<Value: Routable>(
        _ matchingRoute: CaseKeyPath<A, Value>,
        withHandler handler: some RouteHandling<Value>
    ) {
        register(matchingRoute, withResponse: handler.router.request)
        handler.register(on: handler.router)
    }

    func register<Value>(
        _ matchingRoute: CaseKeyPath<A, Value>,
        withResponse response: @escaping @Sendable (Request, Value) async throws ->
            AsyncResponseEncodable
    ) {
        self.request = { @Sendable [self] request, route in
            if let value = route[case: matchingRoute] {
                return try await response(request, value)
            } else {
                return try await self.request(request, route)
            }
        }
    }
}
