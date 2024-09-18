import Combine
import CoreData
import UIKit
import Alamofire

class MatchViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var reachability = NetworkReachability()
    
    @Published var profiles: [UserProfile] = []  
    @Published var error: MatchViewModelError? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchProfilesFromCoreData()
    }
    
    
    
    // Fetch profiles from the API
    func fetchProfiles() {
        reachability.startMonitoring()
        guard reachability.isReachable else {
            self.error =   .noInternet
            return
        }
        let url = "https://randomuser.me/api/?results=10"
        
        AF.request(url)
            .publishDecodable(type: UserResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.error =  .failedToFetchProfiles(error.localizedDescription)
                case .finished:
                    print("Finished fetching profiles")
                }
            } receiveValue: { [weak self] response in
                if let apiResponse = response.value { 
                    self?.saveProfilesToCoreData(apiResponse.results)
                    self?.fetchProfilesFromCoreData()
                } else {
                    self?.error = .noResponse  
                }
            }
            .store(in: &cancellables)
    }
    
    // Accept match action
    func acceptProfile(_ profile: UserProfile) {
        updateProfile(profile, status:  Constants.CARD_ACCEPTED)
    }
    
    // Decline match action
    func declineProfile(_ profile: UserProfile) {
        updateProfile(profile, status:  Constants.CARD_DECLINED)
    }
    
    private func updateProfile(_ profile: UserProfile, status: String) {
        profile.status = status
        saveContext()
        fetchProfilesFromCoreData() 
    }
    
    // Core Data Methods 
    private func saveProfilesToCoreData(_ users: [User]) {
        users.forEach { user in
            let userProfile = UserProfile(context: context)
            userProfile.gender = user.gender
            userProfile.email = user.email
            userProfile.phone = user.phone
            userProfile.cell = user.cell
            userProfile.nat = user.nat
            userProfile.status = nil  
            
            let nameEntity = NameEntity(context: context)
            nameEntity.title = user.name.title
            nameEntity.first = user.name.first
            nameEntity.last = user.name.last
            userProfile.name = nameEntity
            
            let locationEntity = LocationEntity(context: context)
            locationEntity.city = user.location.city
            
            userProfile.location = locationEntity
            
            let pictureEntity = PictureEntity(context: context)
            pictureEntity.large = user.picture.large
            pictureEntity.medium = user.picture.medium
            pictureEntity.thumbnail = user.picture.thumbnail
            userProfile.picture = pictureEntity
        }
        saveContext()
    }
    
    private func saveDecisionToCoreData(profile: User) {
        
    }
    
    // Fetch profiles stored in Core Data
    func fetchProfilesFromCoreData() {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        do {
            profiles = try context.fetch(fetchRequest)
        } catch { 
            self.error = .failedToFetchProfiles(error.localizedDescription)
        }
    }
    
    // Save Core Data context
    private func saveContext() {
        do {
            try context.save()
        } catch { 
            self.error = .failedToSaveProfile(error.localizedDescription)
        }
    }
}
