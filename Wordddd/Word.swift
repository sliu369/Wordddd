import Foundation

struct Word: Identifiable, Codable {
    let id: UUID
    let term: String
    var definitions: [String]  // Changed from single definition to array
    let dateAdded: Date
    
    init(term: String, definition: String) {
        self.id = UUID()
        self.term = term
        self.definitions = [definition]
        self.dateAdded = Date()
    }
    
    mutating func addDefinition(_ definition: String) {
        if !definitions.contains(definition) {
            definitions.append(definition)
        }
    }
}
