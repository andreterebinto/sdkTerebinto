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


public struct UserNetwork {
    
    private static var countLoader = 0 {
        didSet {
            UserNetwork.verifyActivityIndicator()
        }
    }
    
    
    public static func getUser(completion:@escaping (_ success: Bool,_ tipology: User) -> Void){
        
        UserRoutes.request(.get, endpoint: UserRoutes.baseURL+UserRoutes.geuUserURL ) { (json) in
                if json != JSON.null {
                    guard json.dictionaryObject != nil else{
                        completion(false,JSON.null)
                        return
                    }
                    
                    completion(true,User(json))
                    
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
        
    }
  




