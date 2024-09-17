import Combine
import CoreData
import UIKit
import Alamofire

class MatchViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var reachability = NetworkReachability()
    
    @Published var profiles: [UserProfile] = []  
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchProfilesFromCoreData()
    }
    
    
    
    // Fetch profiles from the API
    func fetchProfiles() {
        reachability.startMonitoring()
        guard reachability.isReachable else {
            self.errorMessage =  Constants.Errors.NO_INTERNET
            return
        }
        let url = "https://randomuser.me/api/?results=10"
        
        AF.request(url)
            .publishDecodable(type: UserResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Error fetching profiles: \(error.localizedDescription)"
                case .finished:
                    print("Finished fetching profiles")
                }
            } receiveValue: { [weak self] response in
                if let apiResponse = response.value { 
                    self?.saveProfilesToCoreData(apiResponse.results)
                    self?.fetchProfilesFromCoreData()
                } else {
                    self?.errorMessage =  Constants.Errors.NO_RESPONSE
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
    
    // Core Data Methods (next step)
    private func saveProfilesToCoreData(_ users: [User]) { 
        users.forEach { user in
            let userProfile = UserProfile(context: context)
            userProfile.gender = user.gender
            userProfile.email = user.email
            userProfile.phone = user.phone
            userProfile.cell = user.cell
            userProfile.nat = user.nat
            userProfile.status = nil // Initially no decision made
            
            //            let dobEntity = DateEntity(context: context)
            //            dobEntity.date =  user.dob.date
            //            dobEntity.age = Int32(Int16(user.dob.age))
            //            userProfile.dob = dobEntity
            //
            //            // Assign Registered Date
            //            let registeredEntity = DateEntity(context: context)
            //            registeredEntity.date =  user.registered.date
            //            registeredEntity.age = Int32(Int16(user.registered.age))
            //            userProfile.registered = registeredEntity
            //
            // Assign Name entity
            let nameEntity = NameEntity(context: context)
            nameEntity.title = user.name.title
            nameEntity.first = user.name.first
            nameEntity.last = user.name.last
            userProfile.name = nameEntity
            //
            //            // Assign Login entity
            //            let loginEntity = LoginEntity(context: context)
            //            loginEntity.uuid = user.login.uuid
            //            loginEntity.username = user.login.username
            //            loginEntity.password = user.login.password
            //            loginEntity.salt = user.login.salt
            //            loginEntity.md5 = user.login.md5
            //            loginEntity.sha1 = user.login.sha1
            //            loginEntity.sha256 = user.login.sha256
            //            userProfile.login = loginEntity
            //
            // Assign Location entity
            let locationEntity = LocationEntity(context: context)
            locationEntity.city = user.location.city
            //            locationEntity.state = user.location.state
            //            locationEntity.country = user.location.country
            //            if let postcodeInt = Int(user.location.postcode) {
            //                locationEntity.postcode = Int32(postcodeInt)  // Assuming postcode is of type Int32 in Core Data
            //            } else {
            //                locationEntity.postcode = 0  // Handle invalid or missing postcode
            //            }
            //
            //            // Assign Street entity
            //            let streetEntity = StreetEntity(context: context)
            //            streetEntity.number = Int32(user.location.street.number)
            //            streetEntity.name = user.location.street.name
            //            locationEntity.street = streetEntity
            //
            //            // Assign Coordinates entity
            //            let coordinatesEntity = CoordinatesEntity(context: context)
            //            coordinatesEntity.latitude = user.location.coordinates.latitude
            //            coordinatesEntity.longitude = user.location.coordinates.longitude
            //            locationEntity.coordinates = coordinatesEntity
            //
            //            // Assign Timezone entity
            //            let timezoneEntity = TimezoneEntity(context: context)
            //            timezoneEntity.offset = user.location.timezone.offset
            //            timezoneEntity.description_timezone = user.location.timezone.description
            //            locationEntity.timezone = timezoneEntity
            //
            userProfile.location = locationEntity
            //
            // Assign Picture entity
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
            errorMessage = "Failed to fetch profiles: \(error.localizedDescription)"
        }
    }
    
    // Save Core Data context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to save context: \(error.localizedDescription)"
        }
    }
}
