# Flutter Web Application

This is a Flutter web application designed to serve as a restaurant guide. It utilizes state management and provides a user-friendly interface for navigating through various features.

## Project Structure

```
flutter-web-app
├── lib
│   ├── main.dart             # Entry point of the application
│   ├── pages
│   │   └── home_page.dart    # Main content of the application
│   └── services
│       └── data_service.dart  # Handles data-related operations
├── web
│   ├── index.html            # Main HTML file for the web application
│   ├── favicon.ico           # Favicon for the web application
│   └── manifest.json         # Metadata for the web application
├── pubspec.yaml              # Configuration file for the Flutter project
└── README.md                 # Documentation for the project
```

## Getting Started

To run this application locally, follow these steps:

1. **Clone the repository:**
   ```
   git clone https://github.com/yourusername/flutter-web-app.git
   cd flutter-web-app
   ```

2. **Install dependencies:**
   ```
   flutter pub get
   ```

3. **Run the application:**
   ```
   flutter run -d chrome
   ```

## Deployment

To deploy the application on GitHub Pages, follow these steps:

1. Build the web application:
   ```
   flutter build web
   ```

2. Navigate to the `build/web` directory:
   ```
   cd build/web
   ```

3. Initialize a new Git repository (if not already done):
   ```
   git init
   ```

4. Add the GitHub repository as a remote:
   ```
   git remote add origin https://github.com/yourusername/flutter-web-app.git
   ```

5. Commit the build files:
   ```
   git add .
   git commit -m "Deploying Flutter web app"
   ```

6. Push to the `gh-pages` branch:
   ```
   git push -f origin master:gh-pages
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.