import SwiftUI

@main
struct FlashcardApp: App {
    @StateObject private var viewModel = FlashcardViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
