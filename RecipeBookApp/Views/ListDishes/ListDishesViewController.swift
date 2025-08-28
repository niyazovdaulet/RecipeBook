import UIKit
import ProgressHUD

class ListDishesViewController: UIViewController {
    
    var category: DishCategory!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dishes: [Dish] = []
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.name
        registerCells()
        
        loadDishes()
    }
    
    private func loadDishes() {
        guard !isLoading else { return }
        isLoading = true
        
        ProgressHUD.animate(symbol: "slowmo")
        
        NetworkService.shared.fetchCategoryDishes(category: category.name ?? "") { [weak self] result in
            self?.isLoading = false
            ProgressHUD.dismiss()
            
            switch result {
            case .success(let dishes):
                self?.dishes = dishes
                self?.tableView.reloadData()
                
                if dishes.isEmpty {
                    ProgressHUD.error("No dishes found for this category")
                }
                
            case .failure(let error):
                print("❌ Failed to fetch dishes: \(error)")
                
                // Show retry option for rate limit errors
                if let appError = error as? AppError, 
                   case .serverError(let message) = appError,
                   message.contains("429") {
                    ProgressHUD.error("Rate limit exceeded. Please try again in a moment.")
                    
                    // Add retry button to navigation bar
                    self?.addRetryButton()
                } else {
                    ProgressHUD.error(error.localizedDescription)
                }
            }
        }
    }
    
    private func addRetryButton() {
        let retryButton = UIBarButtonItem(
            title: "Retry",
            style: .plain,
            target: self,
            action: #selector(retryButtonTapped)
        )
        navigationItem.rightBarButtonItem = retryButton
    }
    
    @objc private func retryButtonTapped() {
        navigationItem.rightBarButtonItem = nil
        loadDishes()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: DishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifier)
    }
}

extension ListDishesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        }
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifier) as! DishListTableViewCell
        cell.setup(dish: dishes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instantiate()
        controller.dish = dishes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLoading {
            let loadingView = UIView()
            loadingView.backgroundColor = .clear
            
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            loadingView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 50)
            ])
            
            return loadingView
        }
        
        if dishes.isEmpty && !isLoading {
            let emptyView = UIView()
            emptyView.backgroundColor = .clear
            
            let label = UILabel()
            label.text = "No dishes found for this category"
            label.textAlignment = .center
            label.textColor = .systemGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            emptyView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 50)
            ])
            
            return emptyView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isLoading || dishes.isEmpty {
            return 100
        }
        return 0
    }
}
