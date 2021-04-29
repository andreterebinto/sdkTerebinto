//
//  LoginNetwork.swift
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

public struct RegisterNetwork {
    
    private static var countLoader = 0 {
        didSet {
            RegisterNetwork.verifyActivityIndicator()
        }
    }
    
    static func registration(parameters: [String: Any], completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        LoginRoutes.request(.post, endpoint: LoginRoutes.baseURL, parameters: parameters ) { (json) in
            if json != JSON.null {
                guard let dictionary = json.dictionaryObject else{
                    completion(false,JSON.null)
                    return
                }
                
                if let error = dictionary["typeErrorReturn"] as? String{
                    
                    if error == "SUCCESS"{
                        let object = json["object"].dictionaryValue
                        debugPrint(object)
                        completion(true, JSON(object))
                    } else if error == "BUSINESS"{
                        completion(true, json["message"])
                        
                    }else if error == "EXECUTION"{
                        completion(false, json["message"])
                    }else {
                        completion(false,JSON.null)
                    }
                }
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    public static func login(parameters: [String: Any], completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        LoginRoutes.request(.post, endpoint: LoginRoutes.baseURL+LoginRoutes.loginURL, parameters: parameters ) { (json) in
            if json != JSON.null {
                guard let dictionary = json.dictionaryObject else{
                    completion(false,JSON.null)
                    return
                }
                
                completion(true, json)
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    public static func getSalt(email: String, password: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        LoginRoutes.request(.get, endpoint: LoginRoutes.baseURL+LoginRoutes.saltURL+email ) { (json) in
            if json != JSON.null {
                guard let dictionary = json.dictionaryObject else{
                    completion(false,JSON.null)
                    return
                }
                
                if(json["Message"] == "Success"){
                   
                    //GetPassWord Salt
                    let salt = json["PasswordSalt"].description;
                    
                    if let nsdata1 = Data(base64Encoded: salt, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {

                        let passSalt = nsdata1.withUnsafeBytes {
                           Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1.count/MemoryLayout<UInt8>.size))
                        }
                        let passwordArray = uiTextPassword.text?.description.data(using: .utf16LittleEndian)!
                       
                        do{
                           let key =  try scrypt(password: passwordArray!.bytes, salt: passSalt, length: 32, N: 32768, r: 8, p: 1)
                            let parameters = ["Password": (key.toBase64())!, "AuthSessionKey": json["AuthSessionKey"].description] as [String : String]
                            login(parameters: parameters) { (success, response) in
                                if success {
                                    print(response)
                                    completion(true, response)
                                } else {
                                    completion(false,JSON.null)
                                }
                        }catch{
                            completion(false,JSON.null)
                        }
                    }
                    
                  
                }
                
                
                
                
                
                
                //completion(true, json)
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    static func update(parameters: [String: Any], completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        requestServer.request(.post, endpoint: LoginRoutes.baseURL+LoginRoutes.updateURL, parameters: parameters ) { (json) in
            if json != JSON.null {
                guard let dictionary = json.dictionaryObject else{
                    completion(false,JSON.null)
                    return
                }
                
                if let error = dictionary["typeErrorReturn"] as? String{
                    
                    if error == "SUCCESS"{
                        let object = json["object"].dictionaryValue
                        debugPrint(object)
                        completion(true, JSON(object))
                    } else if error == "BUSINESS"{
                        completion(true, json["message"])
                        
                    }else if error == "EXECUTION"{
                        completion(false, json["message"])
                    }else {
                        completion(false,JSON.null)
                    }
                }
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
            RegisterNetwork.showActivityIndicator(show: true)
        } else if countLoader == 0 {
            RegisterNetwork.showActivityIndicator(show: false)
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
    public func scrypt(password: [UInt8], salt: [UInt8], length: Int = 64,
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

extension BinaryInteger {
    var isPowerOfTwo: Bool {
        (self > 0) && (self & (self - 1) == 0)
    }
}


