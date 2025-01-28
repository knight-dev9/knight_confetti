## 🎉 Flutter Confetti Pages
A versatile Flutter package that brings excitement and fun to your app with six unique types of confetti animations! Perfect for celebrations, achievements, or simply adding a touch of visual delight to your app.

## 🌟 Features
This package provides six ready-to-use confetti pages, each designed for different scenarios:

### Explosion Confetti Page
A dynamic and exciting burst of confetti particles radiating outward, ideal for highlighting major achievements or celebrations.

### Firework Confetti Page
Stunning firework-style confetti animations that shoot up and explode with vibrant particles. Perfect for festive events and grand reveals.

### Floating Confetti Page
Gentle floating confetti particles that gracefully drift across the screen. Great for creating a calm and magical atmosphere.

### Rain Confetti Page
A rain-like effect where confetti particles fall smoothly from the top of the screen, bringing a continuous celebratory vibe.

### Snow Confetti Page
Beautiful snow-like confetti animations, creating a serene and wintery effect. Ideal for holiday themes and seasonal designs.

### Widget Confetti Page
Confetti integrated with widgets, allowing you to create custom animations around or within UI elements for interactive designs.


## Preview Demo
![Video Demo](assets/demo.gif)

## Usage
Add confetti animations to your Flutter app with minimal setup. Customize colors, particle sizes, animation durations, and more to suit your app's style.

### import package
```dart
import 'package:knight_confetti/knight_confetti.dart';
```

### Explosion Confetti
```dart
ExplosionConfettiPage(
  duration: Duration(seconds: 2),
  totalParticles: 100,
  colors: Colors.primaries,
);
```

### Firework Confetti
```dart
FireworksConfettiPage(
  duration: Duration(seconds: 4),
  totalParticles: 100,
  colors: Colors.primaries,
)
```

### Floating Confetti
```dart
FloatingConfettiPage(
  duration: Duration(seconds: 10),
  totalParticles: 100,
  colors: Colors.primaries,
)
```

### Rain Confetti
```dart
RainConfettiPage(
  duration: Duration(seconds: 10),
  totalParticles: 300,
  color: Colors.blueAccent.withOpacity(0.6),
)
```

### Snow Confetti
```dart
SnowConfettiPage(
  duration: Duration(seconds: 10),
  totalParticles: 150,
  color: Colors.white.withOpacity(0.9),
)
```

### Widget Confetti
```dart
WidgetConfettiPage(
  duration: const Duration(seconds: 5),
  totalParticles: 30,
  children: , // Add list of widgets
)
```

## Author

This package is developed by Atirek Pothiwala.
