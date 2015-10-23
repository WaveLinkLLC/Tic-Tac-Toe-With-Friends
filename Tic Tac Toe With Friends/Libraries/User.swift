//
//  User.swift
//  Tic Tac Toe With Friends
//
//  Created by Kelvin Graddick on 10/22/15.
//  Copyright © 2015 Wave Link, LLC. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

class User {
    
    static let sharedInstance = User()
    var keychain = Keychain(service: "wavelinkllc.Tic-Tac-Toe-With-Friends")
    var isLoggedIn: Bool = false
    var deviceToken: String = ""
    
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var photo: String = ""
    var facebookId: String = ""
    var twitterId: String = ""
    var digitsId: String = ""
    var wins: String = ""
    
    func login(completion: (isSuccess: Bool) -> Void) {
        Alamofire.request(.POST, "http://www.wavelinkllc.com/tictactoewithfriends/login.php", parameters: ["userId": self.id, "facebookId": self.facebookId, "twitterId": self.twitterId, "digitsId": self.digitsId, "iOSdeviceToken": self.deviceToken])
            .responseJSON { response in
                if (response.result.isSuccess) {
                    if (response.result.value != nil) {
                        let data: Dictionary = (response.result.value as? Dictionary<String, AnyObject>)!
                        self.id = self.getString(data["userId"])
                        self.name = self.getString(data["name"])
                        self.email = self.getString(data["email"])
                        self.phone = self.getString(data["phone"])
                        self.photo = self.getString(data["photo"])
                        self.facebookId = self.getString(data["facebookId"])
                        self.twitterId = self.getString(data["twitterId"])
                        self.digitsId = self.getString(data["digitsId"])
                        self.wins = self.getString(data["wins"])
                        self.isLoggedIn = true
                        self.keychain["userId"] = self.id
                        completion(isSuccess: true)
                    } else {
                        completion(isSuccess: false)
                    }
                } else {
                    // network error
                    completion(isSuccess: false)
                }
        }
    }
    
    func logout(completion: (isSuccess: Bool) -> Void) {
        Alamofire.request(.POST, "http://www.wavelinkllc.com/tictactoewithfriends/logout.php", parameters: ["iOSdeviceToken": self.deviceToken])
            .responseJSON { response in
                if (response.result.isSuccess) {
                    let data: Dictionary = (response.result.value as? Dictionary<String, AnyObject>)!
                    if (data["isAuthenticated"] as! String == "true") {
                        self.id = ""
                        self.name = ""
                        self.email = ""
                        self.phone = ""
                        self.photo = ""
                        self.facebookId = ""
                        self.twitterId = ""
                        self.digitsId = ""
                        self.wins = ""
                        self.isLoggedIn = false
                        self.keychain["userId"] = nil
                        completion(isSuccess: true)
                    } else {
                        completion(isSuccess: false)
                    }
                } else {
                    // network error
                    completion(isSuccess: false)
                }
        }
    }
    
    private func getString(object: AnyObject?) -> String {
        let string: String? = object as? String
        return string != nil ? string! : "";
    }
    
}
