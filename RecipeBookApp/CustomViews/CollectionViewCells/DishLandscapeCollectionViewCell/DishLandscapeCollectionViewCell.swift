//
//  DishLandscapeCollectionViewCell.swift
//  RecipeBookApp
//
//  Created by Daulet on 30/10/2023.
//

import UIKit
import Kingfisher

class DishLandscapeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: DishLandscapeCollectionViewCell.self)
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    

    func setup (dish: Dish) {
        dishImageView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
        ingredientsLbl.text = dish.ingredients?.joined(separator: "\n")
        originLbl.text = dish.origin
    }

}
