# Color Tap (Flutter)

A clean, modern, kid‑friendly **color matching game** built with Flutter and Material 3. 
The app is designed as a hands‑on exercise to master the **`Scaffold`** layout (AppBar, Drawer, FloatingActionButton, BottomAppBar, SnackBars, BottomSheet) while keeping the gameplay delightful and accessible.

---

## ✨ Highlights

* **Material 3** theme, responsive layout, English‑only UI.
* Core **Scaffold** pieces: `AppBar`, **Drawer** (Settings), **FAB** (Next), **BottomAppBar** (Round/Score), **SnackBar** (feedback), **Modal Bottom Sheet** (How to Play + Game Over).
* **Animations:** flip on correct, shake on wrong, large centered “Next” FAB.
* **Game flow:** 10 rounds, 1 point per correct round; Game Over summary with replay.
* **Accessibility:** optional tile labels (toggle in Drawer) to support pre‑readers and color‑blind friendly play.

---

## 🕹️ Gameplay

1. Read the **target color** shown at the top.
2. Tap the **matching color tile**.
3. Use **Next** to advance rounds. The game ends after **10 rounds**.
4. **Reset** clears score & round; **Hint** reveals the target color name.

**Settings (Drawer):**

* **Grid Size:** 6 tiles (3×2) or 9 tiles (3×3)
* **Show Labels on Tiles:** On/Off

---

## 📁 Project Structure

```
color_tap/
├─ lib/
│  └─ main.dart               # Single-file MVP implementation
├─ assets/                    # (optional) images, sounds
├─ android/                   # Android project (Kotlin)
├─ ios/                       # iOS project (optional)
├─ test/                      # (optional) widget tests
└─ README.md
```

> This repository currently ships a **single-file MVP** (`lib/main.dart`) for clarity. You can later split UI, models, and widgets (e.g., `widgets/color_tile.dart`, `screens/game_screen.dart`).

---

## 🚀 Getting Started

### Prerequisites

* Flutter **stable** (3.x) & Dart **3.x**
* Android Studio / VS Code with Flutter & Dart extensions
* Android SDK + emulator or a physical device

### Setup & Run

```bash
# clone
git clone https://github.com/<bektas-sari>/color_tap.git
cd color_tap

# fetch deps
flutter pub get

# run on a connected device / emulator
flutter run
```

### Build Release APK

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧱 Key Widgets & Concepts

* `Scaffold` with **centerFloat** **FloatingActionButton.large** (Next)
* `Drawer` for Settings, `BottomAppBar` for **Round/Score**
* Animated feedback: **flip** (correct) & **shake** (wrong)
* `SnackBar` (elevated, floating, prominent color)
* `showModalBottomSheet` for **How to Play** and **Game Over**

---

## 🗺️ Roadmap

* Color‑blind palettes (e.g., Deuteranopia‑friendly)
* Multiple difficulty levels & timers
* Sound FX & haptics (toggleable)
* Localization (i18n) & RTL support
* Separate files/components, unit & widget tests

---

## 🤝 Contributing

Pull requests are welcome. Please keep code style consistent with Flutter best practices (null‑safety, const constructors, meaningful keys, linting).

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 👤 Developer

**Bektaş Sarı**<br>
PhD in Advertising, AI + Creativity researcher<br>
Flutter Developer & Software Educator<br>

- **Email:** [bektas.sari@gmail.com](mailto:bektas.sari@gmail.com)  
- **GitHub:** [github.com/bektas-sari](https://github.com/bektas-sari)  
- **LinkedIn:** [linkedin.com/in/bektas-sari](https://www.linkedin.com/in/bektas-sari)  
- **Researchgate:** [researchgate.net/profile/Bektas-Sari-3](https://www.researchgate.net/profile/Bektas-Sari-3)  
- **Academia:** [independent.academia.edu/bektassari](https://independent.academia.edu/bektassari)
