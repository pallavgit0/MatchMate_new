import Foundation

// Global constants
struct Constants {
    static let HEADING =  "MATCH-MATE"
    static let CARD_ACCEPTED = "Accepted"
    static let CARD_DECLINED = "Declined"
    static let BLANK_STR =  ""
    static let BTN_ACCEPT = "Accept"
    static let BTN_DECLINE = "Decline"
    
    struct Errors {
        static let NO_INTERNET = "No network connection. Please try again later."
        static let NO_RESPONSE = "Failed to decode response"
    }
}

//Errors
enum MatchViewModelError: LocalizedError, Equatable {
    case noInternet
    case noResponse
    case failedToFetchProfiles(String)
    case failedToSaveProfile(String)
    case coreDataError(String)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return Constants.Errors.NO_INTERNET
        case .failedToFetchProfiles(let error):
            return "Error fetching profiles: \(error)"
        case .failedToSaveProfile(let error):
            return "Error saving profile: \(error)"
        case .coreDataError(let error):
            return "Core Data error: \(error)"
        case .noResponse:
            return Constants.Errors.NO_RESPONSE
        }
    }
}

