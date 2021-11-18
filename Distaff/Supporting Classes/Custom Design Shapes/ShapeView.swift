//
//  ShapeView.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 05/02/16.
//
//

import Foundation
import UIKit

@IBDesignable open class ShapeView: UIView, ShapeDesignable {
    

    
    @IBInspectable open var strokeColor: UIColor = UIColor.black
    @IBInspectable open var scaling: Double = 1.0
    @IBInspectable open var strokeWidth: CGFloat = 1.0

    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        config()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    open func config() {
        //To be subclassed
    }
    
    
}
