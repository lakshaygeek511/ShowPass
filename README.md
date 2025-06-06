# 🎟️ ShowPass - Movies App

![180](https://github.com/user-attachments/assets/6ed4ba6a-01b3-4e64-95bf-ba7fd858dbc5)
![Screenshot 2025-06-07 at 12 23 48 AM](https://github.com/user-attachments/assets/cb4b3236-d098-4604-94f9-ba8de01d1a49)



Welcome to **ShowPass**, a sleek and modern iOS app that helps you explore trending and now playing movies with ease. 
Powered by [TMDB API](https://developers.themoviedb.org/3), the app offers search, bookmarks, offline support, and much more — all packed in a clean Swift-based architecture! 🍿📱

---

## 🚀 Features

- 🔥 **Trending & Now Playing**: Browse the latest blockbusters and currently running hits.
- 🔍 **Live Search**: Instantly search movies with debounce delay — no buttons required!
- 📝 **Bookmark Movies**: Save your favorites and revisit them anytime.
- 📴 **Offline Mode**: Seamless offline experience using Core Data.
- 🧠 **Movie Details**: Dive into a detailed screen with full movie info.
- 🧾 **Pagination**: Smooth, endless scrolling where applicable.
- 🖼️ **Image Caching**: Optimized image performance using `NSCache`.

---

## 🏗️ Architecture

The app is built using **MVVM (Model-View-ViewModel)** pattern for maintainable and scalable code.

### 📦 Components
- `Model`: Decodable structures matching TMDB's JSON schema.
- `ViewModel`: Manages API requests, UI state, and data binding.
- `View`: SwiftUI/UIKit views rendering data from ViewModels.
- `Services`: Handles `URLSession` calls and response decoding.
- `Persistence`: Core Data layer for saving movie data locally.

---

## 🛠️ Tech Stack

| Feature              | Implementation                      |
|---------------------|--------------------------------------|
| Language            | Swift 🧑‍💻                           |
| Architecture        | MVVM 📐                              |
| Networking          | URLSession 🔌                        |
| JSON Decoding       | Swift Codable 🧩                    |
| Database            | Core Data 💾                         |
| Image Caching       | NSCache 🖼️                          |
| Pagination          | API-supported, ViewModel-managed     |

---

## 📲 Installation & Run

1. 📥 Clone or unzip the project or download and unzip the file.
2. 🧰 Open in **Xcode (v12 or later)**
