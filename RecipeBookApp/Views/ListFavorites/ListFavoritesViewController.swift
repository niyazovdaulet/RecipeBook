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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func loadFavorites() {
        favorites = FavoritesManager.shared.getAllFavorites()
        tableView.reloadData()
        
        if favorites.isEmpty {
            // Show empty state message
            let messageLabel = UILabel()
            messageLabel.text = "No favorites yet. Add some dishes to your favorites!"
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.textColor = .gray
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let dishId = favorites[indexPath.row].dish?.id {
                FavoritesManager.shared.removeFavorite(dishId: dishId)
                favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if favorites.isEmpty {
                    loadFavorites() // This will show the empty state message
                }
            }
        }
    }
}
