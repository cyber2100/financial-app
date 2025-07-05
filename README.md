// File: README.md - Project Documentation
# Financial Portfolio App

A comprehensive Flutter application for managing financial portfolios with real-time market data visualization.

## Features

### 🏪 Market Data
- Real-time stock, ETF, and bond prices
- Search and filter instruments
- Market status indicators
- Top gainers, losers, and most active

### 📊 Portfolio Management
- Add/remove positions
- Track gains and losses
- Portfolio analytics and charts
- Performance metrics

### ⭐ Favorites
- Save favorite instruments
- Quick access to tracked items
- Customizable sorting options

### ⚙️ Settings
- Light/Dark/System theme modes
- Notification preferences
- Data export/import
- User preferences

## Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Local Storage**: Hive + SharedPreferences
- **Charts**: FL Chart
- **Real-time Data**: WebSocket connections
- **Architecture**: Clean Architecture pattern

## Project Structure

```
lib/
├── core/                 # Core utilities and constants
│   ├── constants/        # App and API constants
│   ├── themes/          # Theme definitions
│   └── utils/           # Formatters, validators, calculations
├── data/                # Data layer
│   ├── models/          # Data models with JSON serialization
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Local and remote data sources
├── domain/              # Business logic layer
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
├── presentation/        # UI layer
│   ├── pages/          # Screen widgets
│   ├── widgets/        # Reusable UI components
│   ├── providers/      # State management
│   └── themes/         # UI theme components
└── services/           # App services (navigation, notifications)
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/financial-app.git
cd financial-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for JSON serialization):
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Configuration

### API Configuration
Update `lib/core/constants/api_constants.dart` with your API endpoints:

```dart
static const String baseUrl = 'YOUR_API_BASE_URL';
static const String websocketUrl = 'YOUR_WEBSOCKET_URL';
```

### App Configuration
Modify `lib/core/constants/app_constants.dart` for app-specific settings.

## Features Implementation

### Real-time Updates
The app uses WebSocket connections for real-time market data updates. The `RealTimeService` manages connections and data streams.

### Local Storage
Data is cached locally using Hive for complex objects and SharedPreferences for simple key-value pairs.

### State Management
Provider pattern is used for state management with separate providers for:
- Market data
- Portfolio management
- Favorites
- User preferences
- Theme settings

### Dark/Light Theme
Automatic theme switching based on system preferences or manual selection.

## Testing

Run tests with:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please visit our [documentation](https://docs.financialapp.com) or contact support@financialapp.com.

---

Built with ❤️ using Flutter