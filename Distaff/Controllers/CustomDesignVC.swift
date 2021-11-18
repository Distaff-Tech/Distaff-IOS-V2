//
//  CustomDesignVC.swift
//  Distaff
//
//  Created by Aman on 09/04/20.
//  Copyright © 2020 netset. All rights reserved.
//

import UIKit
import ScalingCarousel
import Photos
import EasyTipView


class CustomDesignVC: BaseClass {
    
    //MARK: OUTLET(S)
    @IBOutlet weak var collectionViewProductList: ScalingCarouselView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnSaveToGallary: UIButton!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var stackViewStepInfo: UIStackView!
    @IBOutlet weak var lblCurrentStep: UILabel!
    @IBOutlet weak var lblFilterName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNextFilter: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet weak var txtFldDropDown: DropDown!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var optionViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var shapeSlider: UISlider!
    @IBOutlet weak var lblSelectedShape: UILabel!
    @IBOutlet weak var stackViewSwitch: UIStackView!
    @IBOutlet weak var btnSwitchFront: UIButton!
    @IBOutlet weak var btnSwitchBack: UIButton!
    
    //MARK: CONSTANT(S):
    var objectToDelete:UIView?
    var objVMCustomDesign = CustomDesignVM()
    weak var tipView: EasyTipView?
    var beginX : CGFloat = 0.0
    var beginY : CGFloat = 0.0
    
    
    //MARK:LIFE CYCLE(S)
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
    }
    
    //MARK:OVERRIDE METHOD(S)
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        resetColors()
        nextButtonUIHandling(shouldEnabled: true)
        objVMCustomDesign.selectedFilterOption = -1
        addStickerImageInView(selectedImage:info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? UIImage())
    }
    
    override  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        resetColors()
        objVMCustomDesign.selectedFilterOption = -1
    }
    
    @IBAction func didTappedSwitchButtons(_ sender: UIButton) {
        if !sender.isSelected {
        btnSwitchBack.isSelected = sender.tag == 1 ? false : true
         btnSwitchFront.isSelected = sender.tag == 1 ? true : false
        }
        
        txtFldDropDown.hideList()
        self.dismissOptionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.handleFrontBackClothViewsVisibility(shouldVisibleFront: self.btnSwitchFront.isSelected)
            self.txtFldDropDown.text = !self.btnSwitchFront.isSelected  ? self.txtFldDropDown.optionArray[self.objVMCustomDesign.backViewSelectedSizeIndex] :  self.txtFldDropDown.optionArray[self.objVMCustomDesign.frontViewSelectedSizeIndex]
            self.txtFldDropDown.selectedIndex = !self.btnSwitchFront.isSelected ? self.objVMCustomDesign.backViewSelectedSizeIndex : self.objVMCustomDesign.frontViewSelectedSizeIndex
            self.dismissCutFliterUI()
        }

        
        
        
        
        
    }
    
}

//MARK: ALL METHOD(S)
extension CustomDesignVC {
    func prepareUI() {

        handleTabbarVisibility(shouldHide: true)
        setupSizeDropDown()
        getAllProducts()
    }
    func setupSizeDropDown() {
        txtFldDropDown.isHidden = true
        txtFldDropDown.optionArray = ["Small (4″)", "Medium (7″)", "Large (10″)"]
        txtFldDropDown.selectedIndex = 0
        txtFldDropDown.didSelect{(selectedText , index ,id) in
            // for same item selction
            if !self.frontView.isHidden && index == self.objVMCustomDesign.frontViewSelectedSizeIndex ||  !self.backView.isHidden && index == self.objVMCustomDesign.backViewSelectedSizeIndex {
                return
            }
            
            self.showAlertWithCancelAndOkAction(message: "This will reset the data for \(self.btnSwitchFront.isSelected  ? "Front" : "Back") side of the T shirt. So are your sure?", onComplete: {
                self.txtFldDropDown.text = selectedText
                self.dismissOptionView()
                self.frontView.isHidden == true ? (self.objVMCustomDesign.backViewSelectedSizeIndex = index) : (self.objVMCustomDesign.frontViewSelectedSizeIndex = index)
                
                DispatchQueue.main.async {
                    self.clearProtectiveAreaInnerData(view:  self.btnSwitchFront.isSelected  ? self.frontView : self.backView ?? UIView())
                    
                    self.addSizeViewOnClothView(productImage:self.btnSwitchFront.isSelected  ? self.frontImage : self.backImage,clothSize: index == 0 ? .small : index == 1 ? .medium : .large)
                    self.nextButtonUIHandling(shouldEnabled: self.getTotalObjectsAddedCount() > 0)
                }
                if !self.bottomCollectionView.isHidden {
                    self.dismissCutFliterUI()
                    self.removeRecentShapedRelatedData(isForFrontView: self.btnSwitchFront.isSelected)
                }
                
                
            }) {
                
                self.txtFldDropDown.selectedIndex = self.txtFldDropDown.optionArray.firstIndex(of: self.txtFldDropDown.text ?? "")
                
            }
            
            
        }
    }
    
    
    func clearProtectiveAreaInnerData(view:UIView) {
        guard  let protectiveGestureView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: view ) else { return }
        
        guard  let availableArea = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: protectiveGestureView ) else { return }
        
        guard  let outerArea = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.outerArea, view: protectiveGestureView ) else { return }
        
        guard  let leftArmArea = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.leftArm, view: protectiveGestureView ) else { return }
        
        guard  let rightArmArea = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.rightArm, view: protectiveGestureView ) else { return }
        availableArea.removeFromSuperview()
        outerArea.subviews.forEach { $0.removeFromSuperview() }
        leftArmArea.subviews.forEach { $0.removeFromSuperview() }
        rightArmArea.subviews.forEach { $0.removeFromSuperview() }
    }
    
    
    func getAllProducts() {
        objVMCustomDesign.callProductListsApi(shouldAnimate: true) {
            self.collectionViewProductList.reloadData()
            // scroll to 2nd index
            if self.objVMCustomDesign.productData?.clothstyle?.count ?? 0 > 2 {
                let indexParh = NSIndexPath(item: 1, section: 0)
                self.collectionViewProductList.scrollToItem(at: indexParh as IndexPath, at: .centeredHorizontally, animated: false)
            }
        }
        
    }
    func unSelectedAllArrays() {
        objVMCustomDesign.productData?.shapesArray?.mutateEach({($0.isSelected = false)})
        objVMCustomDesign.productData?.shapeBorderColorArray?.mutateEach({($0.isSelected = false)})
        objVMCustomDesign.productData?.shapeFillColorArray?.mutateEach({($0.isSelected = false)})
    }
    
    func handleCutFilterStepsUI() {
        btnBack.isHidden  = objVMCustomDesign.cutFilterCurrentIndex == 1 ? true : false
        btnNextFilter.setTitle(objVMCustomDesign.cutFilterCurrentIndex == 3 ? "DONE" : "NEXT", for: .normal)
        lblFilterName.text = objVMCustomDesign.cutFilterCurrentIndex == 1 ? "CHOOSE SHAPE" : objVMCustomDesign.cutFilterCurrentIndex == 2 ?  "CHOOSE BORDER COLOR" : "CHOOSE FILL COLOR"
        lblCurrentStep.text = objVMCustomDesign.cutFilterCurrentIndex == 1 ? "STEP 1 OUT OF 3" : objVMCustomDesign.cutFilterCurrentIndex == 2 ? "STEP 2 OUT OF 3" : "STEP 3 OUT OF 3"
        
    }
    func cutFilterValidations() {
        if objVMCustomDesign.cutFilterCurrentIndex == 1 {
            let isShapeSelected =  objVMCustomDesign.productData?.shapesArray?.contains(where: {($0.isSelected ?? true)}) ?? false
            if !isShapeSelected {
                self.view.showToast(Messages.Validation.chooseShape, position: .bottom, popTime: 1.5, dismissOnTap: true)
                return
            }
        }
            
        else if objVMCustomDesign.cutFilterCurrentIndex == 2 {
            let isShapeColorSelected =  objVMCustomDesign.productData?.shapeBorderColorArray?.contains(where: {($0.isSelected ?? true)}) ?? false
            if !isShapeColorSelected {
                self.view.showToast(Messages.Validation.chooseShapeBorderColor, position: .bottom, popTime: 1.5, dismissOnTap: true)
                return
            }
        }
            
        else if objVMCustomDesign.cutFilterCurrentIndex == 3 {
            let isShapeFillColorSelected =  objVMCustomDesign.productData?.shapeFillColorArray?.contains(where: {($0.isSelected ?? true)}) ?? false
            if !isShapeFillColorSelected {
                self.view.showToast(Messages.Validation.chooseShapeFillColor, position: .bottom, popTime: 1.5, dismissOnTap: true)
                return
            }
            else {
                bottomCollectionView.isHidden = true
                stackViewStepInfo.isHidden = true
                btnBack.isHidden =  true
                btnNextFilter.isHidden =  true
                self.resetColors()
                self.objVMCustomDesign.selectedFilterOption = -1
                self.objVMCustomDesign.cutFilterCurrentIndex = 1
                removeRecentShapedRelatedData(isForFrontView: self.btnSwitchFront.isSelected )
                unSelectedAllArrays()
                return
            }
            
        }
        
        objVMCustomDesign.cutFilterCurrentIndex =   objVMCustomDesign.cutFilterCurrentIndex + 1
        bottomCollectionView.reloadData()
        scrollCollectionToSelctedItems(cutFilterOptionIndex:  objVMCustomDesign.cutFilterCurrentIndex)
        handleCutFilterStepsUI()
    }
    
    func scrollCollectionToSelctedItems(cutFilterOptionIndex:Int) {
        let row =  cutFilterOptionIndex == 1 ? objVMCustomDesign.productData?.shapesArray?.firstIndex(where: {$0.isSelected == true}) ?? -1 : cutFilterOptionIndex == 2 ? objVMCustomDesign.productData?.shapeBorderColorArray?.firstIndex(where: {$0.isSelected == true}) ?? -1  :  objVMCustomDesign.productData?.shapeFillColorArray?.firstIndex(where: {$0.isSelected == true}) ?? -1
        if row != -1 {
            bottomCollectionView.scrollToItem(at: IndexPath.init(row: row, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    
    //MARK: WHOLE POST PRICE
    func calculateWholePostPrice() -> Double {
        let tShirtBaicPrice = (objVMCustomDesign.productData?.clothstyle?[objVMCustomDesign.productSelctedIndex].price ?? 0.0)
        
        let tShirtFrontSizePrice = isAnyObjectAdded(onView: frontView) ?  (objVMCustomDesign.productData?.sizePriceList?[objVMCustomDesign.frontViewSelectedSizeIndex].price ?? 0.0) : 0.0
        
        let tShirtBackSizePrice =  isAnyObjectAdded(onView: backView) ?  (objVMCustomDesign.productData?.sizePriceList?[objVMCustomDesign.backViewSelectedSizeIndex].price ?? 0.0) : 0.0
        
        return tShirtBaicPrice + tShirtFrontSizePrice + tShirtBackSizePrice + calculateAvailableViewShapePrice(view: frontView) + calculateAvailableViewShapePrice(view: backView) + calculateOuterViewShapePrice(view: frontView) + calculateOuterViewShapePrice(view: backView) + calculateArmsPrice(view: frontView) + calculateArmsPrice(view: backView)
    }
    
    func calculateAvailableViewShapePrice(view:UIView) ->(Double) {
        let noOfShapesArray = [3.50,6.00,9.00,11.00,13.00,15.00,16.50,18.00,19.00,20.00]
        var availableViewShapesPrice = 0.0
        guard  let protectiveAreaView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: view ) else { return (0.0) }
        
        guard  let availableView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: protectiveAreaView ) else { return (0.0) }
        
        if availableView.subviews.count > 0 {
            if  availableView.subviews.count < noOfShapesArray.count {
                availableViewShapesPrice += noOfShapesArray[availableView.subviews.count - 1]
            }
            else {
                let upCount = Double(( availableView.subviews.count) - (noOfShapesArray.count))
                availableViewShapesPrice += (noOfShapesArray.last ?? 0.0) + ( (0.75) * upCount)
            }
        }
        
        for i in 0 ..< availableView.subviews.count {
            
            let shape = availableView.subviews[i]
            
            if shape.restorationIdentifier == RestorationIdentifer.shapeView && shape.accessibilityIdentifier == AccesibilityIdentifer.extraPriceShape {
                availableViewShapesPrice += 0.50
                
            }
        }
        return availableViewShapesPrice
    }
    
    
    func calculateOuterViewShapePrice(view:UIView) ->(Double) {
        let noOfShapesArray = [5.50,9.50,13.50,16.00,18.00,20.00,21.50,23.00,24.00,25.00]
        var outerViewShapesPrice = 0.0
        guard  let protectiveAreaView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: view ) else { return (0.0) }
        
        guard  let outerView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.outerArea, view: protectiveAreaView ) else { return (0.0) }
        
        
        if outerView.subviews.count > 0 {
            if  outerView.subviews.count < noOfShapesArray.count {
                outerViewShapesPrice += noOfShapesArray[outerView.subviews.count - 1]
            }
            else {
                let upCount = Double(( outerView.subviews.count) - (noOfShapesArray.count))
                outerViewShapesPrice += (noOfShapesArray.last ?? 0.0) + ( (0.75) * upCount)
            }
        }
        
        for i in  0 ..< outerView.subviews.count {
            let shape = outerView.subviews[i]
            if shape.restorationIdentifier == RestorationIdentifer.shapeView  && shape.accessibilityIdentifier == AccesibilityIdentifer.extraPriceShape {
                outerViewShapesPrice += 0.50
            }
        }
        print(outerViewShapesPrice)
        return outerViewShapesPrice
    }
    
    
    func calculateArmsPrice(view:UIView) ->(Double) {
        let shapesPriceArray = [6.50,12.50,18.00,22.00,25.00]
        var totalPrice = 0.0
        guard  let protectiveAreaView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: view ) else { return (0.0) }
        
        guard  let leftArmView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.leftArm, view: protectiveAreaView ) else { return (0.0) }
        
        guard  let rightArmView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.rightArm, view: protectiveAreaView ) else { return (0.0) }
        
        let totatShapesCount = leftArmView.subviews.count + rightArmView.subviews.count
        
        for i in  0 ..< leftArmView.subviews.count {
            let shape = leftArmView.subviews[i]
            if shape.restorationIdentifier == RestorationIdentifer.shapeView  && shape.accessibilityIdentifier == AccesibilityIdentifer.extraPriceShape {
                totalPrice += 0.50
            }
            
        }
        
        for i in 0 ..< rightArmView.subviews.count {
            let shape = rightArmView.subviews[i]
            if shape.restorationIdentifier == RestorationIdentifer.shapeView && shape.accessibilityIdentifier == AccesibilityIdentifer.extraPriceShape {
                totalPrice += 0.50
            }
        }
        
        // calculate no price
        if totatShapesCount > 0 {
            if  totatShapesCount < shapesPriceArray.count {
                totalPrice += shapesPriceArray[totatShapesCount - 1]
            }
            else {
                let upCount = Double((totatShapesCount) - (shapesPriceArray.count))
                totalPrice += (shapesPriceArray.last ?? 0.0) + ( (1.50) * upCount)
            }
        }
        print(totalPrice )
        return totalPrice
    }
    
    
    func isAnyObjectAdded(onView:UIView) -> Bool {
        guard  let protectiveAreaView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: onView ) else { return false }
        
        guard  let availableView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: protectiveAreaView ) else { return false }
        
        if availableView.subviews.count > 0  {
            return true
        }
        else {
            return false
        }
    }
    
    func nextButtonUIHandling(shouldEnabled:Bool) {
        btnNext.isUserInteractionEnabled = shouldEnabled
        btnNext.alpha = shouldEnabled ? 1.0 : 0.4
    }
    
    func dismissCutFliterUI() {
        bottomCollectionView.isHidden = true
        stackViewStepInfo.isHidden = true
        btnBack.isHidden =  true
        btnNextFilter.isHidden =  true
        self.resetColors()
        self.objVMCustomDesign.selectedFilterOption = -1
        self.objVMCustomDesign.cutFilterCurrentIndex = 1
        unSelectedAllArrays()
    }
    
    func removeRecentShapedRelatedData(isForFrontView:Bool) {
        if isForFrontView {
            objVMCustomDesign.frontViewRecentShape.selectedShapeIndex = nil
            objVMCustomDesign.frontViewRecentShape.selectedBorderColorIndex = nil
            objVMCustomDesign.frontViewRecentShape.selectedFillColorIndex = nil
            objVMCustomDesign.frontViewRecentShape.shapeView = nil
            objVMCustomDesign.frontViewRecentShape.shapePrice = 0.0
        }
        else {
            objVMCustomDesign.backViewRecentShape.selectedShapeIndex = nil
            objVMCustomDesign.backViewRecentShape.selectedBorderColorIndex = nil
            objVMCustomDesign.backViewRecentShape.selectedFillColorIndex = nil
            objVMCustomDesign.backViewRecentShape.shapeView = nil
            objVMCustomDesign.backViewRecentShape.shapePrice = 0.0
        }
    }
    
    
    func  selectFilterValidations(sender:UIButton)  {
        let imageToSave = self.btnSwitchFront.isSelected ? frontImage : backImage
        if !InternetReachability.sharedInstance.isInternetAvailable() {
            self.view.showToast( Messages.NetworkMessages.noInternetConnection, position: .bottom, popTime: 1.5, dismissOnTap: true)
            return
        }
            
        else   if objVMCustomDesign.productSelctedIndex == -1  {
            self.view.showToast(Messages.Validation.chooseProduct, position: .bottom, popTime: 1.5, dismissOnTap: true)
        }
            
            
        else  if imageToSave?.image == nil {
            self.view.showToast(Messages.Validation.waitForImage, position: .bottom, popTime: 1.5, dismissOnTap: true)
            return
        }
            
        else {
            objVMCustomDesign.selectedFilterOption = sender.tag
            resetColors()
            sender.backgroundColor = AppColors.appColorBlue
            if sender.tag == 3  {
                stackViewStepInfo.isHidden = true
                btnNextFilter.isHidden = true
                btnBack.isHidden = true
                openCameraGalleryPopUp {
                    self.resetColors()
                    self.objVMCustomDesign.selectedFilterOption = -1
                }
                bottomCollectionView.isHidden = true
                return
            }
            refillShapeArraysBasedOnClothView()
            bottomCollectionView.reloadData()
            bottomCollectionView.isHidden = false
            bottomCollectionBottomAnchor.constant = sender.tag == 4 ? 5 : -15
            stackViewStepInfo.isHidden = sender.tag == 4 ? false : true
            btnBack.isHidden = sender.tag == 4 ? (objVMCustomDesign.cutFilterCurrentIndex == 1 ? true : false) : true
            btnNextFilter.isHidden = sender.tag == 4 ? false : true
            handleCutFilterStepsUI()
            scrollCollectionToSelctedItems(cutFilterOptionIndex: 1)
        }
        
    }
    
    func refillShapeArraysBasedOnClothView() {
        let object =  !self.btnSwitchFront.isSelected ? objVMCustomDesign.backViewRecentShape : objVMCustomDesign.frontViewRecentShape
        if let shapeIndex = object.selectedShapeIndex {
            objVMCustomDesign.productData?.shapesArray?[shapeIndex].isSelected = true
        }
        
        if let shapeBorderIndex = object.selectedBorderColorIndex {
            objVMCustomDesign.productData?.shapeBorderColorArray?[shapeBorderIndex].isSelected = true
        }
        
        if let shapeFillIndex = object.selectedFillColorIndex {
            objVMCustomDesign.productData?.shapeFillColorArray?[shapeFillIndex].isSelected = true
        }
    }
    
    func resetColors() {
        for i in stackView.subviews {
            let btn = i as? UIButton
            btn?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.handleScreenShotcaptureUI(view: !self.btnSwitchFront.isSelected ? self.backView : self.frontView, shouldHide: true)
                self.saveImageInPhotoGalary(capturedImage: self.btnSwitchFront.isSelected ? self.frontView.screenshot() : self.backView.screenshot())
                self.handleScreenShotcaptureUI(view: !self.btnSwitchFront.isSelected ? self.backView : self.frontView, shouldHide: false)
            }
            
        case .denied, .restricted :
            DispatchQueue.main.async {
                self.alertForGallaryPermission()
            }
        case .notDetermined:
            print("")
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.handleScreenShotcaptureUI(view: !self.btnSwitchFront.isSelected ? self.backView : self.frontView, shouldHide: true)
                            self.saveImageInPhotoGalary(capturedImage: self.btnSwitchFront.isSelected ? self.frontView.screenshot() : self.backView.screenshot())
                            self.handleScreenShotcaptureUI(view: !self.btnSwitchFront.isSelected ? self.backView : self.frontView, shouldHide: false)
                        }
                        
                    case .denied, .restricted:
                        DispatchQueue.main.async {
                            self.alertForGallaryPermission()
                        }
                    case .notDetermined:
                        print("")
                    @unknown default:
                        print("")
                    }
                }
                
            }
        @unknown default:
            print("")
        }
    }
    
    func calculateAdeedOnView() -> UIView {
        return  self.btnSwitchFront.isSelected ? self.frontView : self.backView
    }
    
    func setBorderColorForShapes(index:Int) {
        let shapeObj = !self.btnSwitchFront.isSelected ? (objVMCustomDesign.backViewRecentShape.shapeView) :  (objVMCustomDesign.frontViewRecentShape.shapeView)
        
        if shapeObj?.tag == ShapeViewTags.normalShape.rawValue {
            shapeObj?.borderColor = UIColor.init(hexFromString: objVMCustomDesign.productData?.shapeBorderColorArray?[index].colour ?? "")
        }
            
        else {
            let layer =  shapeObj?.layer.sublayers?[0] as? CAShapeLayer
            layer?.strokeColor = UIColor.init(hexFromString: objVMCustomDesign.productData?.shapeBorderColorArray?[index].colour ?? "").cgColor
            
        }
        
    }
    
    func setFillColorForShapes(index:Int) {
        let shapeObj = !self.btnSwitchFront.isSelected ? (objVMCustomDesign.backViewRecentShape.shapeView) :  (objVMCustomDesign.frontViewRecentShape.shapeView)
        
        if shapeObj?.tag == ShapeViewTags.normalShape.rawValue {
            shapeObj?.backgroundColor = objVMCustomDesign.cutFilterCurrentIndex == 3 && index == 0 ? .clear : UIColor.init(hexFromString: objVMCustomDesign.productData?.shapeFillColorArray?[index].colour ?? "")
            shapeObj?.accessibilityIdentifier = index != 0 && index < 5 ?  AccesibilityIdentifer.extraPriceShape : ""
            
            
        }
            
        else {
            let layer =  shapeObj?.layer.sublayers?[0] as? CAShapeLayer
            layer?.fillColor = objVMCustomDesign.cutFilterCurrentIndex == 3 && index == 0 ? UIColor.clear.cgColor : UIColor.init(hexFromString: objVMCustomDesign.productData?.shapeFillColorArray?[index].colour ?? "").cgColor
            
            shapeObj?.accessibilityIdentifier = index != 0 && index < 5 ?  AccesibilityIdentifer.extraPriceShape : ""
            
            
            
        }
        
    }
    
    func addProtectiveAreaViewForGurstures(productImage:UIImageView) -> UIView {
        let addedOnView = productImage.superview
        guard  let protectiveGestureView = getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: addedOnView ?? UIView()) else {
            
            let protectiveGestureView = UIView(frame: calculateRectOfImageInImageView(imageView: productImage))
            protectiveGestureView.clipsToBounds = true
            protectiveGestureView.restorationIdentifier = RestorationIdentifer.protectiveView
            let newImageView = UIImageView(frame: productImage.frame)
            newImageView.image = productImage.image
            newImageView.contentMode = .scaleAspectFit
            protectiveGestureView.frame = newImageView.frame
            protectiveGestureView.backgroundColor = .clear
            protectiveGestureView.mask = newImageView
            addedOnView?.addSubview(protectiveGestureView)
            return protectiveGestureView
        }
        return protectiveGestureView
        
    }
    func addOuterAreaView(productImage:UIImageView) {
        guard  let addedOnView =    self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: productImage.superview ?? UIView()) else  { return }
        let imageFarme = calculateRectOfImageInImageView(imageView: productImage)
        print(imageFarme)
        let outerView = UIView()
        
        outerView.frame = CGRect(x:  imageFarme.origin.x - 1  + (imageFarme.width / 2) / 2.3, y: 0, width: imageFarme.width - 2 * ((imageFarme.width / 2) / 2.3)  , height: imageFarme.height)
        outerView.restorationIdentifier = RestorationIdentifer.outerArea
        outerView.clipsToBounds = true
        addedOnView.addSubview(outerView)
    }
    
    func addSizeViewOnClothView(productImage:UIImageView,clothSize:clothSizeTypes) {
        guard  let addedOnView =    self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: productImage.superview ?? UIView()) else  { return }
        
        let frame = calculateRectOfImageInImageView(imageView: productImage)
        
        let smallWidth = (frame.width * 22) / 100
        let midWidth = (frame.width * 33) / 100
        let midHeight = (frame.width * 32) / 100
        
        let largeWidth = (frame.width * 40) / 100
        let largeHeight = (frame.width * 43) / 100
        
        
        let frameValue = clothSize == .small ? CGRect(x:frame.midX , y: frame.origin.y + (frame.height * 15 / 100) , width: smallWidth, height: smallWidth) :  clothSize == .medium ? CGRect(x:  frame.midX - midWidth / 2  , y: frame.midY - (midHeight * 95) / 100, width: midWidth, height: midHeight) : CGRect(x:  frame.midX - (largeWidth / 2), y: frame.midY - (largeHeight / 2) - 15, width: largeWidth, height: largeHeight)
        
        
        removeParticularViewIfAdded(fromView: addedOnView, identider: RestorationIdentifer.availableView)
        let availableView = UIView(frame:frameValue)
        availableView.clipsToBounds = true
        availableView.restorationIdentifier = RestorationIdentifer.availableView
        availableView.backgroundColor = .lightGray
        addedOnView.addSubview(availableView)
    }
    func addLeftArmArea(productImage:UIImageView) {
        guard  let addedOnView =    self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: productImage.superview ?? UIView()) else  { return }
        let imageFarme = calculateRectOfImageInImageView(imageView: productImage)
        print(imageFarme)
        let leftArmView = UIView()
        
        leftArmView.frame = CGRect(x:  imageFarme.origin.x + 3  , y: (imageFarme.width / 10) + 3, width: (imageFarme.width / 2) / 2.41  , height: imageFarme.height / 2.85)
        leftArmView.restorationIdentifier = RestorationIdentifer.leftArm
        leftArmView.clipsToBounds = true
        addedOnView.addSubview(leftArmView)
    }
    
    
    func addRightArmArea(productImage:UIImageView) {
        guard  let addedOnView =    self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: productImage.superview ?? UIView()) else  { return }
        
        guard  let outerAreaView =    self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.outerArea, view: addedOnView ) else  { return }
        
        let imageFarme = calculateRectOfImageInImageView(imageView: productImage)
        print(imageFarme)
        let rightArmView = UIView()
        
        rightArmView.frame = CGRect(x:  outerAreaView.frame.width + outerAreaView.frame.origin.x  , y: (imageFarme.width / 10) + 5, width: (imageFarme.width / 2) / 2.3  , height: imageFarme.height / 2.85)
        rightArmView.restorationIdentifier = RestorationIdentifer.rightArm
        rightArmView.clipsToBounds = true
        addedOnView.addSubview(rightArmView)
    }
    
    
    func showTutorialInfo() {
        if UserDefaults.standard.value(forKey:UserDefaultsKeys.isTutorialDisplayed) as? Bool == nil  {
            let blurView = UIView()
            blurView.frame = self.view.frame
            blurView.backgroundColor = UIColor.black
            blurView.alpha = 0.5
            blurView.restorationIdentifier = RestorationIdentifer.blurView
            self.view.addSubview(blurView)
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(CustomDesignVC.blurViewTapped))
            blurView.addGestureRecognizer(tapGuesture)
            blurView.isUserInteractionEnabled = true
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = UIColor.white
            preferences.drawing.foregroundColor = UIColor.black
            preferences.drawing.textAlignment = NSTextAlignment.center
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: -100, y: 0)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 2
            preferences.animating.dismissDuration = 1
            preferences.drawing.font = UIFont.systemFont(ofSize: 12.0)
            let tip = EasyTipView(text:OtherMessages.tutorialMessage, preferences: preferences, delegate: self)
            
            let showOnView = self.getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: frontView)!
            tip.show(forView: showOnView)
            tipView = tip
            UserDefaults.standard.setValue(true, forKey:UserDefaultsKeys.isTutorialDisplayed)
        }
    }
    
    
    func getTotalObjectsAddedCount() -> Int {
        guard  let frontViewProtectiveArea = (getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: frontView)) else {
            return 0 }
        
        guard  let backViewProtectiveArea = (getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: backView)) else {
            return 0 }
        
        var frontSideObjectsCount = 0
        var backSideObjectsCount = 0
        for i in frontViewProtectiveArea.subviewsRecursive() {
            if i.restorationIdentifier == RestorationIdentifer.shapeView  || i.restorationIdentifier == RestorationIdentifer.stickerView  {
                frontSideObjectsCount += 1
            }
        }
        
        for i in backViewProtectiveArea.subviewsRecursive() {
            if i.restorationIdentifier == RestorationIdentifer.shapeView  || i.restorationIdentifier == RestorationIdentifer.stickerView  {
                backSideObjectsCount += 1
            }
        }
        
        print(frontSideObjectsCount + backSideObjectsCount)
        return frontSideObjectsCount + backSideObjectsCount
    }
    
    
    func handleScreenShotcaptureUI(view:UIView,shouldHide:Bool) {
        guard  let protectiveView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: view) else  {
            return
        }
        
        guard  let availableView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: protectiveView) else  {
            return
        }
        
        if shouldHide {
            let cutImageView = UIImageView()
            cutImageView.frame = availableView.frame
            cutImageView.image = UIImage(named: "TshirtFabricSample")
            protectiveView.addSubview(cutImageView)
            cutImageView.restorationIdentifier = RestorationIdentifer.CutArea
            protectiveView.bringSubviewToFront(availableView)
            
        }
        else {
            
            for i in protectiveView.subviews {
                
                if i.restorationIdentifier == RestorationIdentifer.CutArea {
                    i.removeFromSuperview()
                }
                
            }
        }
        
        availableView.backgroundColor = shouldHide ? .clear : .lightGray
    }
    
    func dismissOptionView() {
        UIView.animate(withDuration: 0.5) {
            self.optionViewBottomAnchor.constant = -400
            self.view.layoutIfNeeded()
        }
    }
    
    func createParticularShapes(shapeType:ShapeTypes,addedOnView:UIView,size:clothSizeTypes,isForOutSideObject:Bool,isLeftArm:Bool,isRightArm:Bool) {
        
        guard  let protectiveAreaView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.protectiveView, view: addedOnView) else  {
            return
        }
        
        guard  let availableView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: protectiveAreaView) else  {
            return
        }
        
        let shapeView =  shapeType == .circle ? configureCircleShape(availableView: availableView, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) : shapeType == .reactangle ? ( configureReactangleShape(availableView: availableView, size: size,isForOutSideObject:isForOutSideObject, isForArms: isLeftArm || isRightArm )) : shapeType == .triangle ? drawTriangle(availableView: availableView, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) :  shapeType == .star ?  drawStar(availableView: availableView, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) : shapeType == .rhombus ? drawRhombusShape(availableView: availableView,isForHexagon:false, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) : shapeType == .hexagon ?  drawRhombusShape(availableView: availableView, isForHexagon: true, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) :  shapeType == .square ? configureSequareShape(availableView: availableView, size: size,isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm) :  drawRainbowShape(availableView: availableView, size: size, isForOutSideObject: isForOutSideObject, isForArms: isLeftArm || isRightArm)
        
        if isForOutSideObject {
            guard  let outerAreaView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.outerArea, view: protectiveAreaView)
                else  { return }
            let yPosition = size == .small ? outerAreaView.frame.height / 2 + 10 :  size == .medium ?
                outerAreaView.frame.height / 2 + 30 : outerAreaView.frame.height - 80
            shapeView.frame = CGRect(x: outerAreaView.frame.width / 2 - shapeView.frame.width / 2, y: yPosition, width: shapeView.frame.width, height: shapeView.frame.height)
            outerAreaView.addSubview(shapeView)
        }
            
        else   if isLeftArm || isRightArm {
            guard  let leftArmView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.leftArm, view: protectiveAreaView)
                else  { return }
            
            guard  let rightArmView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.rightArm, view: protectiveAreaView)
                else  { return }
            shapeView.frame.origin.x = isLeftArm ? (leftArmView.frame.width / 2 - shapeView.frame.width / 2 + 4  ) : (rightArmView.frame.width / 2  - shapeView.frame.width / 2 - 4)
            shapeView.frame.origin.y = isLeftArm ? (leftArmView.frame.height / 2) - 8  : (rightArmView.frame.height / 2) -  8
            
            isLeftArm ? leftArmView.addSubview(shapeView) : rightArmView.addSubview(shapeView)
        }
            
        else  {
            availableView.addSubview(shapeView)
        }
        
        // add guesture
        addRequiredGuestureOnView(view: shapeView)
        addedOnView.restorationIdentifier == RestorationIdentifer.frontView ? (objVMCustomDesign .frontViewRecentShape.shapeView = shapeView) : (objVMCustomDesign.backViewRecentShape.shapeView = shapeView)
    }
    
    func addRequiredGuestureOnView(view:UIView) {
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(CustomDesignVC.handlePanOnSticker(sender:)))
        view.addGestureRecognizer(panGuesture)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CustomDesignVC.handleTapOnSticker))
        view.isUserInteractionEnabled = true
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        view.isUserInteractionEnabled = true
    }
    
    
    func addStickerImageInView(selectedImage:UIImage) {
        guard  let availableView =    getViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.availableView, view: !self.btnSwitchFront.isSelected ? backView : frontView) else  {
            return
        }
        removeParticularViewIfAdded(fromView: availableView, identider: RestorationIdentifer.stickerView)
        let width = CGFloat(80)
        let stickerView = UIView()    // create UI
        stickerView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
        stickerView.restorationIdentifier = RestorationIdentifer.stickerView
        availableView.addSubview(stickerView)
        
        let stickerImage = UIImageView()
        stickerImage.tag = 5
        stickerImage.isUserInteractionEnabled = false
        stickerImage.contentMode = .scaleAspectFit
        stickerImage.image = selectedImage
        stickerImage.frame = CGRect(x: 0, y: 0, width: width , height: width)
        stickerView.addSubview(stickerImage)
        addRequiredGuestureOnView(view: stickerView)
        stickerView.isUserInteractionEnabled = true
    }
    
    
    @objc func handlePanOnSticker(sender: UIPanGestureRecognizer) {
        if let stickerView = sender.view {
            var newCenter = sender.translation(in: self.view)
            if(sender.state == .began){
                beginX = stickerView.center.x
                beginY = stickerView.center.y
            }
            newCenter = CGPoint.init(x: beginX + newCenter.x, y: beginY + newCenter.y)
            stickerView.center = newCenter
            self.btnSwitchFront.isSelected ? (objVMCustomDesign.frontViewRecentShape.shapeView = sender.view) : (objVMCustomDesign.backViewRecentShape.shapeView = sender.view)
            dismissOptionView()
        }
    }
    
    @objc func handleTapOnSticker(_ sender: UITapGestureRecognizer) {
        objectToDelete = sender.view
        UIView.animate(withDuration: 0.5) {
            self.optionViewBottomAnchor.constant =  0
            let currentScale = (sender.view?.layer.value(forKeyPath: "transform.scale.x") as? NSNumber)?.floatValue ?? 0.0
            self.shapeSlider.value = currentScale
            self.lblSelectedShape.text = "Selected : \(self.objectToDelete?.accessibilityHint ?? "Image")"
            self.view.layoutIfNeeded()
        }
    }
    
    func handleFrontBackClothViewsVisibility(shouldVisibleFront:Bool) {
        frontView.isHidden = !shouldVisibleFront
        backView.isHidden = shouldVisibleFront
    }
    
    func removeAllObjectsAdded(fromView:UIView) {
        for  i in fromView.subviews {
            let objectToIgnore = fromView.restorationIdentifier == RestorationIdentifer.frontView ? self.frontImage : self.backImage
            
            if i !=  objectToIgnore {
                i.removeFromSuperview()
            }
        }
        
    }
    
    @objc func blurViewTapped(_ sender: UITapGestureRecognizer) {
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                print("Completion called!")
            })
        }
        let viewToRemove = sender.view
        viewToRemove?.removeFromSuperview()
    }
    
    func removeParticularViewIfAdded(fromView:UIView,identider:String) {
        for  i in fromView.subviews {
            if i.restorationIdentifier == identider {
                i.removeFromSuperview()
                break
            }
            
        }
        
    }
    
    // MARK: SAVE IMAGE IN GALLARY
    func saveImageInPhotoGalary(capturedImage:UIImage?) {
        if let image = capturedImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(CustomDesignVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            self.view.showToast(Messages.LocalSuccessMessages.photoSavedSuccessfully, position: .bottom, popTime: 1.5, dismissOnTap: true)
        }
        
    }
    
    
}
//MARK:  ===== ALL ACTION(S) ==== 
extension CustomDesignVC {
    @IBAction func didTapBack(_ sender: UIButton) {
        PopViewController()
    }
    
    @IBAction func dismissOtionPoup(_ sender: UIButton) {
        dismissOptionView()
    }
    
    @IBAction func changeShapeSize(_ sender: UISlider) {
        let currentRotation = (objectToDelete?.layer.value(forKeyPath: "transform.rotation.z") as? NSNumber)?.floatValue ?? 0.0
        objectToDelete?.transform = CGAffineTransform(rotationAngle: CGFloat(currentRotation)).concatenating(CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value)))
    }
    
    @IBAction func didTappedDeleteShape(_ sender: UIButton) {
        self.showAlertWithActionAndCancel(message: Messages.DialogMessages.deleteItem) {
            if self.objectToDelete?.restorationIdentifier == RestorationIdentifer.shapeView {
                self.dismissCutFliterUI()
                self.removeRecentShapedRelatedData(isForFrontView: self.btnSwitchFront.isSelected)
            }
            self.objectToDelete?.removeFromSuperview()
            self.nextButtonUIHandling(shouldEnabled: self.getTotalObjectsAddedCount() > 0)
            self.dismissOptionView()
        }
    }
    
    @IBAction func didtappedLeftRotate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.objectToDelete?.transform =  self.objectToDelete?.transform.rotated(by: -(CGFloat(45 * Double.pi / 180))) as! CGAffineTransform
            self.objectToDelete?.layer.shouldRasterize = true
            self.objectToDelete?.layer.rasterizationScale = UIScreen.main.scale
        })
    }
    
    @IBAction func didTappedRightRotate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.objectToDelete?.transform =  self.objectToDelete?.transform.rotated(by: CGFloat(45 *  Double.pi / 180)) as! CGAffineTransform
            self.objectToDelete?.layer.shouldRasterize = true
            self.objectToDelete?.layer.rasterizationScale = UIScreen.main.scale
        })
    }
    
    @IBAction func didTappedNext(_ sender: UIButton) {
        print("Final Price is \(calculateWholePostPrice())")
        dismissOptionView()
        self.handleScreenShotcaptureUI(view:  self.frontView, shouldHide: true)
        self.handleScreenShotcaptureUI(view:  self.backView, shouldHide: true)
        self.frontView.isHidden = false
        self.backView.isHidden = false
        let targetVc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.addPostVC) as? AddPostVC
        let frontImageObj = ColorScheme( image: frontView.screenshot(),isSelected: Variables.shared.imageColorArray.count == 0 ? true : false)
        let backImageObj = ColorScheme( image: backView.screenshot(),isSelected: false)
        Variables.shared.imageColorArray.append(frontImageObj)
        Variables.shared.imageColorArray.append(backImageObj)
        targetVc?.objVMAddPost.isFromCustomDesign = true
        targetVc?.minimumPrice =  calculateWholePostPrice()
        
        targetVc?.objVMAddPost.printingSizeFront = isAnyObjectAdded(onView: frontView) ? txtFldDropDown.optionArray[objVMCustomDesign.frontViewSelectedSizeIndex] : "None"
        targetVc?.objVMAddPost.printingSizeBack = isAnyObjectAdded(onView: backView) ? txtFldDropDown.optionArray[objVMCustomDesign.backViewSelectedSizeIndex]: "None"
        self.handleScreenShotcaptureUI(view: self.backView, shouldHide: false)
        self.handleScreenShotcaptureUI(view: self.frontView, shouldHide: false)
        self.navigationController?.pushViewController(targetVc ?? UIViewController(), animated: true)
    }
    
    @IBAction func didTappedGallary(_ sender: UIButton) {
        selectFilterValidations(sender: sender)
    }
    
    @IBAction func didTappedCut(_ sender: UIButton) {
        selectFilterValidations(sender: sender)
    }
    
    @IBAction func didTappedSave(_ sender: UIButton) {
        dismissOptionView()
        let imageToSave = self.btnSwitchFront.isSelected ? frontImage : backImage
        if imageToSave?.image == nil {
            self.view.showToast(Messages.Validation.waitForImage, position: .bottom, popTime: 1.5, dismissOnTap: true)
            return
        }
        self.checkPhotoLibraryPermission()
    }
    @IBAction func didTappedNextBackFilter(_ sender: UIButton) {
        if sender == btnNextFilter {
            cutFilterValidations()
        }
        else {
            objVMCustomDesign.cutFilterCurrentIndex = objVMCustomDesign.cutFilterCurrentIndex - 1
            bottomCollectionView.reloadData()
            scrollCollectionToSelctedItems(cutFilterOptionIndex: objVMCustomDesign.cutFilterCurrentIndex)
            handleCutFilterStepsUI()
        }
    }
    
    @IBAction func didTappedCrossButton(_ sender: UIButton) {
        self.showAlertWithActionAndCancel(message:Messages.DialogMessages.removePatterns) {
            let index:IndexPath = NSIndexPath(item: self.objVMCustomDesign.productSelctedIndex, section: 0) as IndexPath
            self.collectionViewProductList.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.objVMCustomDesign.productSelctedIndex = -1
            self.objVMCustomDesign.frontViewSelectedSizeIndex = 0
            self.objVMCustomDesign.backViewSelectedSizeIndex = 0
            self.collectionViewProductList.isHidden = false
            self.frontView.isHidden = true
            self.backView.isHidden = true
            self.btnDelete.isHidden = true
            self.bottomCollectionView.isHidden = true
            self.btnSaveToGallary.isHidden = true
            self.removeRecentShapedRelatedData(isForFrontView: true)
            self.removeRecentShapedRelatedData(isForFrontView: false)
            self.objVMCustomDesign.selectedFilterOption = -1
            self.resetColors()
            self.stackViewStepInfo.isHidden = true
            self.btnNextFilter.isHidden = true
            self.btnBack.isHidden = true
            self.objVMCustomDesign.cutFilterCurrentIndex  = 1
            self.unSelectedAllArrays()
            self.nextButtonUIHandling(shouldEnabled: false)
            self.txtFldDropDown.isHidden = true
            self.stackViewSwitch.isHidden = true
            self.btnSwitchFront.isSelected = true
            self.btnSwitchBack.isSelected = false
            self.txtFldDropDown.selectedIndex = 0
            self.txtFldDropDown.text = self.txtFldDropDown.optionArray[0]
            self.removeAllObjectsAdded(fromView: self.frontView)
            self.removeAllObjectsAdded(fromView: self.backView)
            self.dismissOptionView()
        }
    }
}

//MARK:- EASY TIP VIEW DELEGATE(S):
extension CustomDesignVC: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        let viewToRemove = getParticulatViewWithIdentifer(ofType: UIView.self, identifer: RestorationIdentifer.blurView)
        viewToRemove?.removeFromSuperview()
    }
}
