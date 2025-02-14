import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: FlashcardViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // The List of categories.
                List {
                    Section(header: Text("Categories")) {
                        ForEach(viewModel.categories) { category in
                            NavigationLink(destination: FlashcardListView(category: category)) {
                                Text(category.category)
                                    .font(.headline)
                            }
                        }
                    }
                }
                // Extra padding at the bottom so the list doesn't get hidden behind the button.
                .padding(.bottom, 100)
                
                // Bottom button pinned to the bottom of the screen.
                NavigationLink(destination: RandomFlashcardView(viewModel: viewModel)) {
                    HStack {
                        Spacer()
                        Text("Random Card")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle("Flashcard Categories")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FlashcardViewModel()
        ContentView()
            .environmentObject(viewModel)
            // For testing, you might set a preferredColorScheme here,
            // but remove it in your production build so it follows the system settings.
            //.preferredColorScheme(.dark)
    }
}
