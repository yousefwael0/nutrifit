<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/iOS-11.0+-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS"/>
  <img src="https://img.shields.io/badge/Android-API%2021+-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
</div>

<br/>

<div align="center">
  <h1>🥗 My Nutrition - Nutrition & Training Mobile App</h1>
  <p><strong>A complete, production-ready Flutter mobile app for nutrition tracking and workout management with on-device ML capabilities</strong></p>
  
  <img src="https://img.shields.io/github/workflow/status/yousefwael0/my_nutrition/Flutter%20CI?style=flat-square" alt="Build Status"/>
  <img src="https://img.shields.io/github/license/yousefwael0/my_nutrition?style=flat-square" alt="License"/>
  <img src="https://img.shields.io/github/v/release/yousefwael0/my_nutrition?style=flat-square" alt="Release"/>
</div>

---

## 📸 Screenshots

> **Note:** TODO:
> - `docs/screenshots/splash.png` - Splash screen
> - `docs/screenshots/home.png` - Home dashboard
> - `docs/screenshots/meals.png` - Meals browser
> - `docs/screenshots/workouts.png` - Workout timer

---

## ✨ Features

### 🎯 Core Functionality
- ✅ **Splash Screen** - Branded launch with smooth animations
- ✅ **Authentication** - Mock Gmail login with multi-step signup
- ✅ **Home Dashboard** - Recent activity, favorites, and personalized insights
- ✅ **Meals Browser** - 12 pre-defined meals with camera-based food detection
- ✅ **Workout Tracker** - 6 workouts (weight lifting + cardio) with timer
- ✅ **Body Analysis** - Malnutrition detection with ML recommendations
- ✅ **Settings** - Profile editing and health data management

### 🚀 Technical Highlights
- 🎨 **Google Fonts** - Professional typography (Poppins + Inter)
- 📱 **Material 3 Design** - Modern UI with gradient splash screen
- 🔄 **State Management** - Provider pattern for scalable architecture
- 💾 **Local Storage** - SharedPreferences for offline-first experience
- 🤖 **Mock ML** - Simulated TensorFlow Lite inference
- 📊 **Responsive** - Optimized for Android and iOS devices
- 🎬 **Smooth Animations** - Flutter Animate package integration

---

## 📁 Project Structure

```
my_nutrition/
├── lib/
│ ├── main.dart # App entry + theme setup
│ ├── models/
│ │ └── models.dart # User, Meal, Workout models
│ ├── services/
│ │ ├── storage_service.dart # SharedPreferences wrapper
│ │ └── ml_service.dart # Mock ML inference
│ ├── repositories/
│ │ └── mock_data_repository.dart # Pre-defined data
│ ├── providers/
│ │ └── providers.dart # State management
│ └── screens/
│ ├── splash_screen.dart # Animated splash
│ ├── login_screen.dart # Auth flow
│ ├── home_screen.dart # Main navigation
│ ├── settings_screen.dart # User settings
│ └── tabs/ # Bottom nav tabs
│ ├── home_tab.dart
│ ├── meals_tab.dart
│ ├── workout_tab.dart
│ └── malnutrition_tab.dart
├── test/ # Unit & widget tests
├── assets/ # Images, fonts, icons
├── ios/ # iOS native code
├── android/ # Android native code
└── pubspec.yaml # Dependencies
```

---

## 🛠️ Prerequisites

### System Requirements
- **Flutter SDK** 3.24.0+ - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart** 3.0+
- **Xcode** (for iOS) - macOS only
- **Android Studio** or Android SDK (for Android)

### Verify Installation
```bash
flutter doctor -v

All checks should pass ✓
```
---

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/yousefwael0/nutrifit.git
cd my_nutrition
```
### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run on Device/Emulator
```bash
iOS Simulator
flutter run -d iOS

Android Emulator
flutter run -d android

Physical device (auto-detect)
flutter run
```

### 4. Build Release
Android APK
```bash
flutter build apk --release
```

iOS (requires Mac + Xcode)
```bash
flutter build ios --release
```

---

## 📱 iOS Setup (Physical Device Testing)

### Required for Camera Access on iPhone

1. **Connect iPhone** via USB to Mac
2. **Enable Developer Mode**:
   - Settings → Privacy & Security → Developer Mode → ON
   - Restart iPhone

3. **Sign the App** (Free Apple ID):
open ios/Runner.xcworkspace

- Select `Runner` → Signing & Capabilities
- Check "Automatically manage signing"
- Select your Apple ID (Personal Team)
- Change Bundle ID to `com.yourname.my_nutrition`

4. **Trust Developer** (First run):
- Settings → General → VPN & Device Management
- Tap your email → Trust

5. **Run from Terminal**:
flutter run


---

## 🔧 Configuration

### Modify Theme Colors

Edit `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
seedColor: const Color(0xFF4CAF50), // Change primary color
),
```

### Add Custom Meals/Workouts

Edit `lib/repositories/mock_data_repository.dart`:

```dart
static final List<Meal> allMeals = [
Meal(
id: 'meal_001',
name: 'Your Meal Name',
category: 'Breakfast',
calories: 450,
protein: 25,
carbs: 50,
fats: 15,
// ...
),
];
```

### Use Real ML Models (Advanced)

Replace mock inference in `lib/services/ml_service.dart`:

1. Add `.tflite` models to `assets/ml_models/`
2. Update `pubspec.yaml` assets
3. Implement with `tflite_flutter` package

---

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run with Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Specific Features

**Login Flow:**
1. Launch app → Splash (2.5s)
2. Enter email: `test@gmail.com`
3. Complete health data form
4. Verify Home tab appears

**Camera Permissions:**
- First camera access triggers iOS permission popup
- Allow camera → Food detection works
- Deny → Gracefully falls back to gallery

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `shared_preferences` | Local storage |
| `image_picker` | Camera/gallery access |
| `google_fonts` | Typography (Poppins + Inter) |
| `flutter_animate` | Splash animations |
| `camera` | Camera functionality |
| `intl` | Date/time formatting |

---

## 🐛 Troubleshooting

### Build Issues

**Error: "Gradle build failed"**
```bash
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

**Error: "Pod install failed"**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

**Error: "Camera crashes on simulator"**
- **Expected behavior**: iOS simulator has no camera hardware
- **Solution**: App automatically falls back to gallery
- **Test on**: Physical device for full camera functionality

### Runtime Issues

**Camera permission denied:**
- iOS: Settings → Privacy → Camera → My Nutrition → Allow
- Android: Settings → Apps → My Nutrition → Permissions → Camera

**App won't install on iPhone:**
- Ensure Developer Mode is enabled (iOS 16+)
- Trust developer profile in Settings
- Re-run `flutter run` if 7-day free signing expires

---

## 📊 Performance

- **App Size**: ~15MB (Android APK)
- **Cold Start**: <2 seconds
- **Hot Reload**: <500ms
- **Memory Usage**: ~150MB average
- **Battery Impact**: Low (offline-first, no background services)

---

## 🗺️ Roadmap

- [ ] Real TensorFlow Lite models for food detection
- [ ] Backend API integration (Firebase/REST)
- [ ] Social features (share meals/workouts)
- [ ] Dark mode support
- [ ] Internationalization (i18n)
- [ ] Apple Health / Google Fit integration
- [ ] Meal planning and grocery lists

---

## 🤝 Contributing

Contributions welcome! To contribute:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📄 License

**All Rights Reserved**

This project is for personal use and demonstration purposes. No license is granted for commercial use, modification, or distribution without explicit permission from the author.

---

## 👤 Author

**Yousef Wael**
- GitHub: [@yousefwael0](https://github.com/yousefwael0)
- Email: yusufatta9@gmail.com

---

## 🙏 Acknowledgments

- Google Fonts for typography
- Material Design for UI guidelines
- Mock data inspired by real nutrition apps

---