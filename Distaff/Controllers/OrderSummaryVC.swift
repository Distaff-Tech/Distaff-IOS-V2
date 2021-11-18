//
//  OrderSummaryVC.swift
//  Distaff
//
//  Created by Aman on 26/03/20.
//  Copyright © 2020 netset. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class OrderSummaryVC: BaseClass {
    
    //MARK: OUTLET(S)
    @IBOutlet weak var lblPostDescription: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblAddressUserName: UILabel!
    @IBOutlet weak var lblAddres: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet var lblSubTotal: UILabel!
    @IBOutlet var lblServiceChargeTitle: UILabel!
    @IBOutlet var lblServiceCharge: UILabel!
    @IBOutlet weak var stackViewPrintSize: UIStackView!
    @IBOutlet weak var lblFrontViewSize: UILabel!
    @IBOutlet weak var lblBackViewSize: UILabel!
    @IBOutlet weak var lblShippingCost: UILabel!
    
    
    var orderSummaryData:OrderDetailData?
    
    //MARK: LIFE CYCLE(S)
    override func viewDidLoad() {
        super.viewDidLoad()
        displayOrderSummaryData()
    }
    
}

//MARK: ALL METHOD(S)
extension OrderSummaryVC {
    func displayOrderSummaryData() {
        orderImageView.setSdWebImage(url: orderSummaryData?.post_images?[0] ?? "")
        lblUserFullName.text = "Design by \(orderSummaryData?.design_by ?? "")"
        lblPostDescription.text = orderSummaryData?.post_description ?? ""
        lblShippingCost.text = "\("$")\(orderSummaryData?.shippingCost ?? 0.00)"
        lblPrice.text = "\("$")\(orderSummaryData?.price ?? "")"
        lblSize.text =  "\("Size: ")\(orderSummaryData?.size_name ?? "")"
        lblColor.text = "\("Color: ")\(orderSummaryData?.colour_name ?? "")"
        if orderSummaryData?.address?.count ?? 0 > 0 {
            let object =  orderSummaryData?.address?[0]
            lblAddres.text = "\(object?.address ?? "")\(", \(object?.city ?? "")")\(", \(object?.postal_code ?? "")")"
            lblAddressUserName.text = "\(object?.first_name ?? "")\("")\(object?.last_name ?? "")"
            lblMobile.text = object?.phone ?? ""
        }
        lblSubTotal.text =  lblPrice.text
        let price = Double(orderSummaryData?.price ?? "0.00") ?? 0.00
        let servicePrice = ((price * (orderSummaryData?.serviceCharge ?? 0.0) ) / 100).truncate(places: 2)
        let totalPrice = (price + servicePrice + (orderSummaryData?.shippingCost ?? 0.00)).calculateCurrency(fractionDigits: 2)
        lblTotal.text = "$\(totalPrice)"
        lblServiceCharge.text = "$\(servicePrice)"
        lblServiceChargeTitle.text = "Taxes"
        stackViewPrintSize.isHidden = orderSummaryData?.post_printing_size_front ?? "" == ""  
        lblFrontViewSize.text = "Front Size: \(orderSummaryData?.post_printing_size_front ?? "")"
        lblBackViewSize.text = "Back Size: \(orderSummaryData?.post_printing_size_back ?? "")"
        
    }
    
}

//MARK: ALL ACTION(S)
extension OrderSummaryVC {
    @IBAction func didTappedback(_ sender: UIButton) {
        PopViewController()
        
    }
    @IBAction func didTappedPostImage(_ sender: UIButton) {
        
        var images = [SKPhotoProtocol]()
        for i in 0 ..< (orderSummaryData?.post_images?.count ?? 0) {
            let image = orderSummaryData?.post_images?[i] ?? ""
            let photo = SKPhoto.photoWithImageURL("\(WebServicesApi.imageBaseUrl)\(image)")
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
        }
        
        self.displayZoomImages(imageArray: images, index: 0)
        
    }
    
}
