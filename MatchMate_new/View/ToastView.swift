import SwiftUI

struct ToastView: View {
    var message: String
    @Binding var showToast: Bool
    var duration: TimeInterval = 3  
    
    var body: some View {
        VStack {
            Spacer()  
            if showToast {
                Text(message)
                    .font(.system(size: 18, weight:  .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)  
                    .transition(.move(edge: .bottom).combined(with: .opacity)) 
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)  
        .padding(.bottom, 40)
    }
}
