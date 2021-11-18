
import Foundation
import UIKit
import IQKeyboardManager
import SKPhotoBrowser
import AVFoundation
import MIBadgeButton_Swift

class BaseClass: UIViewController {
    
    var picker:UIImagePickerController?=UIImagePickerController()
    let datePicker = UIDatePicker()
    var expiryDatePicker = MonthYearPickerView()
    var refreshControl = UIRefreshControl()
    var searchBarController =  UISearchBar()
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        clearSDWebCache()
    }
    
    
    
    
    
    
    
    func addDatePickerInTextField(textField:UITextField) {
        // MARK: Changed by Abdou
        // Shows the old weel instead of new iOS 14 picker due to a bug
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.sizeToFit()
            }

        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(BaseClass.handleDatePickerSelection), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = .date
        let langStr = Locale.current.languageCode
        self.datePicker.locale = Locale(identifier:langStr!)
        self.datePicker.set18YearValidation()
    }
    
    
    func addPickerViewInTextField(textField:UITextField) {
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.reloadAllComponents()
        
    }
    
    
    
    func addRefreshControlInTable(tableView:UITableView) {
        let attributes = [NSAttributedString.Key.foregroundColor: AppColors.appColorBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.tintColor = AppColors.appColorBlue
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    
    func addRefreshControlInScrollView(scrollView:UIScrollView) {
        let attributes = [NSAttributedString.Key.foregroundColor: AppColors.appColorBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refreshControl.tintColor = AppColors.appColorBlue
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: UIControl.Event.valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.alwaysBounceVertical = true
        
    }
    
    func removeRefreshControl() {
        refreshControl.endRefreshing()
        refreshControl.isHidden = true
    }
    
    
    func handleUnreadNotificationUI(btn:MIBadgeButton) {
        btn.badgeString = Variables.shared.hasPendingNotifications ? "●" : ""
        
    }
    
    
    @objc func refreshData() {
        
    }
    
    func addExpiryDatePickerInTextField(textField:UITextField) {
        textField.inputView = expiryDatePicker
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            textField.text = "\(String(format: "%02d", month))/\(String(year))"
        }
    }
    
    func cutArea(holeRect: CGRect, inView view: UIView) {
        let combinedPath = CGMutablePath()
        combinedPath.addRect(view.bounds)
        combinedPath.addRect(holeRect)
        
        let maskShape = CAShapeLayer()
        maskShape.path = combinedPath
        maskShape.fillRule = .evenOdd
        
        view.layer.mask = maskShape
    }
    
    
    func displayZoomImages(imageArray:[SKPhotoProtocol],index:Int) {
        if InternetReachability.sharedInstance.isInternetAvailable() {
            let browser = SKPhotoBrowser(photos:imageArray)
            browser.initializePageIndex(index)
            browser.delegate = self
            present(browser, animated: true, completion: nil)
        }
    }
    
    
    func displayZoomSingleImages(url:String) {
        var images = [SKPhotoProtocol]()
        let photo = SKPhoto.photoWithImageURL("\(WebServicesApi.imageBaseUrl)\(url)")
        photo.shouldCachePhotoURLImage = true
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        present(browser, animated: true, completion: nil)
        
    }
    
    
    
    func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseClass.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseClass.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func removeAllObserversAdded() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //               bottomConstraints.constant = keyboardSize.height
            //               UIView.animate(withDuration: 1.0, animations: {
            //                   self.view.layoutIfNeeded()
            //                   //                self.scrollTableToLastIndex()
            //                   self.view.setNeedsLayout()
            //               })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //               bottomConstraints.constant = 0
            //               UIView.animate(withDuration: 1.0, animations: {
            //                   self.view.layoutIfNeeded()
            //                   self.view.setNeedsLayout()
            //               })
        }
    }
    
    
    
    
    @objc func handleDatePickerSelection() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        _ = formatter.string(from: datePicker.date)
    }
    
    
    
    func handleNavigationBarTranparency(shouldTranparent:Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(shouldTranparent == true ? UIImage() : #imageLiteral(resourceName: "navigationImage") , for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = shouldTranparent
        self.navigationController?.view.backgroundColor = AppColors.appColorBlue
        
    }
    
    
    //MARK:- pop view contrller here
    func PopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popTwoViewControllers() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    func enableIQKeyboard() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    func disableIQKeyboard() {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    func handleTabbarVisibility(shouldHide:Bool) {
        self.tabBarController?.tabBar.isHidden = shouldHide ? true : false
    }
    
    
    
    //MARK:- push vc here
    func pushToViewController(VC:String) {
        let targetVc = self.storyboard?.instantiateViewController(withIdentifier:VC)
        self.navigationController?.pushViewController(targetVc!, animated: true)
    }
    
    
    func presentViewController(withIdentifer:String) {
        let targetVc = self.storyboard!.instantiateViewController(withIdentifier:withIdentifer)
        targetVc.modalPresentationStyle = .overCurrentContext
        present(targetVc, animated: true, completion: nil)
    }
    
    func presentViewControllerWithNavigation(withIdentifer:String) {
        DispatchQueue.main.async {
            let targetVc = self.storyboard!.instantiateViewController(withIdentifier:withIdentifer)
            let navigationController: UINavigationController = UINavigationController(rootViewController: targetVc)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    //    func handleNavigationBarLiftingWithScroll(shouldLift:Bool,scrollView:UIScrollView? = nil) {
    //        if let navigationController = self.navigationController as? ScrollingNavigationController {
    //            if shouldLift {
    //                navigationController.followScrollView(scrollView ?? UIScrollView(), delay: 10.0)
    //            }
    //            else {
    //                navigationController.stopFollowingScrollView()
    //            }
    //
    //        }
    //
    //
    //    }
    
    
    //MARK:- pop vc here
    func popToRootVc() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func dismissAndPopToRoot() {
        let presentingVC = self.presentingViewController
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC?.navigationController
        navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissPopToRootAndChangeTabbar() {
        let presentingVC = self.presentingViewController
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC?.navigationController
        navigationController?.popToRootViewController(animated: false)
        let newNav = navigationController?.tabBarController?.viewControllers?.last as? UINavigationController
        let myOrderPage = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.orderHistoryVC) as? OrderHistoryVC
        myOrderPage?.isFromShoppingFlow = true
        newNav?.pushViewController(myOrderPage ?? UIViewController(), animated: true)
        navigationController?.tabBarController?.selectedIndex = 4
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissAndPushToViewController(identifer:String) {
        self.dismiss(animated: true, completion: nil)
        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        let targetVc = self.storyboard?.instantiateViewController(withIdentifier:identifer)
        navigationController?.pushViewController(targetVc!, animated: true)
    }
    
    func dismissAndPresentViewController(identifer:String) {
        self.dismiss(animated: true, completion: nil)
        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        let targetVc = self.storyboard?.instantiateViewController(withIdentifier:identifer)
        targetVc?.modalPresentationStyle = .overCurrentContext
        navigationController?.present(targetVc ?? UIViewController(), animated: true, completion: nil)
    }
    
    func addSerachBarInNavigation(placeholderText:String,backgroundColor:UIColor? = nil,textFont:UIFont? = nil) {
        searchBarController.sizeToFit()
        searchBarController.delegate = self
        searchBarController.placeholder = placeholderText
        searchBarController.backgroundImage = UIImage()
        if #available(iOS 13.0, *) {
            searchBarController.searchTextField.font = textFont
            searchBarController.searchTextField.backgroundColor = backgroundColor
        }
        else {
            let textFieldInsideUISearchBar = searchBarController.value(forKey: "_searchField") as? UITextField
            textFieldInsideUISearchBar?.font  = textFont
            textFieldInsideUISearchBar?.backgroundColor = backgroundColor
            
        }
        
        self.navigationController?.navigationBar.topItem?.titleView = searchBarController
    }
    
    func removeSearchBarFromNavigationBar() {
        self.navigationController?.navigationBar.topItem?.titleView = nil
    }
    
    func handleCartButtonSelection(btnCart:MIBadgeButton) {
        if btnCart.badgeString == "" {
            self.view.showToast(Messages.NoDataMessage.noDataInCart, position: .bottom, popTime: 2.0, dismissOnTap: true)
        }
        else {
            pushToViewController(VC: ViewControllersIdentifers.shoppingBagVC)
        }
        
    }
    
    
    //MARK:- Dismiss Keyboard
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    //MARK:- Show Alert
    func showAlert(message:String) {
        let alert = UIAlertController(title:AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    func showAlertWithAction(message:String,onComplete:@escaping (()->())) {
        let alert = UIAlertController(title: AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            onComplete()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithActionAndCancel(message:String,onComplete:@escaping (()->())) {
        let alert = UIAlertController(title: AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            onComplete()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancelAndOkAction(message:String,onComplete:@escaping (()->()),onCancel:@escaping (()->())) {
        let alert = UIAlertController(title: AppInfo.appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColors.appColorBlue
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            onComplete()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            onCancel()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.view.backgroundColor = AppColors.appColorBlue
        
    }
    
    
    func openCameraGalleryPopUp(onComplete:(()->())? = nil)  {
        dismissKeyboard()
        let optionMenu = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraValidations()
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            onComplete?()
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        optionMenu.view.tintColor  = AppColors.appColorBlue
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    // MARK:-  Open camera Method 
    fileprivate func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker?.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker!.sourceType = UIImagePickerController.SourceType.camera
            picker?.modalPresentationStyle = .overCurrentContext
            picker?.allowsEditing = true
            present(picker!, animated: true, completion: nil)
        }
            
        else {
            self.showAlert(message:OtherMessages.cameraNotFound)
        }
        
    }
    
    
    
    func checkCameraValidations() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            }
        case .restricted:
            alertForCameraPermission()
        case .denied:
            alertForCameraPermission()
        case .authorized:
            DispatchQueue.main.async {
                self.openCamera()
            }
        @unknown default:
            print("")
        }
        
    }
    
    
    
    // MARK:-  Open galary Method 
    func openGallary() {
        picker?.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        showNavigationBar()
        picker?.allowsEditing = true
        picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker?.modalPresentationStyle = .overCurrentContext
        UINavigationBar.appearance().barTintColor = AppColors.appColorBlue
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        present(picker!, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
}

//MARK:--  IMAGE PICKER DELEGATES 
extension BaseClass:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        _ = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:--  TEXT FIELD DELEGATES 
extension BaseClass : UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        showNavigationBar()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == TextFieldsTag.email {
            if !string.canBeConverted(to: String.Encoding.ascii) || string == " "{
                return false
            }
        }
        
        if textField.tag == TextFieldsTag.password {
            if !string.canBeConverted(to: String.Encoding.ascii) {
                return false
            }
        }
        if textField.tag == TextFieldsTag.firstname || textField.tag == TextFieldsTag.lastName {
            if !string.canBeConverted(to: String.Encoding.ascii) || string == " "{
                return false
            }
        }
        
        if textField.tag == TextFieldsTag.fullName {
            if !string.canBeConverted(to: String.Encoding.ascii) {
                return false
            }
        }
        
        return true
        
        
    }
    
}
////MARK:--  COUNTRY PICKER DELEGATES 
//extension BaseClass :MRCountryPickerDelegate {
//    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//
//    }
//
//}
//MARK:--  TEXT VIEW DELEGATES 
extension BaseClass: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        showNavigationBar()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
}
//MARK:--  SCROLL VIEW DELEGATES 
extension BaseClass: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
}


//MARK:--  Photo Viewer DELEGATES 
extension BaseClass : SKPhotoBrowserDelegate {
    
}

//MARK:--  SEARCH BAR DELEGATES 
extension BaseClass :  UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarController.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarController.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarController.text = ""
        searchBarController.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !text.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }
    
}

//MARK:--  PICKER VIEW DELEGATES 
extension BaseClass:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name:AppFont.fontRegular, size:18)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = ""
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}
