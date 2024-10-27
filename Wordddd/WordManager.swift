import Foundation

class WordManager: ObservableObject {
    @Published private(set) var words: [Word] = []
    private let wordsKey = "savedWords"
    
    init() {
        loadWords()
    }
    
    func addWord(_ newWord: Word) {
        if let existingIndex = words.firstIndex(where: { $0.term == newWord.term }) {
            // Word exists, add new definition if it's not already there
            var existingWord = words[existingIndex]
            existingWord.addDefinition(newWord.definitions[0])
            words[existingIndex] = existingWord
        } else {
            // New word, add it to the array
            words.append(newWord)
        }
        saveWords()
    }
    
    func removeWord(at indexSet: IndexSet) {
        words.remove(atOffsets: indexSet)
        saveWords()
    }
    
    private func loadWords() {
        if let data = UserDefaults.standard.data(forKey: wordsKey),
           let decodedWords = try? JSONDecoder().decode([Word].self, from: data) {
            words = decodedWords
        }
    }
    
    private func saveWords() {
        if let encoded = try? JSONEncoder().encode(words) {
            UserDefaults.standard.set(encoded, forKey: wordsKey)
        }
    }
}
