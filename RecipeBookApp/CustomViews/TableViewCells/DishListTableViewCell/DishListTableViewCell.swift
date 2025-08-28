

import UIKit

class DishListTableViewCell: UITableViewCell {
    
    static let identifier = "DishListTableViewCell"
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    
    func setup (dish: Dish) {
        dishImageView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
        ingredientsLbl?.text = dish.ingredients?.joined(separator: "\n")
    }
    
    func setup(favorite: Favorite) {
        dishImageView.kf.setImage(with: favorite.dish?.image?.asUrl)
        titleLbl.text = favorite.dish?.name
    }
}
