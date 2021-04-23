//
//  sdkTeste.swift
//  sdkTeste
//
//  Created by Andre Terebinto on 23/04/21.
//


import UIKit


public class sdkTeste: UIViewController {
    
    public func testeAlert(control: UIViewController){
       
         
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        control.present(alert, animated: true, completion: nil)
    }


}
