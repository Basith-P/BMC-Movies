# BMC Movies

This is a simple iOS application that allows users to discover movies using The Movie Database (TMDb) API. Users can browse now playing, popular, and top-rated movies, search for specific titles, and save their favorite movies for later.

## 🚀 How to Build and Run the Project

1.  **Clone the Repository**:
    ```bash
    git clone git@github.com:Basith-P/BMC-Movies.git
    ```
2.  **Open in Xcode**:
    - Navigate to the project directory and open the `BMC Movies.xcodeproj` file.
3.  **Configure TMDb Access Token via local Debug.xcconfig**:
    - Get your TMDb Access Token from [TMDb API](https://www.themoviedb.org/settings/api).
    - Create a local file at `BMC Movies/Config/Debug.xcconfig` with the following contents. This repository does not include this file; you must create it locally:
      ```xcconfig
      TMDB_ACCESS_TOKEN = <your_tmdb_access_token_here>
      ```
    - In Xcode, set the target's Debug “Base Configuration” to `BMC Movies/Config/Debug.xcconfig`.
    - At runtime, the app reads the token via `AppConfig.tmdbAccessToken` from the Info.plist key `TMDB_ACCESS_TOKEN`.
4.  **Build and Run**:
    - Select a simulator or a connected iOS device from the target menu in Xcode.
    - Press the **Run** button (or `Cmd+R`) to build and launch the application.

## 🏛️ Architecture

The project is built using the **MVVM (Model-View-ViewModel)** architecture with SwiftUI.

- **Model**: Represents the data and business logic of the application (e.g., `Movie`, `FavoriteMovie`). These are simple data structures that hold the movie information.
- **View**: The UI of the application, built entirely with SwiftUI (e.g., `HomePage`, `MovieDetailsPage`, `SearchPage`). The views are responsible for presenting the data and capturing user input. They observe the ViewModel for any state changes and update themselves accordingly.
- **ViewModel**: Acts as the intermediary between the Model and the View. It contains the presentation logic, manages the state of the view, and handles any user interactions. For example, `MoviesViewModel` is responsible for fetching movies from the API and managing the search results.

### Why MVVM?

- **Separation of Concerns**: This pattern provides a clean separation between the UI (View) and the business logic (ViewModel), making the codebase more modular, easier to understand, and maintain.
- **Testability**: The ViewModel can be tested independently of the UI, allowing for more robust unit tests.
- **Data Binding**: SwiftUI's declarative nature and powerful data-binding capabilities work seamlessly with the ViewModel, allowing the UI to reactively update whenever the underlying data changes.
