import Foundation

struct Flashcard: Identifiable, Codable {
    let id = UUID()
    let question: String
    let answer: String
    let explanation: String

    enum CodingKeys: String, CodingKey {
        case question, answer, explanation
    }
}
