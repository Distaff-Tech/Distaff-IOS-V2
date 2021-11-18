//
//  AlertManager.swift
//  Distaff
//
//  Created by netset on 10/01/20.
//  Copyright © 2020 netset. All rights reserved.
//


import Foundation
import UIKit

class Alert: NSObject {
    class func displayAlertOnWindow(with message:String) {
        let alert = UIAlertController(title:AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
  class  func alertForAppleIdExist() {
            let alert = UIAlertController(
                title: "Failed to login with Apple Credentials",
                message: "It seems you had previous associated with your AppleID with Distaff. Please go to [Settings -> AppleID -> Password & Security -> AppleID logins] and remove Distaff.",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.view.tintColor = AppColors.appColorBlue
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Open settings", style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
    
    class  func displayAlertOnWindowWithOkAction(message:String,onComplete:@escaping (()->())) {
        let alert = UIAlertController(title: AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            onComplete()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    class  func displayAlertOnWindowWithOkAndCancelAction(message:String,onComplete:@escaping (()->())) {
        let alert = UIAlertController(title: AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            onComplete()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                   onComplete()
               }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}



