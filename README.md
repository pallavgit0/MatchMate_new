# MatchMate_new

MatchMate is a SwiftUI-based iOS application that presents a list of user profiles fetched from an API. The app allows users to accept or decline profiles, with user decisions being saved locally using CoreData. The project is structured using the MVVM (Model-View-ViewModel) architecture, and includes network reachability monitoring, error handling, and a smooth user interface with toast notifications.

**Features**

Fetches random user profiles from RandomUser API.
Local storage of profiles using CoreData.
User profile actions: Accept or Decline a profile.
Handles offline mode using a NetworkReachability class.
Error handling with toast notifications.
Clean architecture following MVVM principles.
Alamofire for network requests and SDWebImageSwiftUI for image loading.
Technologies Used
SwiftUI: For building the user interface.
Alamofire: For making API requests.
SDWebImageSwiftUI: For asynchronous image loading and caching.
CoreData: For persistent local storage.
Combine: For reactive programming and state management.
MVVM Architecture: Ensures separation of concerns and scalability.

**Installation**

Clone the repository:
git clone https://github.com/yourusername/MatchMate.git

Open the project in Xcode:

cd MatchMate
open MatchMate.xcodeproj

Build and run the project in Xcode by selecting a target device or simulator.

**Project Structure**

The project follows the MVVM architecture, which divides the code into three main parts:

1. Model
Defines the data structures and API responses. This includes models like User, Location, Picture, and more, which are fetched from the RandomUser API.
Example: User, Location, Picture.
2. ViewModel
Contains the business logic and handles data transformation. It is responsible for making network requests using Alamofire, saving profiles to CoreData, and reacting to network reachability changes.
Example: MatchViewModel, NetworkReachability.
3. View
Represents the UI components, built using SwiftUI. The UI elements react to changes in the ViewModel through bindings and published properties.
Example: ContentView, MatchCardView, ToastView.
Usage
Fetch Profiles
When the app is launched, it automatically fetches 10 random user profiles from the RandomUser API. If there is no internet connection, the app will display a toast message indicating the lack of connectivity.

**Profile Actions**

Accept: Mark the profile as "Accepted" and store the decision in CoreData.
Decline: Mark the profile as "Declined" and store the decision in CoreData.
Offline Support
The app uses a NetworkReachability class to monitor internet connectivity. If no connection is available, the app will notify the user through a toast message.
Profiles are cached using CoreData for offline viewing.
Error Handling
Toast messages are used to display errors, such as when the internet is unavailable or when a network request fails.

**Key Classes**

1. MatchViewModel
Handles all business logic and communicates between the Model and the View.
Fetches user profiles from the API, saves them to CoreData, and manages user decisions.
Monitors network connectivity using NetworkReachability.
2. NetworkReachability
Observes the network status using NWPathMonitor from the Network framework.
Provides real-time updates on whether the device is connected to the internet.
3. CoreData Entities
UserProfile: Stores profile data locally, including name, location, and picture.
Other related entities like NameEntity, LocationEntity, PictureEntity are used to persist complex user details.

**Future Improvements**

As per the future alterations required like displaying more data on UI and hence making card more informative , pagination in apis , etc.
