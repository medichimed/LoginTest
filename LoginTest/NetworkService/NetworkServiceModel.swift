//
//  NetworkServiceModel.swift
//  LoginTest
//
//  Created by Oksana Kotilevska on 20.01.2021.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let userDetails: UserDetails

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userDetails = "user"
    }
}

struct UserDetails: Decodable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    let lastSeenAt: Date?
    let projectId: String

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case lastSeenAt = "last_seen_at"
        case projectId = "project_id"
        case email
    }
}
