

import Foundation
import SwiftUI

// MARK: - UserResponse
struct UserResponse: Codable {
    let results: [User]
    let info: Info?
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct User: Codable, Identifiable {
    var id: String {
        login.uuid
    }
    let gender: String
    let name: Name
    let location: Location
    let email: String?
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    let idInfo: ID
    let picture: Picture
    let nat: String
    
    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, login, dob, registered, phone, cell, picture, nat
        case idInfo = "id"
    }
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}


// MARK: - ID
struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street
    let city, state, country: String
    let postcode: String // We'll keep postcode as a String here for flexibility
    let coordinates: Coordinates
    let timezone: Timezone

    enum CodingKeys: String, CodingKey {
        case street, city, state, country, postcode, coordinates, timezone
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)
        
        // Handling postcode as either Int or String
        if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(postcodeInt)
        } else if let postcodeString = try? container.decode(String.self, forKey: .postcode) {
            postcode = postcodeString
        } else {
            postcode = Constants.BLANK_STR
        }
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, description: String
}

// MARK: - Login
struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
