
import UIKit

class DishPortraitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DishPortraitCollectionViewCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        
        // Reset cell state
        titleLbl.text = nil
        dishImageView.image = nil
        originLbl.text = nil
        ingredientsLbl.text = nil
        
        // Reset image view constraints and sizing
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        
        // Reset label visibility and constraints
        titleLbl.isHidden = false
        originLbl.isHidden = false
        ingredientsLbl.isHidden = false
        
        // Ensure proper cell sizing
        contentView.frame = bounds
        
        // Reset any custom constraints or transforms
        dishImageView.transform = .identity
        titleLbl.transform = .identity
        originLbl.transform = .identity
        ingredientsLbl.transform = .identity
        

    }
    
    func setup(dish: Dish) {

        
        // Ensure proper image view setup
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        dishImageView.layer.cornerRadius = 5
        dishImageView.layer.masksToBounds = true
        
        // Ensure labels are visible and properly configured
        titleLbl.isHidden = false
        originLbl.isHidden = false
        ingredientsLbl.isHidden = false
        
        // Reset any transforms that might have been applied
        dishImageView.transform = .identity
        titleLbl.transform = .identity
        originLbl.transform = .identity
        ingredientsLbl.transform = .identity
        
        // Set content
        titleLbl.text = dish.name
        dishImageView.kf.setImage(with: dish.image?.asUrl)
        originLbl.text = dish.origin
        ingredientsLbl.text = dish.ingredients?.joined(separator: "\n")
        
        // Ensure proper cell sizing
        contentView.frame = bounds
        
        // Force layout update
        setNeedsLayout()
        layoutIfNeeded()
        

    }

}
