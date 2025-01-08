//
//  OnboardingCollectionViewCell.swift
//  RecipeBookApp
//
//  Created by Daulet on 25/10/2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var slideTitile: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    
    func setup( slide: OnboardingSlide) {
        slideImage.image = slide.image
        slideTitile.text = slide.title
        slideDescription.text = slide.description
    }
    
}
