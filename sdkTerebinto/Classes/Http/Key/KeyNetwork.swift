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
    
    public static func createKey(Name: String, KeyType: Int, Algorithm: Int, Expiration: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
       
        let parameters = ["Name": Name, "KeyType": KeyType, "Algorithm": Algorithm, "Expiration": Expiration, "Value": ""] as [String : String]
        
        KeyRoutes.request(.post, endpoint: KeyRoutes.baseURL+KeyRoutes.greateKeyUrl, parameters: parameters ) { (json) in
            if json != JSON.null {
                guard json.dictionaryObject != nil else{
                    completion(false,JSON.null)
                    return
                }
                
                completion(true, json)
            } else {
                completion(false,JSON.null)
            }
        }
    }
    
    public static func getKeys(id: String?, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        if(id != ""){
            KeyRoutes.request(.get, endpoint: KeyRoutes.baseURL+KeyRoutes.getKeyByIdURL+id! ) { (json) in
                if json != JSON.null {
                    guard json.dictionaryObject != nil else{
                        completion(false,JSON.null)
                        return
                    }
                    
                    completion(true, json)
                } else {
                    completion(false,JSON.null)
                }
            }
        }else{
            KeyRoutes.request(.post, endpoint: KeyRoutes.baseURL+KeyRoutes.greateKeyUrl ) { (json) in
                if json != JSON.null {
                    guard json.dictionaryObject != nil else{
                        completion(false,JSON.null)
                        return
                    }
                    
                    completion(true, json)
                } else {
                    completion(false,JSON.null)
                }
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
  

