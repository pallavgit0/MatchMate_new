
import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    @ObservedObject var viewModel: MatchViewModel
    var profile: UserProfile 
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: profile.picture?.large ?? profile.picture?.medium ?? profile.picture?.thumbnail ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Text("\(profile.name?.first ??  Constants.BLANK_STR) \(profile.name?.last ?? Constants.BLANK_STR)")
                .font(.headline)
            
            Text(profile.location?.city ?? Constants.BLANK_STR)
                .font(.subheadline)
            
            if let  status = profile.status {
                Text( status ==  Constants.CARD_ACCEPTED ?  Constants.CARD_ACCEPTED :  Constants.CARD_DECLINED)
                    .font(.system(size: 18, weight:  .bold))
                    .foregroundColor(status == Constants.CARD_ACCEPTED ? .green : .red) 
            } else {
                HStack(spacing: 16) {
                    Button(action: { }) {
                        Text(Constants.BTN_ACCEPT)
                            .foregroundColor(.green)
                            .padding()
                            .border(Color.green)
                    }
                    .onTapGesture  {
                        viewModel.acceptProfile(profile)
                    }
                    
                    Button(action: { }) {
                        Text(Constants.BTN_DECLINE)
                            .foregroundColor(.red)
                            .padding()
                            .border(Color.red)
                    }
                    .onTapGesture { 
                        viewModel.declineProfile(profile)
                    }
                }
            }
        }
        .padding()
        .background( Color.yellow.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
}
