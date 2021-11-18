//
//  CustomDesignmDataSource + Deletgates.swift
//  Distaff
//
//  Created by Aman on 13/04/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

//MARK: --  COLLECTION DELEGATE METHOD(S) -- 
extension CustomDesignVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return   collectionView == collectionViewProductList ? (objVMCustomDesign.productData?.clothstyle?.count ?? 0) : objVMCustomDesign.cutFilterCurrentIndex == 1 ? (objVMCustomDesign.productData?.shapesArray?.count ?? 0) : objVMCustomDesign.cutFilterCurrentIndex == 2 ? (  objVMCustomDesign.productData?.shapeBorderColorArray?.count ?? 0) :   objVMCustomDesign.productData?.shapeFillColorArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewProductList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifers.customDesignListCollectionCell, for: indexPath) as? CustomDesignListCollectionCell
            
            DispatchQueue.main.async {
                cell?.setNeedsLayout()
                cell?.layoutIfNeeded()
            }
            cell?.frontImage.setSdWebImage(url:objVMCustomDesign.productData?.clothstyle?[indexPath.row].front_image ?? "",isForCustomDesign:true)
            return cell ?? UICollectionViewCell()
        }
            
        else   if objVMCustomDesign.cutFilterCurrentIndex == 1  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifers.customDesignShapeCell, for: indexPath) as? CustomDesignShapeCell
            cell?.imageHeightAnchor.constant = 32
            cell?.imgViewShape.contentMode = .scaleAspectFit
            cell?.selectedView.borderWidth =  (objVMCustomDesign.productData?.shapesArray?[indexPath.row].isSelected ?? false ? 1.5 : 1)
            
            cell?.selectedView.borderColor = objVMCustomDesign.productData?.shapesArray?[indexPath.row].isSelected ?? false  ? AppColors.appColorBlue : .lightGray
            
            cell?.imgViewShape.setSdWebImage(url: objVMCustomDesign.productData?.shapesArray?[indexPath.row].image ?? "")
            cell?.lblShapeName.text =  objVMCustomDesign.productData?.shapesArray?[indexPath.row].shapeName ?? ""
            
            return cell ?? UICollectionViewCell()
        }
            
        else
        {
            
            
            if objVMCustomDesign.cutFilterCurrentIndex == 3 && indexPath.row == 0 {
           
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifers.customDesignSewCell, for: indexPath) as? CustomDesignSewCell
                
                cell?.lblSew.borderWidth = (objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected ?? false ? 1.5 : 1)
                           cell?.lblSew.borderColor =   (objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected ?? false ? AppColors.appColorBlue : .lightGray)
                return cell ?? UICollectionViewCell()
            }
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifers.customDesignChooseColorCollectionCell, for: indexPath) as? CustomDesignChooseColorCollectionCell
            
            cell?.colorView.backgroundColor = objVMCustomDesign.cutFilterCurrentIndex == 2 ? UIColor(hexFromString: objVMCustomDesign.productData?.shapeBorderColorArray?[indexPath.row].colour ?? "") : UIColor(hexFromString: objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].colour ?? "")
            cell?.colorOuterView.borderWidth =    objVMCustomDesign.cutFilterCurrentIndex == 2 ? (objVMCustomDesign.productData?.shapeBorderColorArray?[indexPath.row].isSelected ?? false ? 1.5 : 1) : (objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected ?? false ? 1.5 : 1)
            cell?.colorOuterView.borderColor =   objVMCustomDesign.cutFilterCurrentIndex == 2 ?  (objVMCustomDesign.productData?.shapeBorderColorArray?[indexPath.row].isSelected ?? false ? AppColors.appColorBlue : .lightGray) : (objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected ?? false ? AppColors.appColorBlue : .lightGray)
            return cell ?? UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewProductList {
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
            if visibleIndexPath  == indexPath {
                objVMCustomDesign.productSelctedIndex = indexPath.row
                self.collectionViewProductList.isHidden = true
                self.frontView.isHidden = false
                self.frontImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.frontImage.sd_setImage(with: URL.init(string: "\(WebServicesApi.imageBaseUrl)\(objVMCustomDesign.productData?.clothstyle?[indexPath.row].front_image ?? "")"), placeholderImage: nil, options: .highPriority) { (image, error, cacheType, imageURL) in
                    DispatchQueue.main.async {
                        _  = self.addProtectiveAreaViewForGurstures(productImage: self.frontImage)
                        self.addOuterAreaView(productImage: self.frontImage)
                        self.addSizeViewOnClothView(productImage: self.frontImage,clothSize: .small)
                        self.addLeftArmArea(productImage: self.frontImage)
                        self.addRightArmArea(productImage: self.frontImage)
                        self.showTutorialInfo()
                    }
                }
                
                self.backImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.backImage.sd_setImage(with: URL.init(string: "\(WebServicesApi.imageBaseUrl)\(objVMCustomDesign.productData?.clothstyle?[indexPath.row].back_image ?? "")"), placeholderImage: nil, options: .highPriority) { (image, error, cacheType, imageURL) in
                    DispatchQueue.main.async {
                        _  = self.addProtectiveAreaViewForGurstures(productImage: self.backImage)
                        self.addOuterAreaView(productImage: self.backImage)
                        self.addSizeViewOnClothView(productImage: self.backImage,clothSize: .small)
                        self.addLeftArmArea(productImage: self.backImage)
                        self.addRightArmArea(productImage: self.backImage)
                    }
                }
                
                self.btnSaveToGallary.isHidden = false
                bottomCollectionView.reloadData()
                btnDelete.isHidden = false
                txtFldDropDown.isHidden = false
                stackViewSwitch.isHidden = false
                
            }
            else {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
            
        else   if  objVMCustomDesign.cutFilterCurrentIndex == 1 {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.chooseShapePoupVC) as? ChooseShapeAreaPopupVC
            targetVC?.modalPresentationStyle = .overCurrentContext
            
            targetVC?.callBackShapeSelection = { index in
                
                self.objVMCustomDesign.productData?.shapesArray?.mutateEach({($0.isSelected = false)})
                self.objVMCustomDesign.productData?.shapesArray?[indexPath.row].isSelected = true
                self.objVMCustomDesign.productData?.shapeBorderColorArray?.mutateEach({($0.isSelected = false)})
                self.objVMCustomDesign.productData?.shapeFillColorArray?.mutateEach({($0.isSelected = false)})
                
                !self.btnSwitchFront.isSelected ? (self.objVMCustomDesign.backViewRecentShape.selectedBorderColorIndex = nil) : (self.objVMCustomDesign.frontViewRecentShape.selectedBorderColorIndex = nil)
                
                !self.btnSwitchFront.isSelected ? (self.objVMCustomDesign.backViewRecentShape.selectedFillColorIndex = nil) : (self.objVMCustomDesign.frontViewRecentShape.selectedFillColorIndex = nil)
                
               !self.btnSwitchFront.isSelected ? (self.objVMCustomDesign.backViewRecentShape.selectedShapeIndex = indexPath.row) : (self.objVMCustomDesign.frontViewRecentShape.selectedShapeIndex = indexPath.row)
                
               !self.btnSwitchFront.isSelected ? (self.objVMCustomDesign.backViewRecentShape.shapePrice = self.objVMCustomDesign.productData?.shapesArray?[indexPath.row].price ?? 0.0) : (self.objVMCustomDesign.frontViewRecentShape.shapePrice = self.objVMCustomDesign.productData?.shapesArray?[indexPath.row].price ?? 0.0)
                
                self.nextButtonUIHandling(shouldEnabled: true)
                self.bottomCollectionView.reloadData()
                self.bottomCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.createParticularShapes(shapeType: indexPath.row == 0 ? .reactangle : indexPath.row == 1 ? .circle  : indexPath.row == 2 ? .triangle : indexPath.row == 3 ? .star : indexPath.row == 4 ? .rhombus : indexPath.row == 5 ? .hexagon : indexPath.row == 6 ? .square :.rainBow, addedOnView: self.calculateAdeedOnView(), size: self.txtFldDropDown.selectedIndex == 0 ? .small : self.txtFldDropDown.selectedIndex == 1 ? .medium : .large,isForOutSideObject: index == 1,isLeftArm: index == 2,isRightArm: index == 3 )
            }
            
            self.present(targetVC ?? UIViewController(), animated: true, completion: nil)
        }
            
        else  if  objVMCustomDesign.cutFilterCurrentIndex == 2   {
            if !(objVMCustomDesign.productData?.shapeBorderColorArray?[indexPath.row].isSelected ?? false) {
                objVMCustomDesign.productData?.shapeBorderColorArray?.mutateEach({($0.isSelected = false)})
                objVMCustomDesign.productData?.shapeBorderColorArray?[indexPath.row].isSelected = true
                bottomCollectionView.reloadData()
                bottomCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               !self.btnSwitchFront.isSelected ? (objVMCustomDesign.backViewRecentShape.selectedBorderColorIndex = indexPath.row) : (objVMCustomDesign.frontViewRecentShape.selectedBorderColorIndex = indexPath.row)
                setBorderColorForShapes(index: indexPath.row)
                
            }
        }
        else {
            if !(objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected ?? false) {
                objVMCustomDesign.productData?.shapeFillColorArray?.mutateEach({($0.isSelected = false)})
                objVMCustomDesign.productData?.shapeFillColorArray?[indexPath.row].isSelected = true
                bottomCollectionView.reloadData()
                bottomCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               !self.btnSwitchFront.isSelected ? (objVMCustomDesign.backViewRecentShape.selectedFillColorIndex =  indexPath.row) : (objVMCustomDesign.frontViewRecentShape.selectedFillColorIndex = indexPath.row)
                setFillColorForShapes(index: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: SWITCH DELEGATE(S)
extension CustomDesignVC : LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        print(sender.curState)
        txtFldDropDown.hideList()
        self.dismissOptionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.handleFrontBackClothViewsVisibility(shouldVisibleFront: sender.curState == .L ? false  : true)
            self.txtFldDropDown.text = sender.curState == .L ? self.txtFldDropDown.optionArray[self.objVMCustomDesign.backViewSelectedSizeIndex] :  self.txtFldDropDown.optionArray[self.objVMCustomDesign.frontViewSelectedSizeIndex]
            self.txtFldDropDown.selectedIndex = sender.curState == .L ? self.objVMCustomDesign.backViewSelectedSizeIndex : self.objVMCustomDesign.frontViewSelectedSizeIndex
            self.dismissCutFliterUI()
        }
    }
    
    
    
    
    
}
