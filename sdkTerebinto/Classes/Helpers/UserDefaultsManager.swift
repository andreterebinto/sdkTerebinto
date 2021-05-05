//
//  Messages.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//


import SwiftyJSON

public struct UserDefaultsManagers {
    
    public func getObject(key:String) -> NSData{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        let encodedString : NSData = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return encodedString
    }
    
    public static func removeObjects(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "AuthSessionKey")
        prefs.removeObject(forKey: "RefreshToken")
        prefs.removeObject(forKey: "Token")
        prefs.removeObject(forKey: "pin")
        prefs.removeObject(forKey: "scan")
    }
    
    public static func getToken() -> String{
        return UserDefaults.standard.string(forKey: "Token") ?? ""
    }
    
    public static func getRefreshToken() -> String{
        return UserDefaults.standard.string(forKey: "RefreshToken") ?? ""
    }
    
    public static func getAuthSessionKey() -> String{
        return UserDefaults.standard.string(forKey: "AuthSessionKey") ?? ""
    }
    
    public static func setPin(pin: String){
        let pref = UserDefaults.standard
        pref.set(pin, forKey: "pin")
    }
    
    public static func getPin() -> String{
        return UserDefaults.standard.string(forKey: "pin") ?? ""
    }
    
    public static func setScan(scan: String){
        let pref = UserDefaults.standard
        pref.set(scan, forKey: "scan")
    }
    
    public static func getScan() -> String{
        return UserDefaults.standard.string(forKey: "scan") ?? ""
    }
    
    }


