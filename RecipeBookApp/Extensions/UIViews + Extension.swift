//
//  UIViews + Extension.swift
//  RecipeBookApp
//
//  Created by Daulet on 25/10/2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
        
    }
}
