# PaperBrain 📚🧠

PaperBrain is a Flutter application that combines PDF document analysis with AI-powered chat interactions. Upload your PDF documents and have intelligent conversations about their content using Google's Gemini AI.

## Features

- 📄 PDF Document Upload & Viewing
- 🤖 AI-Powered Document Analysis
- 💬 Interactive Chat Interface
- 📱 Clean Material Design UI
- 🏗️ Clean Architecture Implementation

## Getting Started

### Prerequisites

- Flutter (latest stable version)
- Dart SDK
- Google Gemini API Key
- Android Studio / VS Code


## Project Structure

```
lib/
├── main.dart           # App entry point
└── src/
    ├── data/          # Data layer
    │   ├── di/        # Dependency injection
    │   └── repositories/
    ├── domain/        # Domain layer
    │   ├── repositories/
    │   └── services/
    └── presentation/  # UI layer
        ├── features/
        │   ├── chatbot/
        │   └── home/
        └── widgets/
```

### Architecture

The project follows Clean Architecture principles with three main layers:

1. **Data Layer**
   - Implements repositories
   - Handles external services (Gemini API)
   - Manages dependency injection

2. **Domain Layer**
   - Defines core business logic
   - Contains repository interfaces
   - Implements service abstractions

3. **Presentation Layer**
   - Implements UI features
   - Uses BLoC pattern via Cubits
   - Manages state and user interactions