//
//  Messages.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//


import SwiftyJSON

public class UserDefaultsManager {
    
    public func getObject(key:String) -> NSData{
        var jsonString = String()
        let pref = UserDefaults.standard
        if let string = pref.value(forKey: key) {
            jsonString = string as! String
        }
        let encodedString : NSData = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return encodedString
    }
    
    public func removeObjects(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "AuthSessionKey")
        prefs.removeObject(forKey: "RefreshToken")
        prefs.removeObject(forKey: "Token")
        prefs.removeObject(forKey: "pin")
        prefs.removeObject(forKey: "scan")
    }
    
    public func getToken(){
        return UserDefaults.standard.string(forKey: "Token")
    }
    
    public func getRefreshToken(){
        return UserDefaults.standard.string(forKey: "RefreshToken")
    }
    
    public func getAuthSessionKey(){
        returnUserDefaults.standard.string(forKey: "AuthSessionKey")
    }
    
    public func setPin(pin: String){
        let pref = UserDefaults.standard
        pref.set(pin, forKey: "pin")
    }
    
    public func getPin(){
        return UserDefaults.standard.string(forKey: "pin")
    }
    
    public func setScan(scan: String){
        let pref = UserDefaults.standard
        pref.set(scan, forKey: "scan")
    }
    
    public func getScan(){
        return UserDefaults.standard.string(forKey: "scan")
    }
    
    }


