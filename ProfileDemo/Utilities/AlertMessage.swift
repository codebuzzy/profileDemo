//
//  AlertMessage.swift
//  PaperVideo
//
//  Created by 1st iMac on 11/03/20.
//  Copyright © 2020 appic. All rights reserved.
//

import Foundation
class AlertMessage: Error {
    
    // MARK: - Vars & Lets
    
    var title = ""
    var body = ""
    
    // MARK: - Intialization
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
}
