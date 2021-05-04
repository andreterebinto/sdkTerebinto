//
//  LoginRoute.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum LoginRoutes {
    
    static let originalDNS = AppRoutes.originalDNS
    static let baseURL = "\(originalDNS)"
    static let headers = AppRoutes.headers
    static let saltURL = "auth/user/salt?email="
    static let loginURL = "auth/login"
    static let refreshURL = "auth/refresh"
    static let updateURL = "passenger/update"
    static let debugRequests = true
    
    
    
    
    static func request(_ method : HTTPMethod, endpoint : String,  completion : @escaping (_ data : JSON) -> Void) -> Void {
            AF.request(endpoint, method: method,encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
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
        
        AF.request(endpoint, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
}

