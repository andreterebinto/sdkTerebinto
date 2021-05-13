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
        prefs.removeObject(forKey: "User")
        prefs.removeObject(forKey: "imageUSer")
        prefs.removeObject(forKey: "faceId")
        
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
    
    public static func setImage(image: String){
        let pref = UserDefaults.standard
        pref.set(image, forKey: "imageUSer")
    }
    
    public static func getImage() -> String{
        return UserDefaults.standard.string(forKey: "imageUSer") ?? ""
    }
    
    
    
    public static func getUSer() -> User{
        var retornoJson: User
        let parameter = [] as JSON
        retornoJson = User(json: parameter)!
       
            
            if let result = UserDefaults.standard.string(forKey: "User") {
                
                if let json = result.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                   
                    do {
                        let verifica = try JSONDecoder().decode(User.self, from: json)
                        retornoJson = verifica
                        
                    }catch{
                        let parameter = [] as JSON
                        retornoJson = User(json: parameter)!
                    }
                    
                }
                
                
            }
        
        return retornoJson
            
    }

}
