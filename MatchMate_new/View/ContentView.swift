
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
            ToastView(message:  viewModel.error?.localizedDescription ?? Constants.BLANK_STR, showToast: $showToast)
                .onChange(of: viewModel.error) {
                    if viewModel.error != nil {
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
