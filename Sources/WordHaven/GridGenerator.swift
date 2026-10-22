import Foundation

class GridGenerator {
    static func generate(for level: Level, isSpanish: Bool) -> ([[GridCell]], [WordPlacement]) {
        let words = isSpanish ? level.wordsES : level.wordsEN
        let size = level.gridSize
        var grid = Array(repeating: Array(repeating: Character(" "), count: size), count: size)
        var placements: [WordPlacement] = []
        
        let directions: [(dr: Int, dc: Int)] = [
            (0, 1), (1, 0), (1, 1), (1, -1), // right, down, diag down-right, diag down-left
            (0, -1), (-1, 0), (-1, -1), (-1, 1) // left, up, diag up-left, diag up-right
        ]
        
        for word in words {
            var placed = false
            var attempts = 0
            while !placed && attempts < 100 {
                attempts += 1
                let dir = directions.randomElement()!
                let startRow = Int.random(in: 0..<size)
                let startCol = Int.random(in: 0..<size)
                
                var positions: [(Int, Int)] = []
                var canPlace = true
                for (i, char) in word.enumerated() {
                    let r = startRow + dir.dr * i
                    let c = startCol + dir.dc * i
                    if r < 0 || r >= size || c < 0 || c >= size || (grid[r][c] != " " && grid[r][c] != char) {
                        canPlace = false
                        break
                    }
                    positions.append((r, c))
                }
                if canPlace {
                    for (i, char) in word.enumerated() {
                        let pos = positions[i]
                        grid[pos.0][pos.1] = char
                    }
                    placements.append(WordPlacement(word: word, positions: positions))
                    placed = true
                }
            }
            if !placed {
                // Fallback: place horizontally if possible
                // Simplified for demo
            }
        }
        
        // Fill empty with random letters
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == " " {
                    grid[r][c] = letters.randomElement()!
                }
            }
        }
        
        let cells = grid.map { row in row.map { GridCell(letter: $0) } }
        return (cells, placements)
    }
}
