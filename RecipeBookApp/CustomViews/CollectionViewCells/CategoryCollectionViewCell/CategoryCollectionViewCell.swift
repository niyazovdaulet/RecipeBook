import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    static let identifier = "CategoryCollectionViewCell"
    
    func setup(category: DishCategory) {
        
        categoryTitleLbl.text = category.name
        if let urlString = category.image, let url = URL(string: urlString) {
            categoryImageView.kf.setImage(with: url)
        } else {
            categoryImageView.image = UIImage(named: "default_image") // fallback
        }
    }
}
