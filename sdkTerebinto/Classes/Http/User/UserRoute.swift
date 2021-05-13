
import Foundation
import Alamofire
import SwiftyJSON

public enum UserRoutes {
    
    static let originalDNS = AppRoutes.originalDNS
    static let baseURL = "\(originalDNS)"
    static let headers = AppRoutes.headers
    static let geuUserURL = "user/info"
    static let loginURL = "auth/login"
    static let refreshURL = "auth/refresh"
    static let updateURL = "user/changeinfo"
    static let uploadPhotoURL = "user/photo/upload"
    static let getPhotoURL = "user/photo"
    static let qrcodeURL = "auth/external/authorize"
    static let changPassURL = "user/changepassword"
    static let debugRequests = true
    
    
    
    
    static func request(_ method : HTTPMethod, endpoint : String,  completion : @escaping (_ data : JSON) -> Void) -> Void {
        
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        
            AF.request(endpoint, method: method,encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            
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
    
    static func request(_ method : HTTPMethod, endpoint : String, parameters : [String : Any], completion : @escaping (_ data : Int) -> Void) -> Void {
        
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        
        AF.request(endpoint, method: method, parameters: parameters,encoding: JSONEncoding.prettyPrinted, headers: headers).responseString { (response) in
           
            print(response.response?.statusCode)
            if(response.response?.statusCode == 200){
                completion(200)
                
            }else{
                let uc = ("\(method)").uppercased()
                print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error:")
                completion(401)
              
                
            }
            
        }
    }
    
    
    static func requestPhoto(_ method : HTTPMethod, endpoint : String,  completion : @escaping (_ data : AFDataResponse<String>) -> Void) -> Void {
        
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        
            AF.request(endpoint, method: method,encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            
               
                
                if(response.response?.statusCode == 200){
                    completion(response)
                    
                }else{
                    let uc = ("\(method)").uppercased()
                    print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error:")
                    completion(response)
                  
                    
                }
        }
    }
    
    
    static func requestPut(_ method : HTTPMethod, endpoint : String, parameters : InputStream, completion : @escaping (_ data : Int) -> Void) -> Void {
        
        
        let headers = [
                "Authorization": "Bearer "+UserDefaultsManagers.getToken(),
                "Content-Type": "application/json"
            ] as HTTPHeaders
        AF.upload(parameters, to: endpoint, method: .put, headers: headers, interceptor: .none, fileManager: FileManager.default, requestModifier: .none).response { (response) in
         
            
            if(response.response?.statusCode == 200){
                completion(200)
                
            }else{
                let uc = ("\(method)").uppercased()
                print("[NETWORK] \(uc) Request to \(endpoint) failed! (Error:")
                
              
                
            }
        }
       
    }
    
}

