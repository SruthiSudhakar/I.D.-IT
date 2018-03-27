//
//  MyButton.swift
//  FemmeHacks
//
//  Created by Sanjana Pruthi on 2/3/18.
//  Copyright © 2018 Sanjana Pruthi and Sruthi Sudhakar. All rights reserved.
//
import UIKit

//class MyButton: UIButton {
    @IBDesignable class MyButton: UIButton
    {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            updateCornerRadius()
        }
        
        @IBInspectable var rounded: Bool = false {
            didSet {
                updateCornerRadius()
            }
        }
        
        func updateCornerRadius() {
            layer.cornerRadius = rounded ? frame.size.height / 2.5 : 0
        }
    }

//}
