//
//  AppStructures.swift
//  Distaff
//
//  Created by netset on 13/01/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit

struct Settings {
    var title:String?
}

struct WebView {
    var title:String?
    var url:String
}


enum LogedInUserType:String {
    case facebook = "f"
    case instagram = "i"
    case gmail = "g"
    case apple = "ap"
    case normal = "e"
}

struct SocialInfo_User {
    var email:String? = nil
    var socialId:String? = nil
    var userName:String? = nil
    var fullName:String? = nil
    var profilePic:URL?
    var loginType:LogedInUserType? = nil
}


struct ColorScheme {
    var image:UIImage?
    var isSelected:Bool? = false
}

struct RecentShapeData {
    var selectedShapeIndex : Int? = nil
    var selectedBorderColorIndex:Int? = nil
    var selectedFillColorIndex:Int? = nil
    var shapeView:UIView? = nil
    var shapePrice:Double? = 0.0
}



