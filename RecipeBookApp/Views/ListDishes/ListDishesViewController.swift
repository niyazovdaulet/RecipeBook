import UIKit
import ProgressHUD

class ListDishesViewController: UIViewController {
    
    var category: DishCategory!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dishes: [Dish] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.name
        registerCells()
        
        ProgressHUD.animate(symbol: "slowmo")
//        print("Fetching dishes for category: \(category.name ?? "nil")")
        NetworkService.shared.fetchCategoryDishes(category: category.name ?? "") { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let dishes):
//                print("Fetched \(dishes.count) dishes for category \(self?.category.name ?? "")")
                self?.dishes = dishes
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch dishes: \(error)")
                ProgressHUD.error(error.localizedDescription)
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: DishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifier)
    }
}

extension ListDishesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifier) as! DishListTableViewCell
        cell.setup(dish: dishes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instiatiate()
        controller.dish = dishes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
