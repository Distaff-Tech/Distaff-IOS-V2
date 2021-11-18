//
//  LabelSwitchState.swift
//  LabelSwitch
//
//  Created by cookie on 2018/7/28.
//

import Foundation
import UIKit

struct LabelSwitchPartState {
    var backMaskFrame: CGRect = CGRect.zero
}

struct LabelSwitchUIState {
    var backgroundColor: UIColor = .clear
    var circleFrame: CGRect = .zero
    var leftPartState  = LabelSwitchPartState()
    var rightPartState = LabelSwitchPartState()
}
