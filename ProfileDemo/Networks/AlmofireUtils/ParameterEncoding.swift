//
//  ParameterEncoding.swift
//  MoviePlayer
//
//  Created by Malti Maurya on 09/12/20.
//  Copyright © 2020 Malti Maurya. All rights reserved.
//

import Alamofire

extension String: ParameterEncoding {
    
    // MARK: - Public Methods
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
