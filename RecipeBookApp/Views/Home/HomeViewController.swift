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
    
    var categories: [DishCategory] = []
    var populars: [Dish] = []
    var specials: [Dish] = []
    
    private var blockingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           categoryCollectionView.delegate = self
           categoryCollectionView.dataSource = self
           popularCollectionView.delegate = self
           popularCollectionView.dataSource = self
           specialsCollectionView.delegate = self
           specialsCollectionView.dataSource = self
        
        registeCells()
        
        ProgressHUD.animate(symbol: "slowmo")
         showBlockingView()
         let loadingStart = Date()
         fetchCategories { [weak self] in
             let elapsed = Date().timeIntervalSince(loadingStart)
             let delay = max(0, 8.5 - elapsed)
             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                 ProgressHUD.dismiss()
                 self?.hideBlockingView()
                 // ... any UI updates after loading ...
             }
         }
//        fetchCategories()
        fetchPopularsAndSpecials()
    }
    
    func showBlockingView() {
        let blocker = UIView(frame: view.bounds)
        blocker.backgroundColor = UIColor(white: 0, alpha: 0.01) // almost transparent, but blocks touches
        blocker.isUserInteractionEnabled = true
        blocker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blocker)
        blockingView = blocker
    }
    func hideBlockingView() {
        blockingView?.removeFromSuperview()
        blockingView = nil
    }
    
    func fetchCategories(completion: @escaping () -> Void) {
        NetworkService.shared.fetchAllCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.categoryCollectionView.reloadData()
            case .failure(let error):
                ProgressHUD.error(error.localizedDescription)
            }
            completion()
        }
    }
    
    func fetchPopularsAndSpecials() {
        NetworkService.shared.fetchAllMealsFromAllCategories { [weak self] result in
            switch result {
            case .success(let allDishes):
                let shuffled = allDishes.shuffled()
                self?.populars = Array(shuffled.prefix(10))
                self?.specials = Array(shuffled.dropFirst(10).prefix(10))
                self?.popularCollectionView.reloadData()
                self?.specialsCollectionView.reloadData()
            case .failure(let error):
                ProgressHUD.error("Failed to load populars/specials: \(error.localizedDescription)")
            }
        }
    }
    
    private func registeCells() {
        categoryCollectionView.register(
            UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        popularCollectionView.register(
            UINib(nibName: DishPortraitCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: DishPortraitCollectionViewCell.identifier
        )
        specialsCollectionView.register(
            UINib(nibName: DishLandscapeCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: DishLandscapeCollectionViewCell.identifier
        )
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return categories.count
        case popularCollectionView:
            return populars.count
        case specialsCollectionView:
            return specials.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifier, for: indexPath) as! DishPortraitCollectionViewCell
            cell.setup(dish: populars[indexPath.row])
            return cell
        case specialsCollectionView:
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
