import SwiftUI

@main
struct WordHavenApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var progress = ProgressManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environmentObject(progress)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var progress: ProgressManager
    
    var body: some View {
        LevelSelectView(languageManager: languageManager, progress: progress)
            .preferredColorScheme(.light) // Clean aesthetic
    }
}
