import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var network = NetworkMonitor()

    var body: some View {
    
             Group {
                 if appState.isUserLoggedIn {
                     HomeScreen().environmentObject(network) // Replace with your main app view
                 } else {
                 
                         WelcomeView(isChecked: true).environmentObject(network)
  
                 }
             }
             .onAppear {
                        // Print debug information when the view appears
                        print("ContentView isUserLoggedIn: \(appState.isUserLoggedIn)")
                    }
    }
}
