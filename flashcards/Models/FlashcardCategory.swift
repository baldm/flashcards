import Foundation

struct FlashcardCategory: Identifiable, Codable {
    let id = UUID()
    let category: String
    let cards: [Flashcard]

    enum CodingKeys: String, CodingKey {
        case category, cards
    }
}
