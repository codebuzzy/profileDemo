//
//  Profile.swift
//  ProfileDemo
//
//  Created by Malti Maurya on 20/01/21.
//  Copyright © 2021 Malti Maurya. All rights reserved.
//

import Foundation

// MARK: - profileResponse
struct profileResponse: Codable {
    let status: Bool
    let type, message: String
    let data: detail
    let notificationCount, messageCount: Int
    let dispText: String

    enum CodingKeys: String, CodingKey {
        case status, type, message, data
        case notificationCount = "notification_count"
        case messageCount = "message_count"
        case dispText = "disp_text"
    }
}

// MARK: - detail
struct detail: Codable {
    let userID, languages, userEmail, userContact: String
    let userType, userName, userLocation: String
    let userImage: String
    let userDesc, latitude, longitude, pincode: String
    let userRating, uesrNoReview, userTotalQuote, userTotalQuoteCompleted: String
    let portfolio: [portfolio]

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case languages
        case userEmail = "user_email"
        case userContact = "user_contact"
        case userType = "user_type"
        case userName = "user_name"
        case userLocation = "user_location"
        case userImage = "user_image"
        case userDesc = "user_desc"
        case latitude, longitude, pincode
        case userRating = "user_rating"
        case uesrNoReview = "uesr_no_review"
        case userTotalQuote = "user_total_quote"
        case userTotalQuoteCompleted = "user_total_quote_completed"
        case portfolio
    }
}

// MARK: - portfolio
struct portfolio: Codable {
    let portfolioID: String
    let portfolioImage: String

    enum CodingKeys: String, CodingKey {
        case portfolioID = "portfolio_id"
        case portfolioImage = "portfolio_image"
    }
}
