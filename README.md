# RecipeBookApp

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange" />
  <img src="https://img.shields.io/badge/iOS-16.0+-blue" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
</p>

<p align="center">
  <b>Flavours at Your Fingertips</b><br/>
  Discover, cook, and save your favorite recipes with a beautiful, modern iOS app.
</p>

---

## 🚀 Overview
RecipeBookApp is a modern iOS application designed to help users discover, cook, and manage recipes. With a sleek interface, onboarding experience, and robust features, it makes culinary exploration delightful and easy.

---

## 🛠️ Technology Stack
- **Language:** Swift 5
- **UI Framework:** UIKit, Storyboards, XIBs
- **Architecture:** MVC (Model-View-Controller)
- **Networking:** URLSession, Codable, REST API (TheMealDB)
- **Persistence:** UserDefaults (for Favorites)
- **Image Loading:** [Kingfisher](https://github.com/onevcat/Kingfisher)
- **HUD/Loading:** [ProgressHUD](https://github.com/relatedcode/ProgressHUD)
- **Custom UI:** Custom CollectionView & TableView cells, CardView, Onboarding slides

---

## 📱 Technical Features
- **Onboarding Flow:** Engaging multi-slide onboarding with custom illustrations and smooth transitions.
- **Home Screen:** Browse food categories, popular dishes, and special dishes with interactive collection views.
- **Dish Listing:** View all dishes in a selected category with images and key info.
- **Dish Detail:** See detailed info, ingredients, measures, instructions, and watch YouTube tutorials. Share recipes or open video links directly.
- **Favorites:** Add/remove dishes to your favorites, with persistent storage and a dedicated favorites screen.
- **Networking:** Robust API integration with TheMealDB, error handling, and async data loading.
- **Modern UI/UX:** Custom card views, shadow effects, smooth loading indicators, and empty state handling.
- **Reusable Components:** Modular custom cells and views for easy extension.

---

## 🖼️ Screenshots
<p align="center">
 <img width="200" height="450" alt="1" src="https://github.com/user-attachments/assets/808bb892-d987-481d-9040-b123e138880f" />
 <img width="200" height="450" alt="1" src="https://github.com/user-attachments/assets/808bb892-d987-481d-9040-b123e138880f" />
 <img width="200" height="450" alt="2" src="https://github.com/user-attachments/assets/4df12e9f-a433-41cb-b969-d3961c9feae3" />
 <img width="200" height="450" alt="3" src="https://github.com/user-attachments/assets/b03569e1-d7fe-4006-8ffc-49a141ac3c89" />
 <img width="200" height="450" alt="4" src="https://github.com/user-attachments/assets/be5c8c91-0163-4741-8569-8eeb489d7c59" />
 <img width="200" height="450" alt="6" src="https://github.com/user-attachments/assets/e4cab376-7e95-4ed6-bfa8-8d219b123df8" />
 <img width="200" height="450" alt="7" src="https://github.com/user-attachments/assets/bfdc8cf1-4bf1-415f-8555-a735ac2f49fe" />
 <img width="200" height="450" alt="8" src="https://github.com/user-attachments/assets/a35754d5-1e52-4677-b583-bae7ca146fd0" />
</p>

---

## 📂 Project Structure
- **AppDelegate.swift**: App configuration and UI customization.
- **Models/**: Data models for dishes, categories, favorites, onboarding, and API responses.
- **Views/**: Home, List, Detail, Favorites, and Onboarding screens.
- **CustomViews/**: Custom collection/table view cells and CardView.
- **Networking/**: API integration, error handling, and data fetching.
- **Extensions/**: Utility extensions for String, UIViewController, etc.

---

## 📦 Dependencies
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Fast image downloading & caching.
- [ProgressHUD](https://github.com/relatedcode/ProgressHUD) - Modern loading indicators and feedback.

---

## 🚦 Getting Started
1. Clone the repository.
2. Open the project in Xcode.
3. Install dependencies:
   ```bash
   pod install
   ```
4. Open `RecipeBookApp.xcworkspace` and run on your device or simulator.

---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## 📢 Attribution
This app uses TheMealDB API for recipe content.  
Data © [TheMealDB](https://www.themealdb.com/) - Used under terms of use.



# Privacy Policy

RecipeBookApp does not collect, store, or share any personal information.

The app fetches recipe data from a third-party public API (TheMealDB), and displays content for user convenience. No user data is sent or stored by the app itself.

For any questions, please contact [your email here].


---

## 📄 License
This project is licensed under the MIT License.

