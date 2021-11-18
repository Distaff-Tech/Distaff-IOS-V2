//
//  CustomDesignVM.swift
//  Distaff
//
//  Created by Aman on 13/04/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit

class CustomDesignVM {
    var productSelctedIndex = -1    // selected Producr index
    var productData:CustomModuleData?
    var selectedFilterOption = -1    // selected bottom filtes
    var cutFilterCurrentIndex = 1    // 4th filter index
    var frontViewSelectedSizeIndex = 0  // s,m,l
    var backViewSelectedSizeIndex = 0  // s,m,l
    var frontViewRecentShape = RecentShapeData()
    var backViewRecentShape = RecentShapeData()
    
    
    func callProductListsApi(shouldAnimate:Bool,completion:@escaping() -> Void) {
        Services.getRequest(url: WebServicesApi.getCustomList, shouldAnimateHudd: shouldAnimate) { (responseData) in
            do {
                self.productData = try JSONDecoder().decode(CustomModuleData.self, from: responseData)
                
                completion()
            }
            catch {
                Alert.displayAlertOnWindow(with: error.localizedDescription)
            }
        }
        
    }
    
    
}
