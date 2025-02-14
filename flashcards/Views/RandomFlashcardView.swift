import SwiftUI

struct RandomFlashcardView: View {
    @ObservedObject var viewModel: FlashcardViewModel
    /// If provided, only cards from this category are used.
    var category: FlashcardCategory? = nil
    
    // The randomized order of flashcards.
    @State private var cardOrder: [Flashcard] = []
    // The current index in the randomized list.
    @State private var currentIndex: Int = 0
    // The currently displayed flashcard.
    @State private var currentCard: Flashcard?
    // Offset used for swipe animation.
    @State private var dragOffset: CGSize = .zero
    // Opacity used for fade transition.
    @State private var cardOpacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            if cardOrder.isEmpty {
                Text("Loading...")
                    .onAppear {
                        setupRandomizedCards()
                    }
            } else {
                // Progress indicator.
                Text("Card \(currentIndex + 1) of \(cardOrder.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let card = currentCard {
                    FlipCardView(card: card)
                        .id(card.id) // Reset flip state when card changes.
                        .padding()
                        .offset(x: dragOffset.width)
                        .opacity(cardOpacity)
                        .animation(.easeInOut, value: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    // Swipe left for next card.
                                    if value.translation.width < -50 {
                                        animateTransition(for: .next)
                                    }
                                    // Swipe right for previous card (only if available).
                                    else if value.translation.width > 50, currentIndex > 0 {
                                        animateTransition(for: .previous)
                                    } else {
                                        withAnimation {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                        .transition(.opacity)
                }
                
                Button("Next Question") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        loadNextCard()
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(category == nil ? "Random Flashcard" : "Random \(category!.category) Flashcard")
    }
    
    /// Sets up a new randomized order for flashcards.
    func setupRandomizedCards() {
        let cards: [Flashcard]
        if let category = category {
            cards = category.cards
        } else {
            cards = viewModel.categories.flatMap { $0.cards }
        }
        if !cards.isEmpty {
            cardOrder = cards.shuffled()
            currentIndex = 0
            currentCard = cardOrder[currentIndex]
        }
    }
    
    enum SwipeDirection {
        case next, previous
    }
    
    /// Animates the card transition in a fade/offset manner.
    func animateTransition(for direction: SwipeDirection) {
        withAnimation(.easeInOut(duration: 0.3)) {
            // Fade out the current card.
            cardOpacity = 0.0
        }
        // After fade-out, update the card.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                switch direction {
                case .next:
                    loadNextCard()
                case .previous:
                    loadPreviousCard()
                }
                // Reset offset and fade in.
                dragOffset = .zero
                cardOpacity = 1.0
            }
        }
    }
    
    /// Loads the next card; if at the end, re-randomizes the list.
    func loadNextCard() {
        if currentIndex < cardOrder.count - 1 {
            currentIndex += 1
            currentCard = cardOrder[currentIndex]
        } else {
            setupRandomizedCards()
        }
    }
    
    /// Loads the previous card.
    func loadPreviousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
            currentCard = cardOrder[currentIndex]
        }
    }
}

struct RandomFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = FlashcardCategory(category: "Mathematics", cards: [
            Flashcard(question: "What is 2 + 2?", answer: "4", explanation: "Adding 2 and 2 yields 4."),
            Flashcard(question: "What is the square root of 16?", answer: "4", explanation: "Because 4 x 4 equals 16.")
        ])
        let viewModel = FlashcardViewModel()
        viewModel.categories = [sampleCategory]
        return NavigationView {
            RandomFlashcardView(viewModel: viewModel, category: sampleCategory)
        }
    }
}
