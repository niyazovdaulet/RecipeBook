//
//  CategoryCollectionViewCell.swift
//  RecipeBookApp
//
//  Created by Daulet on 26/10/2023.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    func setup(category: DishCategory) {
        categoryTitleLbl.text = category.name
        categoryImageView.kf.setImage(with: category.image?.asUrl)
    }
}
