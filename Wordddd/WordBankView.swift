import SwiftUI

struct WordBankView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var wordManager: WordManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(wordManager.words) { word in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(word.term)
                            .font(.headline)
                        
                        ForEach(word.definitions, id: \.self) { definition in
                            Text("• \(definition)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: wordManager.removeWord)
            }
            .navigationTitle("Word Bank")
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
        }
    }
}
