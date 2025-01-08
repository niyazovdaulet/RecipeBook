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
    
    var dish: Dish!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        populateView()
    }
    

    private func populateView() {
        imagView.kf.setImage(with: dish.image?.asUrl)
        titleLbl.text = dish.name
        descriptionLbl.text = dish.description
        caloriesLbl.text = dish.formattedcalories
    }

    @IBAction func buttonPressed(_ sender: UIButton) {

        ProgressHUD.animate("Adding to Favorites...")
        NetworkService.shared.addFavorite(dishId: dish.id ?? "") { [weak self] (result) in
                ProgressHUD.succeed("Your favorite was added. 👨‍🍳")
            
        }
    }
}
