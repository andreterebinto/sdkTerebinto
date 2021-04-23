//
//  RequestParameters.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire

class UserDefaultsManager {
    
    /*static var loginToken: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.loginToken.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.loginToken.value)
        }
    }
    static var lattitude: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.lattitude.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.lattitude.value)
        }
    }
    static var longitude: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.longitude.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.string(forKey: UserDefaultConstants.longitude.value)
        }
    }
    static var launchedOnce: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultConstants.isFirstLaunch.value)
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.bool(forKey: UserDefaultConstants.isFirstLaunch.value)
        }
    }
    
    func getObject(key:String) -> Passenger{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        let encodedString : NSData = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return Passenger(json: JSON(encodedString))
    }
    
    func getPhoto(key:String) -> Photo{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        let encodedString : NSData = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return Photo(json: JSON(encodedString))
    }
    
    func getImageUser(key:String) -> String{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        return jsonString
    }
    
    func getLanguage(key:String) -> String{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        return jsonString
    }
    
    func getToken(key:String) -> String{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        return jsonString
    }
    
    func getObjectPayment(key:String) -> PaymentType{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        let encodedString : NSData = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return PaymentType(json: JSON(encodedString))
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if(key != "payment"){
                if(key=="user") || (key=="image") || (key=="token") || (key=="photo") || (key=="imageUser"){
                    defaults.removeObject(forKey: key)
                }
            }
        }
       defaults.synchronize()
    }
    
    func getHeader()-> [String: String]{
        let HEADER_AUTH = "Basic " + UserDefaultsManager().getToken(key:"token")
        let headerToken = ["Content-Type":"application/json", "Authorization": HEADER_AUTH, "version": AppInfo.Version, "device": "IOS"]
        return headerToken
    }
    
    func getHeaderFirebase()-> [String: String]{
        let HEADER_AUTH = "Key=AIzaSyA2pcbf4W9h2pkUwDz_pXWqpMnfTplSvKQ"
        let headerToken = ["Content-Type":"application/json", "Authorization": HEADER_AUTH]
        return headerToken
    }*/
    
    func getHeader() -> HTTPHeaders{
        
        let headers : HTTPHeaders = [
            "Authorization": "Basic MY-API-KEY",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        return headers
    }
    
    }
