import Foundation

struct LevelData {
    static let levels: [Level] = [
        Level(id: 1, themeEN: "Autumn Harvest", themeES: "Cosecha de Otoño", wordsEN: ["FALL", "LEAVES", "HARVEST", "PUMPKIN", "APPLE", "ORANGE", "GOLD", "CRISP"], wordsES: ["OTOÑO", "HOJAS", "COSECHA", "CALABAZA", "MANZANA", "NARANJA", "ORO", "CRUJIENTE"], gridSize: 10, backgroundColorHex: "#F5E6D3"),
        Level(id: 2, themeEN: "Ocean Breeze", themeES: "Brisa del Océano", wordsEN: ["WAVE", "BEACH", "SHELL", "TIDE", "SAND", "SEA", "SALT", "COAST"], wordsES: ["OLA", "PLAYA", "CONCHA", "MAREA", "ARENA", "MAR", "SAL", "COSTA"], gridSize: 10, backgroundColorHex: "#E6F3F5"),
        // ... (full 100 levels as updated locally)
        Level(id: 100, themeEN: "Final Calm", themeES: "Calma Final", wordsEN: ["PEACE", "HOME", "STAR", "QUIET", "LOVE", "MEMORY", "REST", "JOY"], wordsES: ["PAZ", "HOGAR", "ESTRELLA", "SILENCIO", "AMOR", "MEMORIA", "DESCANSO", "ALEGRIA"], gridSize: 10, backgroundColorHex: "#E8F5E9"),
    ]
    
    static func levels(for language: String) -> [Level] {
        return levels
    }
}
