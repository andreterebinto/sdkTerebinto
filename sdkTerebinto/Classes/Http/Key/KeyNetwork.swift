//
//  KeyNetwork.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift
import CommonCrypto
import scrypt
import JWTDecode
import UIKit

public struct KeyNetwork {
    
    private static var countLoader = 0 {
        didSet {
            KeyNetwork.verifyActivityIndicator()
        }
    }
    
    public static func createKey(Name: String, KeyType: Int, Algorithm: Int, Expiration: String, Value: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        var addSec = ""
        var addMin = ""
        var addHour = ""
        
        if (hour < 10){
            addHour = "0"+hour.description
        }else{
            addHour = hour.description
        }
        
        if (second < 10){
            addSec = "0"+second.description
        }else{
            addSec = second.description
        }
        
        if (minute < 10){
            addMin = "0"+minute.description
        }else{
            addMin = minute.description
        }
        
        let nowHour = Expiration.description+"T"+addHour+":"+addMin+":"+addSec+"+0000"
        
       

        let dateFormatter = ISO8601DateFormatter()
        let dates = dateFormatter.date(from:nowHour)!
        
        let parameters = ["UserId": "", "Name": Name.description, "KeyType": KeyType, "Algorithm": Algorithm, "Expiration": Int(dates.timeIntervalSince1970), "Value": Value] as! [String : Any]
        print(parameters)
        KeyRoutes.requestInt(.post, endpoint: KeyRoutes.baseURL+KeyRoutes.greateKeyUrl, parameters: parameters ) { (json) in
            if (json == 200) {
                completion(true, 200)
            } else {
                completion(false,401)
            }
        }
    }
    
    public static func encryptKey(KeyId: String, Text: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
       
        let parameters = ["UserId": "", "KeyId": KeyId.description, "Text": Text.description] as! [String : Any]
       
        KeyRoutes.request(.post, endpoint: KeyRoutes.baseURL+KeyRoutes.encryptURL, parameters: parameters ) { (json) in
            if json != JSON.null {
                completion(true, json)
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    public static func decryptKey(KeyId: String, Text: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
       
        let parameters = ["UserId": "", "KeyId": KeyId.description, "Ciphertext": Text.description] as! [String : Any]
       
        KeyRoutes.request(.post, endpoint: KeyRoutes.baseURL+KeyRoutes.decryptURL, parameters: parameters ) { (json) in
            if json != JSON.null {
                completion(true, json)
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    
    public static func deleteKey(keyId: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
       
        let parameters = ["keyId": keyId] as! [String : Any]
       
        KeyRoutes.requestInt(.delete, endpoint: KeyRoutes.baseURL+KeyRoutes.deleteKeyURL+"?keyId="+keyId.description, parameters: parameters ) { (json) in
            if (json == 200) {
                completion(true, 200)
            } else {
                completion(false,401)
            }
        }
    }
    
    public static func getKeys(id: String?, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        if(id != ""){
            KeyRoutes.request(.get, endpoint: KeyRoutes.baseURL+KeyRoutes.getKeyByIdURL+"/id?keyId="+id!.description ) { (json) in
                if json != JSON.null {
                    completion(true, json)
                } else {
                    completion(false,JSON.null)
                }
            }
        }else{
            KeyRoutes.request(.get, endpoint: KeyRoutes.baseURL+KeyRoutes.getkeysUrl ) { (json) in
                if json != JSON.null {
                    completion(true, json)
                } else {
                    completion(false,JSON.null)
                }
            }
            
        }
        
       
    }
    
    
    public static func getKeysAll(completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
       
        KeyRoutes.request(.get, endpoint: KeyRoutes.baseURL+KeyRoutes.decryptlistUrlDevices ) { (json) in
                if json != JSON.null {
                    completion(true, json)
                } else {
                    completion(false,JSON.null)
                }
            }
         
       
    }
    

    private static func showActivityIndicator(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    
    private static func verifyActivityIndicator() {
        if countLoader > 0 && !UIApplication.shared.isNetworkActivityIndicatorVisible {
            KeyNetwork.showActivityIndicator(show: true)
        } else if countLoader == 0 {
            KeyNetwork.showActivityIndicator(show: false)
        }
    }
    
   
    
    /// All errors `scrypt` can throw.
    /// - Tag: scryptErrorType
    public enum ScryptError: Error {
        /// Thrown length isn't between 1 and (2^32 - 1) * 32.
        case invalidLength
        /// Thrown if any of N, r, p are 0 or N isn't a power of two.
        case invalidParameters
        /// Thrown if the password given was empty.
        case emptyPassword
        /// Thrown if the salt given was empty.
        case emptySalt
        /// Thrown if libscrypt returns an unexpected response code.
        case unknownError(code: Int32)
    }

    /// Compute scrypt hash for given parameters.
    /// - Parameter password: The password bytes.
    /// - Parameter salt: The salt bytes.
    /// - Parameter length: Desired hash length.
    /// - Parameter N: Difficulty, must be a power of two.
    /// - Parameter r: Sequential read size.
    /// - Parameter p: Number of parallelizable iterations.
    /// - Returns: Password hash corresponding to given `length`.
    /// - Throws: [ScryptError](x-source-tag://scryptErrorType)
    public static func scrypt(password: [UInt8], salt: [UInt8], length: Int = 64,
                       N: UInt64 = 16384, r: UInt32 = 8, p: UInt32 = 1) throws -> [UInt8] {
        guard length > 0, UInt64(length) <= 137_438_953_440 else {
            throw ScryptError.invalidLength
        }
        guard r > 0, p > 0, r * p < 1_073_741_824, N.isPowerOfTwo else {
            throw ScryptError.invalidParameters
        }
        var rv = [UInt8](repeating: 0, count: length)
        var result: Int32 = -1
        try rv.withUnsafeMutableBufferPointer { bufptr in
            try password.withUnsafeBufferPointer { passwd in
                guard !passwd.isEmpty else {
                    throw ScryptError.emptyPassword
                }
                try salt.withUnsafeBufferPointer { saltptr in
                    guard !saltptr.isEmpty else {
                        throw ScryptError.emptySalt
                    }
                    result = crypto_scrypt(
                        passwd.baseAddress!, passwd.count,
                        saltptr.baseAddress!, saltptr.count,
                        N, r, p,
                        bufptr.baseAddress!, length
                    )
                }
            }
        }
        guard result == 0 else {
            throw ScryptError.unknownError(code: result)
        }
        return rv
    }
        
    }
  

