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

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var dish: Dish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleImageView()
        styleButton()
        styleTitleLabel()
        fetchAndPopulateDish()
        updateFavoriteButtonState()
    }
    
    private func styleImageView() {
        imageContainerView.layer.cornerRadius = 22
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 0.15
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageContainerView.layer.shadowRadius = 16
        imageContainerView.layer.masksToBounds = false

        imagView.layer.cornerRadius = 22
        imagView.clipsToBounds = true
    }
    
    private func styleButton() {
        favoriteButton.layer.cornerRadius = 16
        favoriteButton.backgroundColor = UIColor.systemBlue
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOpacity = 0.10
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        favoriteButton.layer.shadowRadius = 8
        favoriteButton.layer.masksToBounds = false
    }
    
    private func styleTitleLabel() {
        titleLbl.font = UIFont.boldSystemFont(ofSize: 28)
        titleLbl.textColor = .label
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        titleLbl.setContentHuggingPriority(.required, for: .vertical)
        titleLbl.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func fetchAndPopulateDish() {
        guard let id = dish.id else { return }
        ProgressHUD.animate(symbol: "slowmo")
        NetworkService.shared.fetchMealDetails(mealId: id) { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let fullDish):
                self?.dish = fullDish
                self?.populateView()
            case .failure(let error):
                ProgressHUD.error(error.localizedDescription)
            }
        }
    }
    
    private func populateView() {
        imagView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name

        // Split description into ingredients and instructions
        let description = dish.description ?? ""
        let components = description.components(separatedBy: "Instructions:")
        let ingredients = components.first?.replacingOccurrences(of: "Ingredients:", with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let instructions = components.count > 1 ? components[1].trimmingCharacters(in: .whitespacesAndNewlines) : ""

        let attributedText = NSMutableAttributedString()

        // Ingredients header
        let ingredientsHeader = NSAttributedString(
            string: "🍱 Ingredients\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedText.append(ingredientsHeader)

        // Ingredients body
        let ingredientsBody = NSAttributedString(
            string: ingredients + "\n\n",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        )
        attributedText.append(ingredientsBody)

        // Instructions header
        let instructionsHeader = NSAttributedString(
            string: "📝 Instructions\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedText.append(instructionsHeader)

        // Instructions body
        let instructionsBody = NSAttributedString(
            string: instructions,
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        )
        attributedText.append(instructionsBody)

        descriptionLbl.attributedText = attributedText
    }
    
    private func updateFavoriteButtonState() {
        let isFavorite = FavoritesManager.shared.isFavorite(dishId: dish.id ?? "")
        favoriteButton.setTitle(isFavorite ? "Remove from Favorites" : "Add to Favorites", for: .normal)
        favoriteButton.backgroundColor = isFavorite ? .systemRed : .systemGreen
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if FavoritesManager.shared.isFavorite(dishId: dish.id ?? "") {
            // Remove from favorites
            FavoritesManager.shared.removeFavorite(dishId: dish.id ?? "")
            ProgressHUD.error("Removed from Favorites")
        } else {
            // Add to favorites
            FavoritesManager.shared.addFavorite(dish: dish)
            ProgressHUD.succeed("Added to Favorites")
            
        }
        updateFavoriteButtonState()
    }
}
