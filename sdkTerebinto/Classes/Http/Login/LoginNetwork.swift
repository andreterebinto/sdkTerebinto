//
//  LoginNetwork.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct RegisterNetwork {
    
    private static var countLoader = 0 {
        didSet {
            RegisterNetwork.verifyActivityIndicator()
        }
    }
    
    static func registration(parameters: [String: Any], completion:@escaping (_ success: Bool,_ tipology: JSON) -> Void){
        
        LoginRoutes.request(.post, endpoint: LoginRoutes.baseURL+LoginRoutes.registrationURL, parameters: parameters ) { (json) in
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
    
}


