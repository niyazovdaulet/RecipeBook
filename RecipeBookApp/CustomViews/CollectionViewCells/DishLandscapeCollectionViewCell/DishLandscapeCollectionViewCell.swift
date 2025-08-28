
import UIKit
import Kingfisher

class DishLandscapeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: DishLandscapeCollectionViewCell.self)
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        
        // Reset cell state
        dishImageView.image = nil
        titleLbl.text = nil
        ingredientsLbl.text = nil
        originLbl.text = nil
        
        // Reset image view constraints and sizing
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        
        // Reset label visibility and constraints
        titleLbl.isHidden = false
        ingredientsLbl.isHidden = false
        originLbl.isHidden = false
        
        // Ensure proper cell sizing
        contentView.frame = bounds
        
        // Reset any custom constraints or transforms
        dishImageView.transform = .identity
        titleLbl.transform = .identity
        ingredientsLbl.transform = .identity
        originLbl.transform = .identity
        

    }
    
    func setup (dish: Dish) {

        
        // Ensure proper image view setup
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        dishImageView.layer.cornerRadius = 10
        dishImageView.layer.masksToBounds = true
        
        // Ensure labels are visible and properly configured
        titleLbl.isHidden = false
        ingredientsLbl.isHidden = false
        originLbl.isHidden = false
        
        // Reset any transforms that might have been applied
        dishImageView.transform = .identity
        titleLbl.transform = .identity
        ingredientsLbl.transform = .identity
        originLbl.transform = .identity
        
        // Set content
        dishImageView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
        ingredientsLbl.text = dish.ingredients?.joined(separator: "\n")
        originLbl.text = dish.origin
        
        // Ensure proper cell sizing
        contentView.frame = bounds
        
        // Force layout update
        setNeedsLayout()
        layoutIfNeeded()
        

    }

}
