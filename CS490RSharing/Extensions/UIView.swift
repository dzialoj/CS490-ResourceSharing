//
//  UIView.swift
//  CS490RSharing
//
//  Created by Jonathan G. Dzialo on 3/13/19.
//  Copyright © 2019 Group6. All rights reserved.
//

import UIKit

extension UIView {
    
    func smoothRoundCorners(to radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: radius
            ).cgPath
        
        layer.mask = maskLayer
}
}
