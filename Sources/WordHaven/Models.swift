import Foundation

struct Level: Identifiable, Codable {
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

class ProgressManager: ObservableObject {
    @Published var unlockedLevels: Set<Int> = [1] {
        didSet { saveProgress() }
    }
    @Published var stars: [Int: Int] = [:] {
        didSet { saveProgress() }
    }
    @Published var totalStars: Int = 0
    
    private let unlockedKey = "unlockedLevels"
    private let starsKey = "levelStars"
    
    init() {
        loadProgress()
    }
    
    func completeLevel(_ id: Int, starsEarned: Int) {
        unlockedLevels.insert(id + 1)
        if let existing = stars[id] {
            if starsEarned > existing {
                stars[id] = starsEarned
            }
        } else {
            stars[id] = starsEarned
        }
        totalStars = stars.values.reduce(0, +)
    }
    
    private func saveProgress() {
        let unlockedArray = Array(unlockedLevels)
        UserDefaults.standard.set(unlockedArray, forKey: unlockedKey)
        
        if let starsData = try? JSONEncoder().encode(stars) {
            UserDefaults.standard.set(starsData, forKey: starsKey)
        }
    }
    
    private func loadProgress() {
        if let unlockedArray = UserDefaults.standard.array(forKey: unlockedKey) as? [Int] {
            unlockedLevels = Set(unlockedArray)
        }
        if let starsData = UserDefaults.standard.data(forKey: starsKey),
           let decodedStars = try? JSONDecoder().decode([Int: Int].self, from: starsData) {
            stars = decodedStars
        }
        totalStars = stars.values.reduce(0, +)
    }
}
