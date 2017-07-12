//
//  TransacionTextField.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class TransacionTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 10, y: center.y)
        animation.toValue = CGPoint(x: center.x + 10, y: center.y)
        layer.add(animation, forKey: "position")
    }

}
