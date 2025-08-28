
import UIKit
import Kingfisher
import ProgressHUD
import SafariServices

// MARK: - UIFont Extension
extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

class DishDetailViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var measuresLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    
    var dish: Dish!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        styleImageView()
        styleButton()
        styleTitleLabel()
        styleLabels() // Call styleLabels here as well
        populateView() // Populate view directly with existing dish data
        updateFavoriteButtonState()
    }
    
    private func setupNavigationBar() {
        // Create share button
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        // Create YouTube button
        let youtubeButton = UIBarButtonItem(
            image: UIImage(systemName: "play.rectangle"),
            style: .plain,
            target: self,
            action: #selector(youtubeButtonTapped)
        )
        
        // Add buttons to navigation bar
        navigationItem.rightBarButtonItems = [shareButton, youtubeButton]
    }
    
    @objc private func shareButtonTapped() {
        guard let dish = dish else { return }
        
        var shareItems: [Any] = []
        
        // Add dish name
        if let name = dish.name {
            shareItems.append("Check out this recipe: \(name)")
        }
        
        // Add instructions if available
        if let instructions = dish.instructions, !instructions.isEmpty {
            shareItems.append("\nInstructions:\n\(instructions)")
        }
        
        // Add YouTube link if available
        if let youtubeUrl = dish.youtubeUrl, !youtubeUrl.isEmpty {
            shareItems.append("\nWatch the video: \(youtubeUrl)")
        }
        
        // Add image if available
        if let imageUrl = dish.image, let url = URL(string: imageUrl) {
            // Download image for sharing
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    shareItems.append(imageResult.image)
                    self.presentShareSheet(with: shareItems)
                case .failure(_):
                    self.presentShareSheet(with: shareItems)
                }
            }
        } else {
            presentShareSheet(with: shareItems)
        }
    }
    
    private func presentShareSheet(with items: [Any]) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            // For iPad, set the popover presentation controller
            if let popover = activityViewController.popoverPresentationController {
                popover.barButtonItem = self.navigationItem.rightBarButtonItems?.first
            }
            
            self.present(activityViewController, animated: true)
        }
    }
    
    @objc private func youtubeButtonTapped() {
        guard let dish = dish,
              let youtubeUrl = dish.youtubeUrl,
              !youtubeUrl.isEmpty,
              let url = URL(string: youtubeUrl) else {
            ProgressHUD.error("No YouTube video available for this recipe")
            return
        }
        
        // Open YouTube link in Safari
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
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
        titleLbl.font = UIFont.preferredFont(forTextStyle: .title1).withTraits(.traitBold)
        titleLbl.textColor = .label
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        titleLbl.setContentHuggingPriority(.required, for: .vertical)
        titleLbl.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func styleLabels() {
        // Style origin label
        originLbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        originLbl.textColor = .secondaryLabel
        
        // Style ingredients and measures labels
        ingredientsLbl.font = UIFont.preferredFont(forTextStyle: .body)
        ingredientsLbl.textColor = .label
        ingredientsLbl.numberOfLines = 0
        
        measuresLbl.font = UIFont.preferredFont(forTextStyle: .body)
        measuresLbl.textColor = .label
        measuresLbl.numberOfLines = 0
        
        // Style instructions label with custom paragraph style
        instructionsLbl.font = UIFont.preferredFont(forTextStyle: .body)
        instructionsLbl.textColor = .label
        instructionsLbl.numberOfLines = 0
        
        // Add line spacing to instructions
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        paragraphStyle.paragraphSpacing = 12.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
        
        instructionsLbl.attributedText = NSAttributedString(string: instructionsLbl.text ?? "", attributes: attributes)
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
        originLbl.text = dish.origin

        // Populate ingredients with custom header
        if let ingredients = dish.ingredients, !ingredients.isEmpty {
            let ingredientsText = "🧾 Ingredients\n" + ingredients.joined(separator: "\n")
            ingredientsLbl.text = ingredientsText
        } else {
            ingredientsLbl.text = "🧾 Ingredients\n-"
        }

        // Populate measures with custom header
        if let measures = dish.measures, !measures.isEmpty {
            let measuresText = "⚖️ Measures\n" + measures.joined(separator: "\n")
            measuresLbl.text = measuresText
        } else {
            measuresLbl.text = "⚖️ Measures\n-"
        }

        // Populate instructions with custom header and formatting
        if let instructions = dish.instructions, !instructions.isEmpty {
            let instructionsText = "👨‍🍳 Instructions\n\n\(instructions)"
            
            // Create attributed string with custom paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8.0
            paragraphStyle.paragraphSpacing = 12.0
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.preferredFont(forTextStyle: .body)
            ]
            
            instructionsLbl.attributedText = NSAttributedString(string: instructionsText, attributes: attributes)
        } else {
            instructionsLbl.text = "👨‍🍳 Instructions\n\n-"
        }
        
        // Apply styling after populating content
        styleLabels()
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
