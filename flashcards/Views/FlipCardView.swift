import SwiftUI

struct FlipCardView: View {
    let card: Flashcard
    /// Called when a horizontal swipe is detected.
    var onSwipe: (() -> Void)? = nil

    @State private var flipped: Bool = false
    @State private var rotation: Double = 0
    @Environment(\.colorScheme) var colorScheme

    // Choose a lighter background color in dark mode.
    var backgroundColor: Color {
        colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground)
    }

    var body: some View {
        // Tap gesture to trigger the flip animation.
        let tapGesture = TapGesture().onEnded {
            withAnimation(.easeInOut(duration: 0.6)) {
                flipped.toggle()
                rotation += 180
            }
        }

        return ZStack {
            Group {
                if flipped {
                    VStack {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.green)
                            .padding(.top)
                        Text(card.explanation)
                            .font(.body)
                            .foregroundColor(Color.secondary)
                            .padding(.horizontal)
                    }
                    // Rotate inner content so text stays upright.
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    Text(card.question)
                        .font(.headline)
                        .foregroundColor(Color.primary)
                        .padding()
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 300)
            // Use the dynamically chosen background color.
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .gesture(tapGesture)
    }
}

struct FlipCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Flashcard(question: "What is 2 + 2?",
                                   answer: "4",
                                   explanation: "Because 2 plus 2 equals 4.")
        FlipCardView(card: sampleCard)
            .preferredColorScheme(.dark)
    }
}
