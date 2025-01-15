import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    static let identifier = "CategoryCollectionViewCell"
    
    func setup(category: DishCategory) {
        print("Setting up category with name: \(category.name)")
        
        // Use nil-coalescing to provide a default value if category.image is nil
        let imageName = category.image ?? "default_image"
        categoryImageView.image = UIImage(named: imageName)
        
        categoryTitleLbl.text = category.name
    }
}
