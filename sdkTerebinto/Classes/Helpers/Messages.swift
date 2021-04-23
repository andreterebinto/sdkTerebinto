//
//  Messages.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//

import Foundation
enum Messages: String {
    
    case appName
    case badRequest
    
   
    var localizedString: String {
        let path = AppDelegate.shared.pathForLocalizationFile()
        let languageBundle: Bundle = Bundle(path: path)!
        let str: String = languageBundle.localizedString(forKey: self.rawValue, value: "", table: nil)
        return str
    }
}
