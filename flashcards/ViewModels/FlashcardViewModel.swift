import Foundation

class FlashcardViewModel: ObservableObject {
    @Published var categories: [FlashcardCategory] = []
    
    init() {
        loadFlashcards()
    }
    
    func loadFlashcards() {
        if let url = Bundle.main.url(forResource: "flashcards", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let categories = try decoder.decode([FlashcardCategory].self, from: data)
                self.categories = categories
            } catch {
                print("Error loading flashcards: \(error)")
            }
        } else {
            print("flashcards.json not found in bundle")
        }
    }
}
