# Places & Wikipedia iOS Apps Workspace

This workspace contains two iOS applications:
- **Places**: A custom SwiftUI app for searching and displaying location-based information
- **Wikipedia iOS**: The official Wikipedia iOS app

## Overview

The Places app is a SwiftUI-based iOS application that fetches location data from a remote API and provides integration with the Wikipedia iOS app. Users can browse predefined locations from the API or enter custom coordinates to explore geographic locations through Wikipedia's Places feature.

## Prerequisites

- **Xcode 16.0** or later
- **macOS** with iOS Simulator
- **Homebrew** (will be installed automatically by setup script)
- **SwiftLint** (will be installed automatically by setup script)
- **ClangFormat** (will be installed automatically by setup script)

## Quick Start

### 1. Initial Setup

Before running the apps, set up the Wikipedia iOS dependencies:

```bash
cd wikipedia-ios-main
./scripts/setup
```

This will install required dependencies including Homebrew, SwiftLint, and ClangFormat.

### 2. Opening the Workspace

Open the main workspace file:
```bash
open PlacesWorkspace.xcworkspace
```

### 3. Running the Applications

**Important**: Both apps must be installed on the simulator in a specific order:

1. **First, run the Wikipedia iOS app:**
   - Select the `Wikipedia` scheme and target
   - Choose your preferred iOS Simulator
   - Click Run (⌘+R) 
   - Wait for the Wikipedia app to install and launch

2. **Then, run the Places app:**
   - Select the `places` scheme and target
   - Choose the same iOS Simulator
   - Click Run (⌘+R)
   - The Places app will install and launch

Both apps will now be installed on your simulator and can be used together.

## Features

### Places App Core Functionality

**Location Services**:
- Fetches location data from remote JSON API
- Supports asynchronous data loading with error handling
- Pull-to-refresh functionality for updated location data

**Coordinates Form**:
- Manual latitude/longitude input with real-time validation
- Uses Core Location's `CLLocationCoordinate2DIsValid` for coordinate validation
- Locale-aware number formatting for coordinate inputs
- Visual error indicators for invalid coordinate ranges

**Wikipedia Integration**:
- Generates Wikipedia URL schemes for location viewing
- Opens Wikipedia's Places feature at specific coordinates
- Seamless handoff between apps using custom URL schemes

### Wikipedia iOS App Integration

The Wikipedia app provides the Places feature that the Places app integrates with through URL schemes.

## URL Schemes Integration

The Places app specifically uses the location URL scheme to pass coordinates to Wikipedia's Places feature.
The Wikipedia app supports the following URL scheme format:

| Feature | Format | Example |
|---------|--------|----------|
| Places: specific location | `wikipedia://location?latitude=&longitude=` | `wikipedia://location?latitude=52.3547498&longitude=4.8339215` |
| Places | `wikipedia://places/?WMFArticleURL=` | `wikipedia://places/?WMFArticleURL=https://en.wikipedia.org/wiki/Dallas` |
| Article | `wikipedia://[site]/wiki/[page_id]` | `wikipedia://en.wikipedia.org/wiki/Red` |
| Content | `wikipedia://content` | `wikipedia://content/on-this-day/wikipedia.org/en/2024/08/15` |
| Explore | `wikipedia://explore` | |
| History | `wikipedia://history` | |
| Saved pages | `wikipedia://saved` | |


## Development

### Running Tests

For Places app tests:
```bash
# Open workspace and run Places tests using Xcode Test Navigator
# Or use keyboard shortcut: ⌘+U with Places scheme selected
# Tests include: CoordinatesFormViewModelTests, LocationsViewModelTests
```

## Places App Architecture

### MVVM Pattern with SwiftUI
- **Models**: `Location` (Codable, Identifiable) and `LocationsResponse` for API data
- **Views**: SwiftUI views with declarative UI and state management
- **ViewModels**: `LocationsViewModel` and `CoordinatesFormViewModel`
- **Services**: Protocol-based services for network, URL generation, and URL opening

### Dependency Injection
- **DependencyContainer**: Custom singleton container for service registration and resolution
- **Protocol-based Services**: `LocationServiceProtocol`, `UrlServiceProtocol`, `URLOpenerServiceProtocol`
- **Testable Architecture**: Mock implementations for unit testing

### Data Flow
1. **LocationService** fetches data from remote API
2. **LocationsViewModel** manages UI state and coordinates data flow
3. **UrlService** generates Wikipedia URL schemes with coordinates
4. **URLOpenerService** handles opening URLs to Wikipedia app
5. **CoordinatesFormViewModel** validates and processes custom coordinate input

---

**Note**: Ensure both applications are running on the same iOS Simulator instance for optimal performance and testing.
