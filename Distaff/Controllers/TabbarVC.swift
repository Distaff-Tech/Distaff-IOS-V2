//
//  TabbarVC.swift
//  Distaff
//
//  Created by netset on 20/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}
extension TabbarVC : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        
        if index ?? 0 > 1 && isGuestUser() {
            self.displayGuestUserAlert()
            return false
        }
        
        if index == 2 {
//            let canAddPost = (userdefaultsRef.value(Response.self, forKey: UserDefaultsKeys.userInfo))?.canAddPost ?? false
//            
//            if !canAddPost {
//                Alert.displayAlertOnWindowWithOkAndCancelAction(message:Messages.DialogMessages.completeProfile) {
//                    let tabbar = appDelegateRef.window?.rootViewController as? UITabBarController
//                    tabbar?.selectedIndex = 4
//                    return
//                }
//                
//            }
            
            
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.createPostPopup) as? CreatePostPopupVC
            targetVC?.modalPresentationStyle = .overCurrentContext
            self.present(targetVC ?? UIViewController(), animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
}

