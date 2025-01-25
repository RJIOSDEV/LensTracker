import SwiftUI
import FirebaseCore

@available(iOS 14.0, *)
@main
struct YourApp: App {
    private var delegate: NotificationDelegate = NotificationDelegate()
//    @StateObject private var localizationManager = LocalizationManager()
     
    init() {
        FirebaseApp.configure()
      
          
        print("Current language: \(UserDefaults.standard.string(forKey: "selectedLanguage") ?? "Unknown")")

              let center = UNUserNotificationCenter.current()
              center.delegate = delegate
              center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
                  if let error = error {
                      print(error)
                  }
              }
        for familyName in UIFont.familyNames {
            print("Family: \(familyName)")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("Font: \(fontName)")
            }
        }

            
//        (any App).registerForRemoteNotifications()
    }
    @StateObject private var appState = AppState()
   
    var body: some Scene {
    
        WindowGroup {
            
            ContentView()
                .environmentObject(appState) // Inject AppState environment object
            
        }
        
    }
    
}
