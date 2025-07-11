# RecipeBookApp

## Overview
RecipeBookApp is an iOS application designed to help users discover and manage recipes. The app provides a user-friendly interface to browse different categories of dishes, view popular and special recipes, and save favorite dishes for quick access.

## Features
- **Home Screen**: Displays categories, popular dishes, and special dishes using collection views.
- **Dish Listing**: Shows a list of dishes within a selected category.
- **Dish Detail**: Provides detailed information about a dish, including its image, name, description, and calorie count.
- **Favorites**: Allows users to add dishes to their favorites and view them later.
- **Onboarding**: Introduces users to the app with a series of informative slides.

## Screenshots

### Onboarding Experience
![Home Screen]
<img width="300" height="624" alt="1" src="https://github.com/user-attachments/assets/808bb892-d987-481d-9040-b123e138880f" />
*Welcome to RecipeBookApp - Home Screen*

<img width="298" height="626" alt="2" src="https://github.com/user-attachments/assets/4df12e9f-a433-41cb-b969-d3961c9feae3" />
<img width="296" height="626" alt="3" src="https://github.com/user-attachments/assets/b03569e1-d7fe-4006-8ffc-49a141ac3c89" />
<img width="297" height="623" alt="4" src="https://github.com/user-attachments/assets/be5c8c91-0163-4741-8569-8eeb489d7c59" />
<img width="300" height="620" alt="6" src="https://github.com/user-attachments/assets/e4cab376-7e95-4ed6-bfa8-8d219b123df8" />
<img width="303" height="623" alt="7" src="https://github.com/user-attachments/assets/bfdc8cf1-4bf1-415f-8555-a735ac2f49fe" />
<img width="308" height="622" alt="8" src="https://github.com/user-attachments/assets/a35754d5-1e52-4677-b583-bae7ca146fd0" />


## Project Structure
- **AppDelegate.swift**: Sets up the app's main configuration, including UI customization.
- **Info.plist**: Contains app metadata and configuration settings.
- **Models**:
  - `Dish.swift`: Represents a dish with properties like id, name, description, image, and calories.
  - `DishCategory.swift`: Represents a category of dishes.
  - `AllDishes.swift`: Contains collections of categories, popular dishes, and special dishes.
  - `Favorite.swift`: Represents a favorite dish.
  - `OnboardingSlide.swift`: Represents a slide in the onboarding process.
- **Views**:
  - **Home**: Contains the main screen with categories, popular dishes, and special dishes.
  - **ListDishes**: Displays a list of dishes within a selected category.
  - **DishDetail**: Shows detailed information about a dish.
  - **ListFavorites**: Displays the user's favorite dishes.
  - **Onboarding**: Introduces users to the app with informative slides.
- **CustomViews**:
  - **CollectionViewCells**: Custom cells for displaying categories and dishes in collection views.
  - **TableViewCells**: Custom cells for displaying dishes in table views.
  - **CardView**: A custom view for displaying cards with shadow effects.

## Networking
- **NetworkService.swift**: Handles API requests and data fetching, including fetching categories, dishes, and favorites.

## Dependencies
- **Kingfisher**: Used for image loading and caching.
- **ProgressHUD**: Used for displaying loading indicators and success/error messages.

## Getting Started
1. Clone the repository.
2. Open the project in Xcode.
3. Install the required dependencies using CocoaPods:
   ```bash
   pod install
   ```
4. Build and run the app on your iOS device or simulator.

