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
import JWTDecode
import UIKit

public struct UserNetwork {
    
    private static var countLoader = 0 {
        didSet {
            UserNetwork.verifyActivityIndicator()
        }
    }
    
    
    public static func updateProfile(Name: String, Email: String, PhoneNumber: String, completion:@escaping (_ success: Bool,_ tipology: Int) -> Void){
        
        let parameters = ["Name": Name, "Email": Email, PhoneNumber: UserDefaultsManagers.getUSer().PhoneNumber] as [String : String]
       
        
        UserRoutes.request(.post, endpoint: UserRoutes.baseURL+UserRoutes.updateURL, parameters: parameters ) { (json) in
            if (json == 200) {
                
                completion(true, 200)
            } else {
                completion(false,401)
            }
        }
    }
    
    
    public static func changePassword(CurrentPassword: String, NewPassword: String, completion:@escaping (_ success: Bool,_ tipology: Int) -> Void){
        
      
        LoginRoutes.request(.get, endpoint: LoginRoutes.baseURL+LoginRoutes.saltURL+UserDefaultsManagers.getUSer().Email ) { (json) in
            if json != JSON.null {
                guard json.dictionaryObject != nil else{
                    completion(false,401)
                    return
                }
                //retorno do getSalt sucesso
                if(json["Message"] == "Success"){
                    //GetPassWord Salt
                    let salt = json["PasswordSalt"].description;
                    
                    //Pego os valores bytes
                    if let nsdata1 = Data(base64Encoded: salt, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                        
                        //convertpo salt para bytes
                        let passSalt = nsdata1.withUnsafeBytes {
                           Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1.count/MemoryLayout<UInt8>.size))
                        }
                        //Aqui eu pego o password atual e o novo password e converto para data cm encode utf16LittleEndian
                        let CurrentpasswordArray = CurrentPassword.data(using: .utf16LittleEndian)!
                        let NewpasswordArray = NewPassword.data(using: .utf16LittleEndian)!
                        
                        do{
                            //Faço a derivação dos password e novo password
                            let keyCurrent =  try scrypt(password: CurrentpasswordArray.bytes, salt: passSalt, length: 32, N: 32768, r: 8, p: 1)
                            let keyNew =  try scrypt(password: NewpasswordArray.bytes, salt: passSalt, length: 32, N: 32768, r: 8, p: 1)
                            let parameters = ["CurrentPassword": (keyCurrent.toBase64())!, "NewPassword":  (keyNew.toBase64())!] as [String : String]
                           
                            UserRoutes.request(.post, endpoint: UserRoutes.baseURL+UserRoutes.changPassURL, parameters: parameters ) { (json) in
                                if (json == 200) {
                                    completion(true, 200)
                                } else {
                                    completion(false,401)
                                }
                            }
                        }catch{
                            completion(false,401)
                        }
                    }
                }else{
                    completion(false,401)
                }
                
            }
        
        }
        
    }
    
    
    public static func postImage(image: UIImage, completion:@escaping (_ success: Bool,_ tipology: Int) -> Void){
        
        let jpgData = image.jpegData(compressionQuality: 0.6)
          let stream = InputStream(data: jpgData!)
        
        UserRoutes.requestPut(.put, endpoint: UserRoutes.baseURL+UserRoutes.uploadPhotoURL, parameters: stream ) { (json) in
            if (json == 200) {
                let imageSaveData = jpgData as NSData?
                let base64String = imageSaveData?.base64EncodedString()
                UserDefaultsManagers.setImage(image: base64String!)
                completion(true, 200)
            } else {
                completion(false,401)
            }
        }
    }
    
    public static func getImage(completion:@escaping (_ success: Bool,_ tipology: Any) -> Void){
        
        UserRoutes.requestPhoto(.get, endpoint: UserRoutes.baseURL+UserRoutes.getPhotoURL ) { (returnPhoto) in
          
            if(returnPhoto.response?.statusCode == 200){
                //returnPhoto.response?.headers["Etag"]?.description
                completion(true, returnPhoto.data)
            }else{
                completion(false, "")
            }
            
        }
        
    }
    
    public static func postQrcode(code: String, completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        
        let parameters = ["Code": code] as [String : String]
       
        
        UserRoutes.request(.post, endpoint: UserRoutes.baseURL+UserRoutes.qrcodeURL, parameters: parameters ) { (json) in
            if (json == 200) {
                completion(true, 200)
            } else {
                completion(false,401)
            }
        }
    }
    
    
    
    
    public static func getUser(completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        UserRoutes.request(.get, endpoint: UserRoutes.baseURL+UserRoutes.geuUserURL ) { (json) in
                if json != JSON.null {
                    guard json.dictionaryObject != nil else{
                        completion(false,JSON.null)
                        return
                    }
                    
                    getImage() {(success, response) in
                         if(success){
                            let image = UIImage(data: response as! Data)
                            let imageSaveData = image!.jpegData(compressionQuality: 0.6) as NSData?
                            let base64String = imageSaveData?.base64EncodedString()
                            
                            UserDefaultsManagers.setImage(image: base64String!)
                            if let jsonString = json.rawString() {
                                 UserDefaults.standard.setValue(jsonString, forKey: "User")
                              }
                            completion(true,json)
                            
                        }else{
                            if let jsonString = json.rawString() {
                                 UserDefaults.standard.setValue(jsonString, forKey: "User")
                              }
                            completion(true,json)
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
            UserNetwork.showActivityIndicator(show: true)
        } else if countLoader == 0 {
            UserNetwork.showActivityIndicator(show: false)
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
  

