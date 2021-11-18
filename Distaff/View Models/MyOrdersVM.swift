//
//  MyOrdersVM.swift
//  Distaff
//
//  Created by netset on 20/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit

class MyOrdersVM {
    
    
    var myRequestPageNumber = 1
    var myOrdersPageNumber = 1
    var doesNxtPageExistMyRequest = false
    var doesNxtPageExistMyOrders = false
    
    var myRequestArray = [MyrequestListData?]()
    var myOrdersArray = [MyrequestListData?]()
    
    var isNeedToHitMyOrder = true
    var isNeedToHitMyRequest = true
    
    
    func callMyrequestListsApi(refreshControl:UIRefreshControl? = nil,shouldAnimate:Bool,_completion:@escaping() -> Void) {
        let url = "\(WebServicesApi.my_request)page_num=\(myRequestPageNumber)"
        var localTimeZoneName: String { return TimeZone.current.identifier }
        Services.postRequest(url: url, param: [My_Requests.timeZone:localTimeZoneName], shouldAnimateHudd: shouldAnimate,refreshControl:refreshControl) { (responseData) in
            do {
                let data = try JSONDecoder().decode(MyRequestModel.self, from: responseData)
                self.isNeedToHitMyRequest = false
                if self.myRequestPageNumber == 1 {
                    self.myRequestArray = data.response ?? []
                }
                else {
                    let dataObject = data.response ?? []
                    for i in 0..<dataObject.count {
                        if  self.myRequestArray.last??.date == dataObject[0].date && i == 0 {
                            let listToAppend = dataObject[0].list ?? []
                            for j in 0..<listToAppend.count  {
                                let newObject = listToAppend[j]
                                self.myRequestArray[self.myRequestArray.count - 1]?.list?.append(newObject)
                            }
                        }
                            
                        else {
                            let newObject = dataObject[i]
                            self.myRequestArray.append(newObject)
                        }
                        
                    }
                    
                }
                
                
                
                self.doesNxtPageExistMyRequest = data.has_next ?? false
                _completion()
            }
            catch {
                Alert.displayAlertOnWindow(with: error.localizedDescription)
            }
        }
        
    }
    
    
    func callMyOrderstListsApi(refreshControl:UIRefreshControl? = nil,shouldAnimate:Bool,_completion:@escaping() -> Void) {
        let url = "\(WebServicesApi.past_orders)page_num=\(myOrdersPageNumber)"
        var localTimeZoneName: String { return TimeZone.current.identifier }
        Services.postRequest(url: url, param: [My_Requests.timeZone:localTimeZoneName], shouldAnimateHudd: shouldAnimate,refreshControl:refreshControl) { (responseData) in
            do {
                let data = try JSONDecoder().decode(MyRequestModel.self, from: responseData)
                self.isNeedToHitMyOrder = false
                if self.myOrdersPageNumber == 1 {
                    self.myOrdersArray = data.response ?? []
                }
                else {
                    let dataObject = data.response ?? []
                    for i in 0..<dataObject.count {
                        if  self.myOrdersArray.last??.date == dataObject[0].date && i == 0 {
                            let listToAppend = dataObject[0].list ?? []
                            for j in 0..<listToAppend.count  {
                                let newObject = listToAppend[j]
                                self.myOrdersArray[self.myOrdersArray.count - 1]?.list?.append(newObject)
                            }
                        }
                            
                        else {
                            let newObject = dataObject[i]
                            self.myOrdersArray.append(newObject)
                        }
                        
                    }
                }
                
                self.doesNxtPageExistMyOrders = data.has_next ?? false
                _completion()
            }
            catch {
                Alert.displayAlertOnWindow(with: error.localizedDescription)
            }
        }
        
        
    }
    
    
    func callDeleteOrderApi(request:DeleteOrder.Request,completion:@escaping(_ data:MyRequestModel?) -> Void) {
        Services.postRequest(url: WebServicesApi.order_delete, param: [Delete_Order.order_id : request.orderId ?? 0,Delete_Order.timeZone : request.timeZone ?? "",Delete_Order.type : request.type ?? "",Delete_Order.page_num : request.pageNo ?? 1], shouldAnimateHudd: true) { (responseData) in
               do {
                   let data = try JSONDecoder().decode(MyRequestModel.self, from: responseData)
                   completion(data)
               }
               catch {
                   Alert.displayAlertOnWindow(with: error.localizedDescription)
               }
           }
           
       }
    
}

