//
//  AppDelegate.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared = UIApplication.shared.delegate as! AppDelegate
    public func pathForLocalizationFile() -> String {
        var path = String()
        if let language = UserDefaults.standard.object(forKey: "Language") {
          if  language as! String == "en"  {
               path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            } else if language as! String == "pt-BR" {
                path = Bundle.main.path(forResource: "pt-BR", ofType: "lproj")!
            }
        } else {
            path = Bundle.main.path(forResource: "pt-BR", ofType: "lproj")!
        }
       

        return path
    }


}
