import SwiftUI

struct LevelSelectView: View {
    @ObservedObject var languageManager: LanguageManager
    @ObservedObject var progress: ProgressManager
    @State private var selectedLevel: Level?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(LevelData.levels) { level in
                        LevelCard(level: level, isUnlocked: progress.unlockedLevels.contains(level.id), stars: progress.stars[level.id] ?? 0, isSpanish: languageManager.isSpanish)
                            .onTapGesture {
                                if progress.unlockedLevels.contains(level.id) {
                                    selectedLevel = level
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(languageManager.isSpanish ? "Niveles" : "Levels")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(languageManager.isSpanish ? "EN" : "ES") {
                        languageManager.isSpanish.toggle()
                    }
                }
            }
            .navigationDestination(item: $selectedLevel) { level in
                GameView(level: level, languageManager: languageManager, progress: progress)
            }
        }
    }
}

struct LevelCard: View {
    let level: Level
    let isUnlocked: Bool
    let stars: Int
    let isSpanish: Bool
    
    var body: some View {
        VStack {
            Text("\(level.id)")
                .font(.title2.bold())
            Text(isSpanish ? level.themeES : level.themeEN)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if isUnlocked {
                HStack(spacing: 2) {
                    ForEach(1...3, id: \.self) { i in
                        Image(systemName: i <= stars ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100, height: 120)
        .padding(8)
        .background(Color(hex: level.backgroundColorHex).opacity(isUnlocked ? 1 : 0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
        .opacity(isUnlocked ? 1 : 0.6)
    }
}
