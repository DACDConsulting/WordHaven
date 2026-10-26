import Foundation

struct Level: Identifiable, Codable, Hashable {
    let id: Int
    let themeEN: String
    let themeES: String
    let wordsEN: [String]
    let wordsES: [String]
    let gridSize: Int
    let backgroundColorHex: String // e.g. "#F5F0E6"
}

struct WordPlacement {
    let word: String
    let positions: [(row: Int, col: Int)]
    var found: Bool = false
}

struct GridCell {
    var letter: Character
    var isSelected: Bool = false
    var isFound: Bool = false
    var isHint: Bool = false
}

class LanguageManager: ObservableObject {
    @Published var isSpanish: Bool = false
    
    var currentLanguage: String {
        isSpanish ? "es" : "en"
    }
}

class SettingsManager: ObservableObject {
    @Published var soundEffectsEnabled: Bool = true {
        didSet { UserDefaults.standard.set(soundEffectsEnabled, forKey: "soundEffects") }
    }
    @Published var musicEnabled: Bool = true {
        didSet { UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled") }
    }
    
    init() {
        soundEffectsEnabled = UserDefaults.standard.object(forKey: "soundEffects") as? Bool ?? true
        musicEnabled = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
    }
}

class ProgressManager: ObservableObject {
    @Published var unlockedLevels: Set<Int> = Set(1...100) {  // All levels available as a library
        didSet { saveProgress() }
    }
    @Published var stars: [Int: Int] = [:] {
        didSet { saveProgress() }
    }
    @Published var totalStars: Int = 0
    @Published var completedLevels: Set<Int> = [] {
        didSet { saveProgress() }
    }
    
    private let unlockedKey = "unlockedLevels"
    private let starsKey = "levelStars"
    private let completedKey = "completedLevels"
    
    init() {
        loadProgress()
        if unlockedLevels.isEmpty {
            unlockedLevels = Set(1...100)
        }
    }
    
    func completeLevel(_ id: Int, starsEarned: Int) {
        completedLevels.insert(id)
        if let existing = stars[id] {
            if starsEarned > existing {
                stars[id] = starsEarned
            }
        } else {
            stars[id] = starsEarned
        }
        totalStars = stars.values.reduce(0, +)
    }
    
    func randomUncompletedLevel() -> Level? {
        let available = LevelData.levels.filter { !completedLevels.contains($0.id) }
        return available.randomElement() ?? LevelData.levels.randomElement()
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(Array(unlockedLevels), forKey: unlockedKey)
        UserDefaults.standard.set(Array(completedLevels), forKey: completedKey)
        if let starsData = try? JSONEncoder().encode(stars) {
            UserDefaults.standard.set(starsData, forKey: starsKey)
        }
    }
    
    private func loadProgress() {
        if let unlockedArray = UserDefaults.standard.array(forKey: unlockedKey) as? [Int], !unlockedArray.isEmpty {
            unlockedLevels = Set(unlockedArray)
        }
        if let completedArray = UserDefaults.standard.array(forKey: completedKey) as? [Int] {
            completedLevels = Set(completedArray)
        }
        if let starsData = UserDefaults.standard.data(forKey: starsKey),
           let decodedStars = try? JSONDecoder().decode([Int: Int].self, from: starsData) {
            stars = decodedStars
        }
        totalStars = stars.values.reduce(0, +)
    }
}
