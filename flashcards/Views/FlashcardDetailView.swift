import SwiftUI

struct FlashcardDetailView: View {
    let card: Flashcard
    @State private var showAnswer = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(card.question)
                .font(.headline)
                .padding()
            
            if showAnswer {
                Text(card.answer)
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.top)
                Text(card.explanation)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Button(action: {
                withAnimation {
                    showAnswer.toggle()
                }
            }) {
                Text(showAnswer ? "Hide Answer" : "Show Answer")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Flashcard")
    }
}

struct FlashcardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Flashcard(question: "What is 2 + 2?", answer: "4", explanation: "Adding 2 and 2 yields 4.")
        FlashcardDetailView(card: sampleCard)
    }
}
