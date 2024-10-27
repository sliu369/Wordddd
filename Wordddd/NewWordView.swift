import SwiftUI

struct NewWordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var wordManager: WordManager
    @State private var term = ""
    @State private var definition = ""
    @State private var showAlert = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case term, definition
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Word")) {
                    TextField("Enter word", text: $term)
                        .focused($focusedField, equals: .term)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .definition
                        }
                    
                    TextField("Enter definition", text: $definition)
                        .focused($focusedField, equals: .definition)
                        .submitLabel(.done)
                        .onSubmit {
                            saveWord()
                        }
                }
                
                Section {
                    Button("Save Word") {
                        saveWord()
                    }
                }
            }
            .navigationTitle("Add New Word")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
            .alert("Missing Information", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter both a word and its definition")
            }
            .onAppear {
                // Automatically focus the term field when view appears
                focusedField = .term
            }
        }
    }
    
    private func saveWord() {
        if !term.isEmpty && !definition.isEmpty {
            let newWord = Word(term: term, definition: definition)
            wordManager.addWord(newWord)
            dismiss()
        } else {
            showAlert = true
        }
    }
}

#Preview {
    NewWordView(wordManager: WordManager())
}
