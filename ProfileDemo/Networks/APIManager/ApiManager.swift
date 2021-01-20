//
//  ApiManager.swift
//  MoviePlayer
//
//  Created by Malti Maurya on 09/12/20.
//  Copyright © 2020 Malti Maurya. All rights reserved.
//

import Alamofire
import Foundation

class Apimanager {
    
    // MARK: - Vars & Lets
    
  //  private let sessionManager: SessionManager
    private let retrier: APIManagerRetrier
    static let networkEnviroment: NetworkEnvironment = .dev
    
    // MARK: - Public methods
    private var sessionManager: Alamofire.SessionManager

    func call(type: EndPointType, params: Parameters? = nil, handler: @escaping (Result<[String: Any]>)-> Void) {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON{ response in
            
                                    switch response.result{
                
                                    case .success(let value as [String: Any]):
                                        handler(.success(value))
                                        break
                                    case .failure(_):
                                
                                        
                                        handler(.failure(self.parseApiError(data: response.data)))
                                        break
                                    default:
                                        fatalError("received non-dictionary JSON response")
                                        }
            }
        
        }


    func call<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (Result<T>) -> Void) where T: Codable {


        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { (data) in
                                        do {
                                            guard let jsonData = data.data else {
                                                throw AlertMessage(title: "Error", body: "No data")
                                            }
                                            print(data.result)
                                            let result = try JSONDecoder().decode(T.self, from: jsonData)
                                            handler(.success(result))
                                            self.resetNumberOfRetries()
                                        } catch {
                                            if let error = error as? AlertMessage {
                                                return handler(.failure(error))
                                            }
                                            handler(.failure(self.parseApiError(data: data.data)))
                                        }
        }
    }
    
    // MARK: - Private methods
    
    private func resetNumberOfRetries() {
        self.retrier.numberOfRetries = 1
    }
    
    private func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(NetworkError.self, from: jsonData) {
            return AlertMessage(title: Constants.errorAlertTitle, body: error.key ?? error.message)
        }
        return AlertMessage(title: Constants.errorAlertTitle, body: Constants.genericErrorMessage)
    }
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager, retrier: APIManagerRetrier) {
        self.sessionManager = sessionManager
        self.retrier = retrier
        self.sessionManager.retrier = self.retrier
    }
    
}
extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(from: JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Self.self, from: data)
    }

}
