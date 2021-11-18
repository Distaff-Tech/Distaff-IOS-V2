//
//  CreateProfileVM.swift
//  Distaff
//
//  Created by netset on 13/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit
class CreateProfileVM : NSObject {
    
    var capturedImage:UIImage? = nil
    
    func formValidations(_ request:CreateProfile.Request) -> Bool {
        var message = ""
         if request.isFromEditProfile == 1 {
            
            if request.profileData?.data?.user_name != "" && request.userName?.trimmingCharacters(in: .whitespaces) == "" {
                message = Messages.Validation.enterUserName
            }
                
            else if request.profileData?.data?.fullname != "" && request.fullName?.trimmingCharacters(in: .whitespaces) == "" {
                message = Messages.Validation.enterFullName
            }
                
            else if request.profileData?.data?.address != "" && request.completeAddress?.trimmingCharacters(in: .whitespaces) == "" {
                message = Messages.Validation.enterAddress
                
            }
            else  {
             return true
            }
            
        }
            
         else {
            if request.fullName?.trimmingCharacters(in: .whitespaces) == "" {
                           message = Messages.Validation.enterFullName
                       }
            
            else  {
             return true
            }
            
        }
      
        
    
    if message != "" {
    Alert.displayAlertOnWindow(with: message)
    }
    return false
}


func callCreateProfileApi(_ request: CreateProfile.Request,completion:@escaping(_ data:CreateProfileModel?) -> Void) {
    //   if formValidations(request) {
    let dict = [Create_Profile.address:request.completeAddress ?? "",Create_Profile.aboutMe : request.about ?? "" ,Create_Profile.gender : request.gender ?? "",Create_Profile.dob:request.DateOfBirth != "" ?CommonMethods.convertDateFormat(inputFormat: "MM-dd-yyyy", outputFormat: "yyyy-MM-dd", dateString: request.DateOfBirth ?? "") : "",Create_Profile.fullName : request.fullName ?? "",Create_Profile.userName : request.userName ?? "",Create_Profile.is_from_edit : request.isFromEditProfile ?? false] as [String : Any]
    let param = [Create_Profile.data:CommonMethods.convertDictToJsonString(dictionary: dict)]
    Services.postRequestWithImage(imageName: Create_Profile.image, url: WebServicesApi.createProfile, shouldAnimateHudd: true, param:param , image: request.profilePicture) { (responseData) in
        do {
            let createProfileData = try JSONDecoder().decode(CreateProfileModel.self, from: responseData)
            print(createProfileData)
            
            completion(createProfileData)
        }
            
        catch {
            Alert.displayAlertOnWindow(with: error.localizedDescription)
        }
    }
    // }
    
}


}
