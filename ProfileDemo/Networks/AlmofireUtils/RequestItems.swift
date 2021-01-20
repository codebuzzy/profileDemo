//
//  RequestItems.swift
//  MoviePlayer
//
//  Created by Malti Maurya on 09/12/20.
//  Copyright © 2020 Malti Maurya. All rights reserved.
//

import Alamofire


// MARK: - Enums

enum NetworkEnvironment {
    case dev
}

enum RequestItemsType {
    
    // MARK: Events
    case profile
    case fail
    
    
}

// MARK: - Extensions
// MARK: - EndPointType

extension RequestItemsType: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        switch Apimanager.networkEnviroment {
        case .dev: return "http://dev.ncryptedprojects.com/thumbpin/ws-profile/"
        }
    }
    
    var version: String {
        return "/3"
    }

    var path: String {
        switch self {
        case .profile :
            return "?action=" + Constants.apiParameters.action + "&user_id=" + Constants.apiParameters.userId + "&user_type=" + Constants.apiParameters.userType +
            "&lId=" + Constants.apiParameters.lId
        case .fail :
            return "fail"
        }
    }
    
    
    var httpMethod: HTTPMethod {
        switch self {
        case .profile :
            return .post
        default:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
            
        default: return ["Accept": "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"]
      
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.httpBody
        }
    }
    
}

