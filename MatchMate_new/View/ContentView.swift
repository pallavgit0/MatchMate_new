
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MatchViewModel
    @State private var showToast = false
    
    init() {
        let context = PersistenceController.shared.viewContext
        viewModel = MatchViewModel(context: context)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.profiles) { profile in
                    MatchCardView(viewModel: viewModel, profile: profile)
                }
                .navigationBarTitle(Constants.HEADING )
                .onAppear {
                    viewModel.fetchProfiles()
                }
            }
            
            // Toast Message
            ToastView(message: viewModel.errorMessage ?? Constants.BLANK_STR, showToast: $showToast)
                .onChange(of: viewModel.errorMessage) {
                    if viewModel.errorMessage != nil {
                        withAnimation {
                            showToast = true
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
