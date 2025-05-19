//
//  DishDetailViewController.swift
//  RecipeBookApp
//
//  Created by Daulet on 30/10/2023.
//

import UIKit
import Kingfisher
import ProgressHUD

class DishDetailViewController: UIViewController {

    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var dish: Dish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
        updateFavoriteButtonState()
    }
    
    private func populateView() {
        imagView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
        descriptionLbl.text = dish.description
        caloriesLbl.text = dish.formattedcalories
    }
    
    private func updateFavoriteButtonState() {
        let isFavorite = FavoritesManager.shared.isFavorite(dishId: dish.id ?? "")
        favoriteButton.setTitle(isFavorite ? "Remove from Favorites" : "Add to Favorites", for: .normal)
        favoriteButton.backgroundColor = isFavorite ? .systemRed : .systemGray
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if FavoritesManager.shared.isFavorite(dishId: dish.id ?? "") {
            // Remove from favorites
            FavoritesManager.shared.removeFavorite(dishId: dish.id ?? "")
            ProgressHUD.succeed("Removed from Favorites")
        } else {
            // Add to favorites
            FavoritesManager.shared.addFavorite(dish: dish)
            ProgressHUD.succeed("Added to Favorites")
        }
        updateFavoriteButtonState()
    }
}
