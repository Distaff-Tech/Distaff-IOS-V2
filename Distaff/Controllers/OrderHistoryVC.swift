//
//  OrderHistoryVC.swift
//  Distaff
//
//  Created by netset on 20/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import UIKit

class OrderHistoryVC: BaseClass {
    //MARK:OUTLET(S)
    @IBOutlet weak var scrollableViewLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var btnMyRequest: UIButton!
    @IBOutlet weak var btnPastoOders: UIButton!
    @IBOutlet weak var tblViewOrders: UITableView!
    
    
    //MARK:VARIABLE(S)
    var objMyOrderVM = MyOrdersVM()
    var isFromShoppingFlow = false
    
    //MARK:LIFE CYCLE(S)
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAllObserversAdded()
    }
    
    
    override func refreshData() {
        if btnMyRequest.alpha == 1.0 {
            objMyOrderVM.myRequestPageNumber = 1
            getMyRequestList(refreshControl: refreshControl, shouldAnimate: false)
        }
        else {
            objMyOrderVM.myOrdersPageNumber = 1
            getMyOrdersList(refreshControl: refreshControl, shouldAnimate: false)
        }
    }
    
    
}

//MARK:ALL METHOD(S)
extension OrderHistoryVC {
    func prepareUI() {
        showNavigationBar()
        handleTabbarVisibility(shouldHide: true)
        tblViewOrders.removeExtraSeprators()
        addRefreshControlInTable(tableView: tblViewOrders)
        // add observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.refreshList),
            name:NSNotification.Name(rawValue: NotificationObservers.refreshOrderDetail),
            object: nil)
        
        if isFromShoppingFlow {
            self.scrollableViewLeadingAnchor.constant = self.btnPastoOders.frame.origin.x
            self.btnMyRequest.alpha = 0.4
            self.btnPastoOders.alpha = 1.0
            self.view.layoutIfNeeded()
            tblViewOrders.reloadData()
            getMyOrdersList(shouldAnimate: true)
            
        }
        else  {
            getMyRequestList(shouldAnimate: true)
        }
        
    }
    
    @objc  func refreshList(notification: NSNotification){
        let userInfo  = notification.userInfo
        if userInfo?["tag"] as? String ?? "" == PushNotificationsType.OrderPlace {
            objMyOrderVM.myRequestPageNumber = 1
            objMyOrderVM.callMyrequestListsApi(shouldAnimate: false) {
                if self.btnMyRequest.alpha == 1.0 {
                    self.tblViewOrders.reloadData()
                    self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyRequest, arrayCount: self.objMyOrderVM.myRequestArray.count)
                }
            }
            
        }
        // worked on decline nitification
        //        else if userInfo?["tag"] as? String ?? "" == PushNotificationsType.orderAccept {
        //            objMyOrderVM.myOrdersPageNumber = 1
        //            objMyOrderVM.callMyOrderstListsApi( shouldAnimate: false) {
        //                if self.btnPastoOders.alpha == 1.0 {
        //                self.tblViewOrders.reloadData()
        //                self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyOrder, arrayCount: self.objMyOrderVM.myOrdersArray.count)
        //            }
        //            }
        //
        //
        //        }
        
    }
    
    func appendNextItemOnDeletion(data:MyRequestModel?,isMyRequest:Bool) {
        if data?.response?.count ?? 0 > 0 {
            DispatchQueue.main.async {
                let lastObjectDate = isMyRequest ? (self.objMyOrderVM.myRequestArray[self.objMyOrderVM.myRequestArray.count - 1]?.date ?? "") : (self.objMyOrderVM.myOrdersArray[self.objMyOrderVM.myOrdersArray.count - 1]?.date ?? "")
                isMyRequest ? (self.objMyOrderVM.doesNxtPageExistMyRequest = data?.has_next ?? false ) : (self.objMyOrderVM.doesNxtPageExistMyOrders = data?.has_next ?? false )
                
                if lastObjectDate == data?.response?[0].date {
                    isMyRequest ? (self.objMyOrderVM.myRequestArray[self.objMyOrderVM.myRequestArray.count - 1]?.list?.append((data?.response?[0].list![0])!)) :  (self.objMyOrderVM.myOrdersArray[self.objMyOrderVM.myOrdersArray.count - 1]?.list?.append((data?.response?[0].list?[0])!))
                }
                else {
                    isMyRequest ?  (self.objMyOrderVM.myRequestArray.append(contentsOf: (data?.response ?? []))) : (self.objMyOrderVM.myOrdersArray.append(contentsOf: (data?.response ?? [])))
                }
                self.tblViewOrders.reloadData()
            }
        }
        
        
    }
    
    
    func getMyRequestList(refreshControl:UIRefreshControl? = nil,shouldAnimate:Bool) {
        objMyOrderVM.callMyrequestListsApi(refreshControl: refreshControl, shouldAnimate: shouldAnimate) {
            self.tblViewOrders.reloadData()
            self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyRequest, arrayCount: self.objMyOrderVM.myRequestArray.count)
        }
    }
    
    func getMyOrdersList(refreshControl:UIRefreshControl? = nil,shouldAnimate:Bool) {
        objMyOrderVM.callMyOrderstListsApi(refreshControl: refreshControl, shouldAnimate: shouldAnimate) {
            self.tblViewOrders.reloadData()
            self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyOrder, arrayCount: self.objMyOrderVM.myOrdersArray.count)
        }
        
    }
    
}
//MARK:ALL ACTION(S)
extension OrderHistoryVC {
    @IBAction func didTappedBack(_ sender: UIButton) {
        
        if isFromShoppingFlow {
            Variables.shared.shouldLoadProfileData = true
        }
        PopViewController()
        handleTabbarVisibility(shouldHide: false)
    }
    
    @IBAction func didTappedMyRequest(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.scrollableViewLeadingAnchor.constant = 0.0
            self.btnMyRequest.alpha = 1.0
            self.btnPastoOders.alpha = 0.4
            self.view.layoutIfNeeded()
        }
        
        if objMyOrderVM.isNeedToHitMyRequest {
            objMyOrderVM.myRequestPageNumber = 1
            getMyRequestList(shouldAnimate: true)
        }
        else {
            tblViewOrders.reloadData()
            self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyRequest, arrayCount: self.objMyOrderVM.myRequestArray.count)
        }
        
    }
    
    @IBAction func didTappedPastOrders(_ sender: UIButton) {
        self.btnMyRequest.alpha = 0.4
        self.btnPastoOders.alpha = 1.0
        UIView.animate(withDuration: 0.3) {
            self.scrollableViewLeadingAnchor.constant = self.btnPastoOders.frame.origin.x
            self.view.layoutIfNeeded()
        }
        if objMyOrderVM.isNeedToHitMyOrder {
            objMyOrderVM.myOrdersPageNumber = 1
            getMyOrdersList( shouldAnimate: true)
        }
        else {
            tblViewOrders.reloadData()
            self.tblViewOrders.showNoDataLabel(message: Messages.NoDataMessage.noMyOrder, arrayCount: self.objMyOrderVM.myOrdersArray.count)
        }
    }
    
}
