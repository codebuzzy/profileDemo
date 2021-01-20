//
//  ProfileViewControllerViewModel.swift
//  ProfileDemo
//
//  Created by Malti Maurya on 20/01/21.
//  Copyright © 2021 Malti Maurya. All rights reserved.
//

import Foundation
import Alamofire

protocol ProfileViewControllerViewModelProtocol {
      var alertMessage: Dynamic<AlertMessage> { get set }
      var response: Dynamic<profileResponse?> { get set }
      func serviceRequest(apiName : EndPointType)
      func failTest()
}

class ProfileViewControllerViewModel: NSObject, ProfileViewControllerViewModelProtocol {

  
      // MARK: - Vars & Lets
  var alertMessage: Dynamic<AlertMessage> = Dynamic(AlertMessage(title: "", body: ""))
  var response: Dynamic<profileResponse?>  = Dynamic(nil)
  private let apiManager = Apimanager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
  let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
  
  // MARK: - Public methods
  func serviceRequest(apiName : EndPointType) {
      
      
      self.apiManager.call(type: apiName){(res: Result<profileResponse?>) in
          switch res
          {
          case .success(let response):
               self.response.value = response
              break
          case .failure(let message):
              self.alertMessage.value = message as! AlertMessage
              break
          }
      }

  }
  
  
  
  func failTest() {
      self.apiManager.call(type: RequestItemsType.fail) { (res:Result<[String : Any]>) in
          switch res {
          case .success(let response):
              print(response)
              break
          case .failure(let message):
           print(message.localizedDescription)
           self.alertMessage.value = message as! AlertMessage
              break
          }
      }
      
  }
}
