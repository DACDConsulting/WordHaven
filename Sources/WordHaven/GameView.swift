import SwiftUI

struct GameView: View {
    let level: Level
    @ObservedObject var languageManager: LanguageManager
    @ObservedObject var progress: ProgressManager
    @Environment(\.dismiss) var dismiss
    
    @State private var grid: [[GridCell]] = []
    @State private var placements: [WordPlacement] = []
    @State private var selectedPositions: [(Int, Int)] = []
    @State private var foundWords: Set<String> = []
    @State private var startTime = Date()
    @State private var showCompletion = false
    @State private var earnedStars = 1
    
    var body: some View {
        ZStack {
            Color(hex: level.backgroundColorHex)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Text(languageManager.isSpanish ? level.themeES : level.themeEN)
                        .font(.title2.bold())
                    Spacer()
                    Text("\(foundWords.count)/\(placements.count)")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                // Word list
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(placements, id: \.word) { placement in
                            Text(placement.word)
                                .font(.body)
                                .padding(8)
                                .background(foundWords.contains(placement.word) ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .strikethrough(foundWords.contains(placement.word))
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Grid
                GeometryReader { geo in
                    let cellSize = min(geo.size.width, geo.size.height) / CGFloat(level.gridSize)
                    VStack(spacing: 2) {
                        ForEach(0..<grid.count, id: \.self) { row in
                            HStack(spacing: 2) {
                                ForEach(0..<grid[row].count, id: \.self) { col in
                                    Text(String(grid[row][col].letter))
                                        .font(.system(size: cellSize * 0.6, weight: .medium))
                                        .frame(width: cellSize, height: cellSize)
                                        .background(cellBackground(row: row, col: col))
                                        .cornerRadius(4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleDrag(value, cellSize: cellSize)
                            }
                            .onEnded { _ in
                                checkSelection()
                                selectedPositions = []
                            }
                    )
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
                
                if showCompletion {
                    CompletionView(stars: earnedStars, onNext: {
                        // Navigate to next or dismiss
                        dismiss()
                    })
                }
            }
        }
        .onAppear {
            let result = GridGenerator.generate(for: level, isSpanish: languageManager.isSpanish)
            grid = result.0
            placements = result.1
            startTime = Date()
        }
    }
    
    private func cellBackground(row: Int, col: Int) -> Color {
        if selectedPositions.contains(where: { $0.0 == row && $0.1 == col }) {
            return Color.blue.opacity(0.4)
        }
        if grid[row][col].isFound {
            return Color.green.opacity(0.3)
        }
        return Color.white.opacity(0.8)
    }
    
    private func handleDrag(_ value: DragGesture.Value, cellSize: CGFloat) {
        let location = value.location
        let col = Int(location.x / (cellSize + 2))
        let row = Int(location.y / (cellSize + 2))
        if row >= 0 && row < grid.count && col >= 0 && col < grid[0].count {
            let pos = (row, col)
            if !selectedPositions.contains(where: { $0 == pos }) {
                selectedPositions.append(pos)
            }
        }
    }
    
    private func checkSelection() {
        let selectedWord = selectedPositions.map { String(grid[$0.0][$0.1].letter) }.joined()
        let reversed = String(selectedWord.reversed())
        
        for placement in placements where !foundWords.contains(placement.word) {
            if selectedWord == placement.word || reversed == placement.word {
                foundWords.insert(placement.word)
                for pos in placement.positions {
                    grid[pos.0][pos.1].isFound = true
                }
                // Haptic
                #if os(iOS)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
                break
            }
        }
        
        if foundWords.count == placements.count {
            let elapsed = Date().timeIntervalSince(startTime)
            earnedStars = elapsed < 120 ? 3 : (elapsed < 180 ? 2 : 1)
            progress.completeLevel(level.id, starsEarned: earnedStars)
            showCompletion = true
        }
    }
}

struct CompletionView: View {
    let stars: Int
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("Level Complete!")
                .font(.title.bold())
            HStack {
                ForEach(1...3, id: \.self) { i in
                    Image(systemName: i <= stars ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title)
                }
            }
            Button("Continue", action: onNext)
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
