//
//  KeyRoute.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum KeyRoutes {
    
    static let originalDNS = AppRoutes.originalDNS
    static let baseURL = "\(originalDNS)"
    static let headers = AppRoutes.headers
    static let greateKeyUrl = "key/create"
    static let getkeysUrl = "key/all"
    static let getKeyByIdURL = "key"
    static let deleteKeyURL = "key"
    static let encryptURL = "key/encrypt"
    static let decryptURL = "key/decrypt"
    static let debugRequests = true
    
    
    static func request(_ method : HTTPMethod, endpoint : String,  completion : @escaping (_ data : JSON) -> Void) -> Void {
            
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        
        AF.request(endpoint, method: method,encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
           
            switch(response.result) {
            case .success(let json):
                // TODO: - The line below is crashing. Check it.
                completion(JSON(json))
                break
            case .failure(let error):
                let uc = ("\(method)").uppercased()
                print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error: \(error))")
                
                break
            }
            
            
            
           
        }
    }
    
    static func request(_ method : HTTPMethod, endpoint : String, parameters : [String : Any], completion : @escaping (_ data : JSON) -> Void) -> Void {
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        AF.request(endpoint, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: headers).response { (response) in
            print(response.response?.statusCode)
            print(response)
            switch(response.result) {
            case .success(let json):
                // TODO: - The line below is crashing. Check it.
                completion(JSON(json))
                break
            case .failure(let error):
                let uc = ("\(method)").uppercased()
                print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error: \(error))")
                
                break
            }
        }
    }
    
    
    static func requestInt(_ method : HTTPMethod, endpoint : String, parameters : [String : Any], completion : @escaping (_ data : JSON) -> Void) -> Void {
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        
        AF.request(endpoint, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            print(response)
            print(response.response?.statusCode)
            print(response.response?.headers)
            if(response.response?.statusCode == 200){
                completion(200)
                
            }else{
                let uc = ("\(method)").uppercased()
                print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error:")
                completion(401)
              
                
            }
        }
    }
    
}

