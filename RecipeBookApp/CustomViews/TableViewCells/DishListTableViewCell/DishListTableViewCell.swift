//
//  DishListTableViewCell.swift
//  RecipeBookApp
//
//  Created by Daulet on 30/10/2023.
//

import UIKit

class DishListTableViewCell: UITableViewCell {
    
    static let identifier = "DishListTableViewCell"
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func setup (dish: Dish) {
        dishImageView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
//        descriptionLbl.text = dish.descriptionX
    }
    
    func setup(favorite: Favorite) {
        dishImageView.kf.setImage(with: favorite.dish?.image?.asUrl)
        titleLbl.text = favorite.dish?.name
    }
}
