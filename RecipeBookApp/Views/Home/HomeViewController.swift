//
//  HomeViewController.swift
//  RecipeBookApp
//
//  Created by Daulet on 26/10/2023.
//

import UIKit
import ProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var specialsCollectionView: UICollectionView!
    
    
    
    var categories: [DishCategory] = [
//        .init(id: "id1", name: "African Dish", image: "https://picsum.photos/100/200"),
//        .init(id: "id1", name: "African Dish 2", image: "https://picsum.photos/100/200"),
//        .init(id: "id1", name: "African Dish 3", image: "https://picsum.photos/100/200"),
//        .init(id: "id1", name: "African Dish 4", image: "https://picsum.photos/100/200"),
//        .init(id: "id1", name: "African Dish 5", image: "https://picsum.photos/100/200")
    ]
    
    var populars: [Dish] = [
//        .init(id: "id1", name: "Garri", description: "This is the best I have ever tasted", image: "https://picsum.photos/100/200", calories: 46),
//        .init(id: "id1", name: "Iommie", description: "This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tasted,This is the best I have ever tastedThis is the best I have ever tastedThis is the best I have ever tastedThis is the best I have ever tastedThis is the best I have ever tasted", image: "https://picsum.photos/100/200", calories: 346),
//        .init(id: "id1", name: "Hawaii Pizza", description: "This is the best I have ever tasted", image: "https://picsum.photos/100/200", calories: 1204)
    ]
    
    var specials: [Dish]  = [
//        .init(id: "id1", name: "Goalie", description: "This is my  favorite dish", image: "https://picsum.photos/100/200", calories: 346),
//        .init(id: "id1", name: "Hawaii Moii", description: "This is the best I have ever tasted", image: "https://picsum.photos/100/200", calories: 1204)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specialsCollectionView.delegate = self
        specialsCollectionView.dataSource = self
         
        registeCells()
        
        ProgressHUD.animate(symbol: "slowmo")
        
        NetworkService.shared.fetchAllCategories { [weak self] (result) in
            switch result {
            case .success(let allDishes):
                ProgressHUD.dismiss()
                self?.categories = allDishes.categories ?? []
                self?.populars = allDishes.populars ?? []
                self?.specials = allDishes.specials ?? []
                
                self?.categoryCollectionView.reloadData()
                self?.popularCollectionView.reloadData()
                self?.specialsCollectionView.reloadData()
            case .failure(let error):
                ProgressHUD.error(error.localizedDescription)
                
            }
        }
        
    }
    
    
    private func registeCells() {
        categoryCollectionView.register(UINib(nibName: 
                                                CategoryCollectionViewCell.identifier, bundle: nil), 
                                                 forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        popularCollectionView.register(UINib(nibName:
                                                DishPortraitCollectionViewCell.identifier, bundle: nil), 
                                                forCellWithReuseIdentifier: DishPortraitCollectionViewCell.identifier)
        specialsCollectionView.register(UINib(nibName:
                                                DishLandscapeCollectionViewCell.identifier, bundle: nil),
                                                forCellWithReuseIdentifier: DishLandscapeCollectionViewCell.identifier)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView :
            return categories.count
        case popularCollectionView :
            return populars.count
        case specialsCollectionView :
            return specials.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case categoryCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case popularCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifier, for: indexPath) as! DishPortraitCollectionViewCell
            cell.setup(dish: populars[indexPath.row])
            return cell
        case specialsCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishLandscapeCollectionViewCell.identifier, for: indexPath) as! DishLandscapeCollectionViewCell
            cell.setup(dish: specials[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let controller = ListDishesViewController.instiatiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = DishDetailViewController.instiatiate()
            controller.dish = collectionView == popularCollectionView ? populars[indexPath.row] : specials[indexPath.row]
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
