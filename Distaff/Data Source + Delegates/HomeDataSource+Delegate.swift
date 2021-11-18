//
//  HomeDataSource.swift
//  Distaff
//
//  Created by netset on 15/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit

//MARK:--  TABLE DATA SOURCE(S) -- 
extension HomeVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objHomeVM.postListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifers.homeTableCell) as? HomeTableCell
        cell?.postObject = objHomeVM.postListArray[indexPath.row]
        cell?.callBackLike = {
            self.isGuestUser() ?  self.displayGuestUserAlert() : CommonMethods.callLikeUnlikeApi(postId: self.objHomeVM.postListArray[indexPath.row].id ?? 0, status: !(self.objHomeVM.postListArray[indexPath.row].post_like ?? false)) {
                self.objHomeVM.postListArray[indexPath.row].post_like = !(self.objHomeVM.postListArray[indexPath.row].post_like ?? false)
                self.objHomeVM.postListArray[indexPath.row].total_likes = !(self.objHomeVM.postListArray[indexPath.row].post_like ?? false) ?  (self.objHomeVM.postListArray[indexPath.row].total_likes ?? 1) - 1 : (self.objHomeVM.postListArray[indexPath.row].total_likes ?? 0) + 1
                cell?.btnLike.isSelected = self.objHomeVM.postListArray[indexPath.row].post_like ?? false ? true : false
                cell?.lblLikeCount.text = String( self.objHomeVM.postListArray[indexPath.row].total_likes ?? 0)
                self.likeAndSavedCollectionAnimation(btn: (cell?.btnLike)!)
            }
            
        }
        
        cell?.callBackBuy = {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.postDetailVC) as? PostDetailVC
            targetVC?.postId = self.objHomeVM.postListArray[indexPath.row].id ?? 0
            targetVC?.callbackDataRefresh = {isPostLiked, commentCount, isPostFavourited, likeCount,cartCount in
                self.objHomeVM.postListArray[indexPath.row].post_like = isPostLiked
                self.objHomeVM.postListArray[indexPath.row].total_comments = commentCount
                
                self.objHomeVM.postListArray[indexPath.row].total_likes = likeCount
                self.objHomeVM.postListArray[indexPath.row].post_fav = isPostFavourited
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
            
        }
        
        
        cell?.callBackSavedInCollection = {
            self.isGuestUser() ?  self.displayGuestUserAlert() : CommonMethods.callFavouriteUnfavouriteApi(postId: self.objHomeVM.postListArray[indexPath.row].id ?? 0, status: !(self.objHomeVM.postListArray[indexPath.row].post_fav ?? false)) {
                self.objHomeVM.postListArray[indexPath.row].post_fav = !(self.objHomeVM.postListArray[indexPath.row].post_fav ?? false)
                
                cell?.btnSaveCollection.isSelected =  self.objHomeVM.postListArray[indexPath.row].post_fav ?? false ? true : false
                self.likeAndSavedCollectionAnimation(btn: (cell?.btnSaveCollection)!)
                
                //  tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            
        }
        
        cell?.callBackProfileTapped = {
            if self.objHomeVM.postListArray[indexPath.row].post_type != "promotional" {
                let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.myProfileVC) as? MyProfileVC
                targetVC?.isMyProfile = false
                targetVC?.passedUserId = self.objHomeVM.postListArray[indexPath.row].user ?? 0
                self.isGuestUser() ?  self.displayGuestUserAlert() : self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
            }
        }
        
        cell?.callBackComment = {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.commentsVC) as? CommentsVC
            targetVC?.callBackCommentCount = { totalComments in
                self.objHomeVM.postListArray[indexPath.row].total_comments = totalComments
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            targetVC?.postId = self.objHomeVM.postListArray[indexPath.row].id ?? 0
            self.isGuestUser() ?  self.displayGuestUserAlert() :  self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
        }
        
        cell?.callBackMessage = {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.chatVC) as? ChatVC
            targetVC?.receiverId = self.objHomeVM.postListArray[indexPath.row].user ?? 0
            self.isGuestUser() ?  self.displayGuestUserAlert() : self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
        }
        
        cell?.callBackMenuOptions  = {
            self.isGuestUser() ?  self.displayGuestUserAlert() : CommonMethods.reportPostOptions { (text) in
                CommonMethods.callReportPostApi(postId: self.objHomeVM.postListArray[indexPath.row].id ?? 0, reason: text) {
                    self.showAlert(message:Messages.CustomServerMessages.reportPostSuccessfully)
                }
                
            }
            
        }
        
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if objHomeVM.postListArray[indexPath.row].post_type == "promotional" {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.promotionalPostDetailVC) as? PromotionalPostDetailVC
            targetVC?.postId = self.objHomeVM.postListArray[indexPath.row].id ?? 0
            targetVC?.callbackDataRefresh = {isPostLiked, commentCount, isPostFavourited, likeCount in
                self.objHomeVM.postListArray[indexPath.row].post_like = isPostLiked
                self.objHomeVM.postListArray[indexPath.row].total_comments = commentCount
                
                self.objHomeVM.postListArray[indexPath.row].total_likes = likeCount
                self.objHomeVM.postListArray[indexPath.row].post_fav = isPostFavourited
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
            
        }
        else {
            let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllersIdentifers.postDetailVC) as? PostDetailVC
            targetVC?.postId = self.objHomeVM.postListArray[indexPath.row].id ?? 0
            targetVC?.callbackDataRefresh = {isPostLiked, commentCount, isPostFavourited, likeCount,cartCount in
                self.objHomeVM.postListArray[indexPath.row].post_like = isPostLiked
                self.objHomeVM.postListArray[indexPath.row].total_comments = commentCount
                
                self.objHomeVM.postListArray[indexPath.row].total_likes = likeCount
                self.objHomeVM.postListArray[indexPath.row].post_fav = isPostFavourited
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            self.navigationController?.pushViewController(targetVC ?? UIViewController(), animated: true)
            
        }
        
    }
    
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objHomeVM.postListArray.count - 1 && objHomeVM.doesNxtPageExist {
            objHomeVM.pageNumber =  objHomeVM.pageNumber + 1
            fetchHomePostListing(shouldAnimate: true)
        }
    }
    
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        if scrollView == tablViewHome {
    //            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    //            {
    //                if objHomeVM.doesNxtPageExist {
    //                    objHomeVM.pageNumber =  objHomeVM.pageNumber + 1
    //                    fetchHomePostListing(shouldAnimate: true)
    //                }
    //            }
    //        }
    //
    //
    //    }
    
    
    
}



