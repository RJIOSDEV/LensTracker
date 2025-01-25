import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Moniter")
    
    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task{
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
