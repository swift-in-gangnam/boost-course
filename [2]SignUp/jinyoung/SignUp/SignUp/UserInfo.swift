//
//  UserInfo.swift
//  SignUp
//
//  Created by Jinyoung Kim on 2021/09/01.
//

import Foundation
import UIKit

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var phoneNumber: String?
    var birthdayDate: Date?
    
    func resetUserInformation() {
        id = nil
        phoneNumber = nil
        birthdayDate = nil
    }
}
