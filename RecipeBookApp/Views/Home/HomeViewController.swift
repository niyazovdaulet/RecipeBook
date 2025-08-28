
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
        

        
        // Debug scroll view setup
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            print("📱 Found scroll view: \(scrollView)")
        }
        
        registeCells()
        
        ProgressHUD.animate(symbol: "slowmo")
        showBlockingView()
        
        // Load data in proper sequence: categories first, then popular/specials
        loadAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        // Force layout update when returning to this view
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        // Force collection views to reload if they have data
        if !categories.isEmpty {
            print("🔄 Reloading category collection view")
            categoryCollectionView.reloadData()
        }
        if !populars.isEmpty {
            print("🔄 Reloading popular collection view")
            popularCollectionView.reloadData()
        }
        if !specials.isEmpty {
            print("🔄 Reloading specials collection view")
            specialsCollectionView.reloadData()
        }
        
        // Force layout update and collection view layout invalidation
        view.layoutIfNeeded()
        
        // Reset collection view layouts to fix any sizing issues
        resetCollectionViewLayouts()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        // Check collection view layout item sizes
        if let categoryLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        }
        if let popularLayout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        }
        if let specialsLayout = specialsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        }
        
        // Force collection view layout updates
        categoryCollectionView.collectionViewLayout.invalidateLayout()
        popularCollectionView.collectionViewLayout.invalidateLayout()
        specialsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Navigation Lifecycle
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Force layout update during transition
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // Reset layouts after transition
            self.resetCollectionViewLayouts()
        })
    }
    
    private func resetCollectionViewLayouts() {
        
        // Invalidate all collection view layouts
        categoryCollectionView.collectionViewLayout.invalidateLayout()
        popularCollectionView.collectionViewLayout.invalidateLayout()
        specialsCollectionView.collectionViewLayout.invalidateLayout()
        
        // Force immediate layout update
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // Force collection view layout updates
        categoryCollectionView.setNeedsLayout()
        popularCollectionView.setNeedsLayout()
        specialsCollectionView.setNeedsLayout()
        
        categoryCollectionView.layoutIfNeeded()
        popularCollectionView.layoutIfNeeded()
        specialsCollectionView.layoutIfNeeded()
        
        // Reload data to ensure proper cell sizing
        if !categories.isEmpty {
            categoryCollectionView.reloadData()
        }
        if !populars.isEmpty {
            popularCollectionView.reloadData()
        }
        if !specials.isEmpty {
            specialsCollectionView.reloadData()
        }
        
        // Force another layout update after reload
        DispatchQueue.main.async { [weak self] in
            self?.view.layoutIfNeeded()
            self?.categoryCollectionView.layoutIfNeeded()
            self?.popularCollectionView.layoutIfNeeded()
            self?.specialsCollectionView.layoutIfNeeded()
        }
        
    }
    
    private func loadAllData() {
        let loadingStart = Date()
        
        // First fetch categories
        fetchCategories { [weak self] in
            guard let self = self else { return }

            
            // Then fetch popular and special dishes using a more efficient method
            self.fetchPopularsAndSpecialsEfficient { [weak self] in
                guard let self = self else { return }
                
                let elapsed = Date().timeIntervalSince(loadingStart)
                let delay = max(0, 2.5 - elapsed) // Ensure minimum 2.5 second delay
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    ProgressHUD.dismiss()
                    self.hideBlockingView()
                    
                    // Force layout update
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // More efficient method to fetch popular and special dishes
    private func fetchPopularsAndSpecialsEfficient(completion: @escaping () -> Void) {
        
        // Use a few popular categories to get dishes instead of all categories
        let popularCategories = ["Chicken", "Beef", "Seafood", "Dessert"]
        let group = DispatchGroup()
        var allDishes: [Dish] = []
        var errors: [Error] = []
        
        for (index, categoryName) in popularCategories.enumerated() {
            group.enter()
            
            // Add staggered delay to prevent rate limiting
            let delay = Double(index) * 0.8 // 800ms between requests
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                print("🌐 Fetching dishes for category: \(categoryName) after \(delay)s delay")
                NetworkService.shared.fetchCategoryDishes(category: categoryName) { result in
                    switch result {
                    case .success(let dishes):
                        allDishes.append(contentsOf: dishes)
                    case .failure(let error):
                        print("❌ Failed to fetch dishes for category '\(categoryName)': \(error)")
                        errors.append(error)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            let shuffled = allDishes.shuffled()
            self?.populars = Array(shuffled.prefix(10))
            self?.specials = Array(shuffled.dropFirst(10).prefix(10))
            
            self?.popularCollectionView.reloadData()
            self?.specialsCollectionView.reloadData()
            
            completion()
        }
    }
    
    func showBlockingView() {
        let blocker = UIView(frame: view.bounds)
        blocker.backgroundColor = UIColor.clear // Completely transparent
        blocker.isUserInteractionEnabled = false // Don't block touches
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
                print("❌ Failed to fetch categories: \(error)")
                ProgressHUD.error(error.localizedDescription)
            }
            completion()
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int
        switch collectionView {
        case categoryCollectionView:
            count = categories.count
        case popularCollectionView:
            count = populars.count
        case specialsCollectionView:
            count = specials.count
        default:
            count = 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            let category = categories[indexPath.row]
            cell.setup(category: category)
            return cell
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifier, for: indexPath) as! DishPortraitCollectionViewCell
            let dish = populars[indexPath.row]
            cell.setup(dish: dish)
            return cell
        case specialsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishLandscapeCollectionViewCell.identifier, for: indexPath) as! DishLandscapeCollectionViewCell
            let dish = specials[indexPath.row]
            cell.setup(dish: dish)
            return cell
        default: 
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView:
            return CGSize(width: 128, height: 128)
        case popularCollectionView:
            return CGSize(width: 158, height: 295)
        case specialsCollectionView:
            return CGSize(width: 330, height: 94)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing: CGFloat) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case categoryCollectionView:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
        case popularCollectionView:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
        case specialsCollectionView:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            let controller = ListDishesViewController.instantiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = DishDetailViewController.instantiate()
            let selectedDish = collectionView == popularCollectionView ? populars[indexPath.row] : specials[indexPath.row]
            controller.dish = selectedDish
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
