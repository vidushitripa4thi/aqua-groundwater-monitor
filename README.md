# Aqua Groundwater Monitor 💧

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" />
</div>

## 📋 Overview

A comprehensive Flutter mobile application for real-time groundwater monitoring using data from 5,260 DWLR (Digital Water Level Recorder) stations across India. This app enables researchers, policymakers, and water resource managers to analyze water level trends, estimate groundwater recharge, and make data-driven decisions for sustainable water management.

### 🎯 Problem Statement

India has only 4% of the world's freshwater resources while supporting 16% of the global population. With uneven distribution, overexploitation, and climate change impacts, sustainable groundwater management is critical. This app addresses the need for real-time resource knowledge and decision support.

## ✨ Key Features

### 📊 Real-Time Data Visualization
- Interactive charts showing water level trends over time
- Multiple chart types: Line, Bar, Heatmaps, and Scatter plots
- Customizable date ranges and data aggregation
- Smooth animations and touch interactions

### 🗺️ Interactive Map
- Display all 5,260 DWLR stations on Google Maps
- Color-coded markers based on water level status
- Filter stations by state, district, or status
- Tap markers to view detailed station information

### 📈 Advanced Analytics
- **Recharge Estimation**: Dynamic calculation of groundwater recharge
- **Seasonal Patterns**: Analysis of Monsoon, Post-Monsoon, Winter, and Summer trends
- **Predictive Models**: Future water level forecasting using linear regression
- **Efficiency Metrics**: Recharge vs. rainfall correlation analysis

### 🔔 Alert System
- Real-time notifications for critical water levels
- Customizable alert thresholds
- Firebase Cloud Messaging integration

### 📱 User-Friendly Interface
- Material Design 3 principles
- Light and Dark mode support
- Responsive layouts for all screen sizes
- Offline data access with local caching

### 📤 Data Export
- Export reports as PDF
- Generate CSV files for further analysis
- Share station data with colleagues

## 🛠️ Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Provider**: State management
- **fl_chart**: Beautiful, customizable charts
- **Syncfusion Flutter Charts**: Advanced visualization

### Backend & Services
- **Firebase Core**: Authentication and real-time database
- **Cloud Firestore**: NoSQL cloud database
- **Firebase Messaging**: Push notifications

### APIs & Data
- **Open Government Data Platform India**: DWLR station data
- **National e-Governance Division APIs**: Government data access
- **Google Maps Flutter**: Interactive mapping

### Local Storage
- **Hive**: Fast, lightweight local database
- **Shared Preferences**: App settings storage

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── dwlr_station.dart             # Station data model
│   └── water_level_reading.dart      # Reading data model
├── services/
│   ├── api_service.dart              # Government API integration
│   ├── firebase_service.dart         # Firebase operations
│   └── providers/
│       ├── data_provider.dart        # Data state management
│       └── theme_provider.dart       # Theme management
├── screens/
│   ├── splash_screen.dart            # Loading screen
│   ├── dashboard_screen.dart         # Main dashboard
│   ├── map_screen.dart               # Interactive map
│   └── station_detail_screen.dart    # Station details
├── widgets/
│   ├── charts/
│   │   └── water_level_chart.dart    # Custom chart widgets
│   └── cards/
│       └── station_summary_card.dart # Station card widget
└── utils/
    ├── app_theme.dart                # App theming
    └── recharge_calculator.dart      # Calculation algorithms
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase account
- Government Data API key from [data.gov.in](https://data.gov.in)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vidushitripa4thi/aqua-groundwater-monitor.git
   cd aqua-groundwater-monitor
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Set up API keys**:
   - Open `lib/services/api_service.dart`
   - Replace `YOUR_API_KEY_HERE` with your actual API key from [data.gov.in](https://data.gov.in)

5. **Run the app**:
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

## 📊 Key Algorithms

### Groundwater Recharge Calculation

```dart
Recharge (MCM) = Area (sq km) × Water Level Rise (m) × Specific Yield
```

**Parameters**:
- **Area**: Aquifer area in square kilometers
- **Water Level Rise**: Change in water level (previous - current)
- **Specific Yield**: Porosity of aquifer (typically 0.1-0.3)

### Seasonal Analysis

The app categorizes data into four seasons:
- **Monsoon**: June - September
- **Post-Monsoon**: October - November
- **Winter**: December - February
- **Summer**: March - May

### Water Level Prediction

Simple linear regression for forecasting:
```dart
Future Level = Slope × (Days Ahead) + Intercept
```

## 🎨 Screenshots

*Screenshots will be added as the app is developed*

## 🗺️ Data Sources

- **DWLR Stations**: 5,260 stations across India
- **Update Frequency**: Real-time (every 15-30 minutes)
- **Data Points**: Water level, temperature, rainfall, quality metrics
- **Historical Data**: Available from installation date of each station

## 📈 Future Enhancements

- [ ] Machine Learning models for advanced prediction
- [ ] Multi-language support (Hindi, Tamil, Telugu, etc.)
- [ ] Offline map access
- [ ] Voice commands and accessibility features
- [ ] Integration with weather APIs for rainfall correlation
- [ ] Community reporting features
- [ ] Water quality analysis
- [ ] Automated report generation and scheduling

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Author

**Vidushi Tripathi**
- GitHub: [@vidushitripa4thi](https://github.com/vidushitripa4thi)
- Email: tripathividu.2508@gmail.com

## 🙏 Acknowledgments

- Government of India's Open Data Platform
- National e-Governance Division
- Central Ground Water Board (CGWB)
- All contributors and water resource researchers

## 📞 Support

For questions or support, please:
- Open an issue on GitHub
- Email: tripathividu.2508@gmail.com

## 🌟 Impact

This app aims to:
- Enable **real-time decision-making** for water resource management
- Support **scientific research** with accessible data
- Help **policymakers** design effective interventions
- Promote **sustainable groundwater** usage across India
- Contribute to **UN SDG 6**: Clean Water and Sanitation

---

<div align="center">
  <p><strong>Building a sustainable water future for India 🇮🇳💧</strong></p>
  <p>Made with ❤️ using Flutter</p>
</div>