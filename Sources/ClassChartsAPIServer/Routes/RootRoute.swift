import CasePaths
import Dates
import Foundation
import Vapor
import VaporRouting

@CasePathable
public enum ServerRoute: Equatable {
    case student(Student)
    case validateStudentAccessCode(String)
    case authenticateStudent(accessCode: String, dateOfBirth: OptionalField<Date>)

    public struct Student: Equatable, Routable {
        var route: Route

        public init(route: Route) {
            self.route = route
        }

        @CasePathable
        public enum Route: Equatable, Sendable {
            case ping(refreshToken: Bool)
        }
    }
}

public struct ServerRouter: ParserPrinter {
    public let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    public init() {}

    public var body: some VaporRouting.Router<ServerRoute> {
        OneOf {
            Route(.case(ServerRoute.student)) {
                Path { "apiv2student" }
                Parse(.memberwise(ServerRoute.Student.init(route:))) {
                    self.studentRouter
                }
            }

            Route(.case(ServerRoute.authenticateStudent)) {
                Method.post
                Path {
                    "apiv2student"
                    "login"
                }
                Body {
                    OneOf {
                        FormData {
                            Field("code")
                            Field(
                                "dob",
                                .date(formatter: dateFormatter).optional(),
                                default: .valueless
                            )
                        }
                    }
                }
            }

            Route(.case(ServerRoute.validateStudentAccessCode)) {
                Method.post
                Path {
                    "apiv2student"
                    "hasdob"
                }
                Body {
                    FormData {
                        Field("code")
                    }
                }
            }
        }
    }

    @ParserBuilder<URLRequestData>
    var studentRouter: AnyParserPrinter<URLRequestData, ServerRoute.Student.Route> {
        OneOf {
            Route(.case(ServerRoute.Student.Route.ping)) {
                Path { "ping" }
                Method.post
                Body {
                    FormData {
                        Field("include_data", .boolean, default: true)
                    }
                }
            }
        }.eraseToAnyParserPrinter()
    }
}
