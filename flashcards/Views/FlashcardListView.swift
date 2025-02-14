import SwiftUI

struct FlashcardListView: View {
    let category: FlashcardCategory
    @EnvironmentObject var viewModel: FlashcardViewModel
    
    var body: some View {
        VStack {
            // Button to show a random flashcard from this category
            NavigationLink(destination: RandomFlashcardView(viewModel: viewModel, category: category)) {
                Text("Random \(category.category) Card")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            // List all flashcards for the category
            List(category.cards) { card in
                NavigationLink(destination: FlashcardDetailView(card: card)) {
                    Text(card.question)
                }
            }
        }
        .navigationTitle(category.category)
    }
}

struct FlashcardListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = FlashcardCategory(category: "Mathematics", cards: [
            Flashcard(question: "What is 2 + 2?", answer: "4", explanation: "Adding 2 and 2 yields 4."),
            Flashcard(question: "What is the square root of 16?", answer: "4", explanation: "Because 4 x 4 equals 16.")
        ])
        let viewModel = FlashcardViewModel()
        viewModel.categories = [sampleCategory]
        return NavigationView {
            FlashcardListView(category: sampleCategory)
                .environmentObject(viewModel)
        }
    }
}
