//
//  ShapeTypes.swift
//  Distaff
//
//  Created by Aman on 13/07/20.
//  Copyright © 2020 netset. All rights reserved.
//

import Foundation
import UIKit




enum ShapeTypes : String {
    case reactangle = "Reactangle"
    case circle = "Circle"
    case triangle = "Triangle"
    case star = "Star"
    case rhombus = "Rhombus"
    case hexagon = "Hexagon"
    case square = "Square"
    case rainBow = "Rainbow"
}

enum clothSizeTypes : String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

enum ShapeViewTags : Int {
    case normalShape = 15
    case pathShapes = 20
    
}



func configureCircleShape(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView  {
    let width = isForOutSideObject ?? false ? CGFloat(70): isForArms ?  CGFloat(40) : CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = UIView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.layer.cornerRadius = shapeView.frame.width / 2
    shapeView.tag = ShapeViewTags.normalShape.rawValue
    shapeView.borderColor = UIColor.red
    shapeView.borderWidth = 1.1
    shapeView.accessibilityHint = ShapeTypes.circle.rawValue
    return shapeView
}

func configureReactangleShape(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    let height = isForOutSideObject ?? false ? CGFloat(70) : isForArms ?  CGFloat(40) : CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let width = height / 1.5
    let shapeView = UIView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - height / 2, width: width, height: height)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.tag = ShapeViewTags.normalShape.rawValue
    shapeView.borderColor = UIColor.red
    shapeView.borderWidth = 1.1
    shapeView.accessibilityHint = ShapeTypes.reactangle.rawValue
    return shapeView
}

func configureSequareShape(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    let width = isForOutSideObject ?? false ? CGFloat(70) : isForArms ?  CGFloat(40): CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = UIView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.clipsToBounds = true
    shapeView.tag = ShapeViewTags.normalShape.rawValue
    shapeView.borderColor = UIColor.red
    shapeView.borderWidth = 1.1
    shapeView.accessibilityHint = ShapeTypes.square.rawValue
    return shapeView
}


func drawTriangle(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    
    let width = isForOutSideObject ?? false ? CGFloat(58) : isForArms ?  CGFloat(40) : CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = UIView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.tag = ShapeViewTags.pathShapes.rawValue
    shapeView.accessibilityHint = ShapeTypes.triangle.rawValue
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: shapeView.frame.width/2, y: 0.0))
    path.addLine(to: CGPoint(x: 0.0, y: shapeView.frame.size.height))
    path.addLine(to: CGPoint(x: shapeView.frame.size.width, y: shapeView.frame.size.height))
    path.close()
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = 1.1
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeView.layer.addSublayer(shapeLayer)
    return shapeView
}



func drawStar(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    
    let width = isForOutSideObject ?? false ? CGFloat(70) : isForArms ?  CGFloat(40): CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = StarView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.tag = ShapeViewTags.pathShapes.rawValue
    shapeView.fillColor = .clear
    shapeView.corners = 5
    shapeView.extrusionPercent = 33
    shapeView.shapeMask = false
    shapeView.strokeColor = UIColor.red
    shapeView.drawStar()
    shapeView.strokeWidth = 1.1
    shapeView.accessibilityHint = ShapeTypes.star.rawValue
    return  shapeView
}

func drawRhombusShape(availableView:UIView , isForHexagon:Bool,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    let width = isForOutSideObject ?? false ? CGFloat(70) : isForArms ?  CGFloat(40): CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = PolygonView()    // create UI
    shapeView.frame =  CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.tag = ShapeViewTags.pathShapes.rawValue
    if isForHexagon {
        shapeView.sides = 6
    }
    shapeView.fillColor = .clear
    shapeView.shapeMask = false
    shapeView.strokeColor = UIColor.red
    shapeView.drawPolygon()
    shapeView.strokeWidth = 1.1
    shapeView.accessibilityHint = isForHexagon ? ShapeTypes.hexagon.rawValue : ShapeTypes.rhombus.rawValue
    return  shapeView
}

func drawRainbowShape(availableView:UIView,size:clothSizeTypes,isForOutSideObject:Bool? = nil,isForArms:Bool) -> UIView {
    let width = isForOutSideObject ?? false ? CGFloat(64): isForArms ?  CGFloat(40) : CGFloat(availableView.frame.width - (size == .small ? 10 : size == .medium ? 20 : 30))
    let shapeView = UIView()    // create UI
    shapeView.frame = CGRect(x: ((availableView.frame.width ) / 2) - width / 2 , y: (availableView.frame.height / 2) - width / 2, width: width, height: width)
    shapeView.restorationIdentifier = RestorationIdentifer.shapeView
    shapeView.tag = ShapeViewTags.pathShapes.rawValue
    shapeView.accessibilityHint = ShapeTypes.rainBow.rawValue
    
    let path = UIBezierPath(arcCenter: CGPoint(x: shapeView.frame.size.width/2, y: shapeView.frame.size.height/2),
                            radius: shapeView.frame.size.height/2,
                            startAngle: CGFloat(3.14),
                            endAngle: CGFloat(0.0),
                            clockwise: true)
    path.close()
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = 1.1
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeView.layer.addSublayer(shapeLayer)
    return  shapeView
}






