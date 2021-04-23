//
//  Request.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON


class requestServer {
    
    static let debugRequests = true
    
    static func request(_ method : HTTPMethod, endpoint : String, completion : @escaping (_ data : JSON) -> Void) -> Void {
        
        if(debugRequests) {
            print("[REQUEST] \(endpoint)")
        }
        
        AF.request(endpoint, method: method, headers: UserDefaultsManager().getHeader()).responseJSON { (response) in
            switch(response.result) {
            case .success:
                if let value = response.data{
                    let json = JSON(value)
                    completion(json)
                } else {
                    completion(JSON.null)
                }
                break
            case .failure(let error):
                
                let controller = UIApplication.shared.keyWindow?.rootViewController
                let alert = UIAlertController(title: Messages.appName.localizedString, message: Messages.badRequest.localizedString , preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    //UserDefaultsManager().resetDefaults()
                    //let welcomeVC = LoginVC.instantiateFrom(storyboard: .prelogin)
                    //AppDelegate.shared.makeRoot(viewController: welcomeVC, navigationBarHidden: true)
                    
                }))
                controller?.present(alert, animated: true, completion: nil)
                
                if(debugRequests) {
                    print("[NETWORK] \(method) Request to \(endpoint) failed! (Error: \(error))")
                    completion(JSON.null)
                }
                break
            }
        }
    }
    
    static func request(_ method : HTTPMethod, endpoint : String, parameters : [String : Any], completion : @escaping (_ data : JSON) -> Void) -> Void {
        
        if !NetworkReachabilityManager()!.isReachable {
           //WebService.shared.displayAlertWithSettings()
            return
        }
        
        AF.request(endpoint, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: UserDefaultsManager().getHeader()).validate().responseString { (response) in
        
            switch(response.result) {
            case .success(let json):
                
                let jsonRequest = JSON.init(parseJSON: JSON(json).stringValue)
                
                if(jsonRequest["code"] == "401"){
                    let controller = UIApplication.shared.keyWindow?.rootViewController
                    let alert = UIAlertController(title: Messages.appName.localizedString, message: jsonRequest["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                       // UserDefaultsManager().resetDefaults()
                        //let welcomeVC = LoginVC.instantiateFrom(storyboard: .prelogin)
                       // AppDelegate.shared.makeRoot(viewController: welcomeVC, navigationBarHidden: true)
                        
                    }))
                    controller?.present(alert, animated: true, completion: nil)
                }else{
                    completion(jsonRequest)
                }
                break
            case .failure(let json):
               
                if (response.response?.statusCode == nil){
                    //Indicator.shared.hide()
                }else if(response.response?.statusCode == 200){
                     //Indicator.shared.hide()
                     completion(JSON(json))
                
                }else{
                    let controller = UIApplication.shared.keyWindow?.rootViewController
                    let alert = UIAlertController(title: Messages.appName.localizedString, message: Messages.badRequest.localizedString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        //UserDefaultsManager().resetDefaults()
                       // let welcomeVC = LoginVC.instantiateFrom(storyboard: .prelogin)
                       // AppDelegate.shared.makeRoot(viewController: welcomeVC, navigationBarHidden: true)
                        
                    }))
                    controller?.present(alert, animated: true, completion: nil)
                }
                
                break
            }
        }
    }
    
    
    
    
    
}
