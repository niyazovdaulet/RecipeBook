//
//  ListFavoritesViewController.swift
//  RecipeBookApp
//
//  Created by Daulet on 31/10/2023.
//

import UIKit
import ProgressHUD

class ListFavoritesViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites: [Favorite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        registerCells()
        
        ProgressHUD.animate(symbol: "slowmo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkService.shared.fetchFavorites { [weak self] (result) in
            switch result {
            case .success(let favorites):
                ProgressHUD.dismiss()
                
                self?.favorites = favorites
                self?.tableView.reloadData()
            case .failure(let error):
                ProgressHUD.error(error.localizedDescription)
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: DishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifier)
    }
}

extension ListFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifier) as! DishListTableViewCell
        cell.setup(favorite: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instiatiate()
        controller.dish = favorites[indexPath.row].dish
        navigationController?.pushViewController(controller, animated: true)
    }
}
