//
//  UiViewController.swift
//  RecipeBookApp
//
//  Created by Daulet on 30/10/2023.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instiatiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        return controller
    }
}
