import SwiftUI

struct PracticeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var wordManager: WordManager
    
    @State private var currentWord: Word?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var practiceWords: [Word] = []
    @State private var selectedDefinitions: Set<String> = []
    @State private var definitionChoices: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if practiceWords.isEmpty {
                    noWordsView
                } else {
                    practiceContentView
                }
            }
            .padding()
            .navigationTitle("Practice")
            .navigationBarItems(leading: Button("Exit") {
                dismiss()
            })
            .onAppear(perform: initializePractice)
        }
    }
    
    private var noWordsView: some View {
        VStack {
            Text("No words to practice!")
                .font(.title2)
            Text("Add some words first")
                .foregroundColor(.gray)
        }
    }
    
    private var practiceContentView: some View {
        VStack {
            if let word = currentWord {
                Text(word.term)
                    .font(.system(size: 32, weight: .bold))
                    .padding()
                
                if showResult {
                    resultView
                } else {
                    definitionChoicesView
                }
            }
        }
    }
    
    private var definitionChoicesView: some View {
        VStack {
            ForEach(definitionChoices, id: \.self) { definition in
                Button(action: {
                    toggleDefinition(definition)
                }) {
                    HStack {
                        Text(definition)
                        Spacer()
                        if selectedDefinitions.contains(definition) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selectedDefinitions.contains(definition) ? Color.blue : Color.gray, lineWidth: 1)
                )
            }
            .padding(.vertical, 4)
            
            Button(action: checkAnswer) {
                HStack {
                    Spacer()
                    Text("Submit")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.top)
        }
    }
    
    private var resultView: some View {
        VStack {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(isCorrect ? .green : .red)
                .padding()
            
            if !isCorrect {
                Text("Correct definition(s):")
                    .padding(.top)
                ForEach(currentWord?.definitions ?? [], id: \.self) { definition in
                    Text("• \(definition)")
                        .padding(.vertical, 2)
                }
            }
            
            Button(action: nextWord) {
                Text("Next Word")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
    }
    
    private func toggleDefinition(_ definition: String) {
        if selectedDefinitions.contains(definition) {
            selectedDefinitions.remove(definition)
        } else {
            selectedDefinitions.insert(definition)
        }
    }
    
    private func initializePractice() {
        practiceWords = wordManager.words.shuffled()
        if !practiceWords.isEmpty {
            currentWord = practiceWords.first
            setupDefinitionChoices()
        }
    }
    
    private func setupDefinitionChoices() {
        guard let currentWord = currentWord else { return }
        
        // Start with the correct definitions
        definitionChoices = currentWord.definitions
        
        // Get all other definitions from other words
        let otherDefinitions = wordManager.words
            .filter { $0.id != currentWord.id }
            .flatMap { $0.definitions }
        
        // Add random definitions until we have 5 or all available definitions
        let remainingCount = min(5 - definitionChoices.count, otherDefinitions.count)
        if remainingCount > 0 {
            definitionChoices.append(contentsOf: Array(otherDefinitions.shuffled().prefix(remainingCount)))
        }
        
        // Shuffle the final choices
        definitionChoices.shuffle()
        selectedDefinitions.removeAll()
    }
    
    private func checkAnswer() {
        guard let word = currentWord else { return }
        
        let correctDefinitions = Set(word.definitions)
        isCorrect = selectedDefinitions == correctDefinitions
        showResult = true
    }
    
    private func nextWord() {
        if let currentIndex = practiceWords.firstIndex(where: { $0.id == currentWord?.id }),
           currentIndex + 1 < practiceWords.count {
            currentWord = practiceWords[currentIndex + 1]
        } else {
            practiceWords = wordManager.words.shuffled()
            currentWord = practiceWords.first
        }
        
        showResult = false
        selectedDefinitions.removeAll()
        setupDefinitionChoices()
    }
}
