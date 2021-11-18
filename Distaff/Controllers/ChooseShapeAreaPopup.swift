//
//  ChooseShapeAreaPopup.swift
//  Distaff
//
//  Created by Aman on 15/07/20.
//  Copyright © 2020 netset. All rights reserved.
//

import UIKit

class ChooseShapeAreaPopupVC: BaseClass {
    
    @IBOutlet weak var tblview: UITableView!
    
    var callBackShapeSelection : ((_ index:Int)->())?
    var shapePositionArray = ["Inside perimeter","Outside perimeter","Left sleeve","Right sleeve"]
    var selectedIndex = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
//MARK:TABLE DATA SOURCE DELEGATE(S)
extension ChooseShapeAreaPopupVC :  UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapePositionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblview.dequeueReusableCell(withIdentifier: CellIdentifers.clothMaterialTableViewCell) as? ClothMaterialTableViewCell
        cell?.lblTitle.text = shapePositionArray[indexPath.row]
        cell?.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

//MARK: ALL ACTION(S):
extension ChooseShapeAreaPopupVC {
    @IBAction func didtappedDone(_ sender: UIButton) {
        if selectedIndex == -1 {
            showAlert(message:Messages.Validation.choosePosition)
        }
            
        else  {
            callBackShapeSelection?(selectedIndex)
            dismissVC()
        }
        
    }
    
    @IBAction func didtappedClose(_ sender: UIButton) {
        dismissVC()
    }
    
}
