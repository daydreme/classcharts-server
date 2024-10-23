public struct ApiStudent: Codable {
    public let id: Int
    public let name: String
    public let firstName: String
    public let lastName: String
    public let avatarUrl: String
    public let displayBehaviour: Bool
    public let displayParentBehaviour: Bool
    public let displayHomework: Bool
    public let displayRewards: Bool
    public let displayDetentions: Bool
    public let displayReportCards: Bool
    public let displayClasses: Bool
    public let displayAnnouncements: Bool
    public let displayAttendance: Bool
    public let displayAttendanceType: String
    public let displayAttendancePercentage: Bool
    public let displayActivity: Bool
    public let displayMentalHealth: Bool
    public let displayTimetable: Bool
    public let isDisabled: Bool
    public let displayTwoWayCommunications: Bool
    public let displayAbsences: Bool
    public let canUploadAttachments: Bool?
    public let displayEventBadges: Bool
    public let displayAvatars: Bool
    public let displayConcernSubmission: Bool
    public let displayCustomFields: Bool
    public let pupilConcernsHelpText: String
    public let allowPupilsAddTimetableNotes: Bool
    public let announcementsCount: Int
    public let messagesCount: Int
    public let pusherChannelName: String
    public let hasBirthday: Bool
    public let hasNewSurvey: Bool
    public let surveyId: Int?
    public let detentionAliasPluralUc: String

    public init(
        id: Int, name: String, firstName: String, lastName: String, avatarUrl: String,
        displayBehaviour: Bool, displayParentBehaviour: Bool, displayHomework: Bool,
        displayRewards: Bool, displayDetentions: Bool, displayReportCards: Bool,
        displayClasses: Bool, displayAnnouncements: Bool, displayAttendance: Bool,
        displayAttendanceType: String, displayAttendancePercentage: Bool, displayActivity: Bool,
        displayMentalHealth: Bool, displayTimetable: Bool, isDisabled: Bool,
        displayTwoWayCommunications: Bool, displayAbsences: Bool, canUploadAttachments: Bool?,
        displayEventBadges: Bool, displayAvatars: Bool, displayConcernSubmission: Bool,
        displayCustomFields: Bool, pupilConcernsHelpText: String,
        allowPupilsAddTimetableNotes: Bool, announcementsCount: Int, messagesCount: Int,
        pusherChannelName: String, hasBirthday: Bool, hasNewSurvey: Bool, surveyId: Int?,
        detentionAliasPluralUc: String
    ) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
        self.displayBehaviour = displayBehaviour
        self.displayParentBehaviour = displayParentBehaviour
        self.displayHomework = displayHomework
        self.displayRewards = displayRewards
        self.displayDetentions = displayDetentions
        self.displayReportCards = displayReportCards
        self.displayClasses = displayClasses
        self.displayAnnouncements = displayAnnouncements
        self.displayAttendance = displayAttendance
        self.displayAttendanceType = displayAttendanceType
        self.displayAttendancePercentage = displayAttendancePercentage
        self.displayActivity = displayActivity
        self.displayMentalHealth = displayMentalHealth
        self.displayTimetable = displayTimetable
        self.isDisabled = isDisabled
        self.displayTwoWayCommunications = displayTwoWayCommunications
        self.displayAbsences = displayAbsences
        self.canUploadAttachments = canUploadAttachments
        self.displayEventBadges = displayEventBadges
        self.displayAvatars = displayAvatars
        self.displayConcernSubmission = displayConcernSubmission
        self.displayCustomFields = displayCustomFields
        self.pupilConcernsHelpText = pupilConcernsHelpText
        self.allowPupilsAddTimetableNotes = allowPupilsAddTimetableNotes
        self.announcementsCount = announcementsCount
        self.messagesCount = messagesCount
        self.pusherChannelName = pusherChannelName
        self.hasBirthday = hasBirthday
        self.hasNewSurvey = hasNewSurvey
        self.surveyId = surveyId
        self.detentionAliasPluralUc = detentionAliasPluralUc
    }
}

public struct ApiPingData: Codable {
    public init(user: ApiStudent) {
        self.user = user
    }
    public var user: ApiStudent
}

public struct ApiPingMeta: Codable {
    public init(version: String, sessionId: String) {
        self.version = version
        self.sessionId = sessionId
    }
    public var version: String
    public var sessionId: String?
}
