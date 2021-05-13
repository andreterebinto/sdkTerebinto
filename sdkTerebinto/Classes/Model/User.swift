//
//  User.swift
//  Pods-sdkTerebinto_Tests
//
//  Created by Andre Terebinto on 05/05/21.
//

import Foundation
import UIKit
import SwiftyJSON




public struct User: Codable{
   public var Name : String
   public var Email : String
   public var PhoneNumber : String
   public var DepartmentName : String
   public var OrganizationName : String
    
    public init?(json: JSON) {
        self.Name = json["Name"].description
        self.Email = json["Email"].description
        self.PhoneNumber = json["DepartmentName"].description
        self.DepartmentName = json["OrganizationName"].description
        self.OrganizationName = json["OrganizationName"].description
           
    }
  
}
