# WordHaven

A clean, aesthetic word search app designed for the 40-99 age group on iOS and iPadOS.

## Features
- English (USA) and Spanish (Latin America) language toggle
- 100 themed levels (English and Spanish)
- Star reward system (1-3 stars based on completion time)
- Large touch targets supporting finger and Apple Pencil
- Calming color themes per level
- High contrast, large fonts for accessibility
- Support for iPhone 13+ and corresponding iPads (iOS 15+)
- Progress (unlocked levels and stars) is automatically saved with UserDefaults and restored on launch

## Setup
1. Create a new SwiftUI project in Xcode targeting iOS 15.0+
2. Replace the generated files with the ones in Sources/WordHaven/
3. Add the files to the target
4. Build and run on device or simulator

## Deployment
- Test on device via Xcode
- Archive and upload to App Store Connect for TestFlight
- Supports iPhone 13 and later, iPad (9th gen and later, Pro models from 2021+)

## UX Notes
- Soft backgrounds, large cells (optimized for older hands)
- Gentle animations and haptics on word found
- Sequential unlocking for progression
- No ads or clutter – pure focus and satisfaction
