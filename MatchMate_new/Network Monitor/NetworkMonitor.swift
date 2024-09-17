import Foundation
import Combine
import Network

class NetworkReachability: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    
    @Published var isReachable: Bool = true
    private var reachabilitySubject = PassthroughSubject<Bool, Never>()
    
    var reachabilityPublisher: AnyPublisher<Bool, Never> {
        reachabilitySubject.eraseToAnyPublisher()
    }
    
    init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let reachable = path.status == .satisfied
            DispatchQueue.main.async {
                self?.isReachable = reachable
                self?.reachabilitySubject.send(reachable)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
