import SwiftUI
import FirebaseFirestoreInternal
import FirebaseAuth



@available(iOS 14.0, *)
struct setting: View {
    @State private var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en" // Load saved language or default to English
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State  var showingAlert = false
     @State  var shouldLogout = false
 
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
 
    var body: some View {
        
     
        if #available(iOS 16.0, *) {
//            @StateObject  var localizationManager = LocalizationManager()

            NavigationStack{
                VStack{
                    ZStack{
                        VStack(spacing: 0){
                            // Top Bar
                            HStack {
                                Text("settings".localized(language))
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.leading, 16)
                                    .padding(.top, 50) // Adjust padding as needed
                                    .frame(height: 100)
                                
                                Spacer()
                            }
                            .background(Color.themeColor)
                            .frame(width: UIScreen.main.bounds.width, height: 120)
                            
                            
                            
                            List {
                                
                                HStack {
                                    Image("quest")
                                    Text("language".localized(language))
                                    Spacer()
                                    Image("downArrow") // Replace with actual image asset name
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                    
                                }
                                
                                HStack {
                                                 Image("receipt")
                                                 Text("English")
                                                 Spacer()
                                                 Image(systemName: selectedLanguage == "en" ? "checkmark.circle.fill" : "circle")
                                                     .resizable()
                                                     .scaledToFit()
                                                     .frame(width: 24, height: 24)
                                                     .foregroundColor(selectedLanguage == "en" ? .themeColor : .gray)
                                             }
                                             .padding(.leading, 30)
                                             .onTapGesture {
                                                 selectedLanguage = "en";
//                                                 localizationManager.selectedLanguage = "en"
                                                 saveSelectedLanguage()
                                                 LocalizationService.shared.language = .english_us
                                             }
                                             
                                             // Hungarian Option
                                             HStack {
                                                 Image("receipt")
                                                 Text("Hungarian".localized(language))
                                                 Spacer()
                                                 Image(systemName: selectedLanguage == "hu" ? "checkmark.circle.fill" : "circle")
                                                                 .resizable()
                                                                 .scaledToFit()
                                                                 .frame(width: 24, height: 24)
                                                                 .foregroundColor(selectedLanguage == "hu" ? .themeColor : .gray)
                                                          }
                                             .padding(.leading, 30)
                                             .onTapGesture {
                                                 selectedLanguage = "hu"
//                                                 localizationManager.selectedLanguage = "hu"
                                                 saveSelectedLanguage()
                                                 LocalizationService.shared.language = .hungarian
                                             }
                                     
                                
                                Button(action: {
                                    // Show the alert
                                    showingAlert = true
                                }) {
                                    HStack {
                                        Image("logoss") // Replace with your actual image name
                                        Text("logout".localized(language)).foregroundStyle(Color.black)
                                    }
                                }
                                .alert("areyousurelogout",isPresented: $showingAlert) {
                                    
                                    Button("Yes".localized(language), role: .destructive) {
                                        print("Logout action triggered")
                                        handleLogout()
                                    }
                                    Button("cancel".localized(language), role: .cancel) {}
                                }
                                
                                
                                
                                
                                Button(action: {
                                    // Show the alert
                                    shouldLogout = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash") // Replace with your actual image name
                                        Text("deleteAccount".localized(language)).foregroundStyle(Color.black)
                                    }
                                }
                                .alert("areyousuredelete".localized(language),isPresented: $shouldLogout) {
                                    
                                    Button("Yes".localized(language), role: .destructive) {
                                        print("Logout action triggered")
                                        deleteUserAccount()
                                    }
                                    Button("cancel".localized(language), role: .cancel) {}
                                }
                            
                                
                                
                                //                                    NavigationLink(
                                //                                        destination: WelcomeView(isChecked: false),
                                //                                        isActive: $shouldNavigateToLogin,
                                //                                        label: { EmptyView() }
                                //                                    )
                                
                            }
                        
                            
                            Spacer()
                              }
                        
                    }
                    .background(Color(UIColor.systemGray6))
                    //                .accentColor(.purple)
                    .accentColor(.themeColor)
                    Spacer()
                }
                
            }
            .padding(.top, -70)
            .ignoresSafeArea(.all, edges: .vertical)
            //            .animation(.spring())
            //            .background(Color.themeColor)
            
            .navigationTitle("") // Optionally set an empty title
            .navigationBarHidden(true) //
            
        } else {
            // Fallback on earlier versions
        }
    }
 
    func saveSelectedLanguage() {
         UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
     }
    
    private func deleteUserAccount() {
           guard let user = Auth.auth().currentUser else {
               // No user is logged in
               return
           }
           
           let db = Firestore.firestore()
        Auth.auth().currentUser?.delete()
        // User deleted successfully
        print("User deleted successfully")
        // Optionally navigate to a different screen or show a confirmation
        appState.isUserLoggedIn = false
        // Update app state to reflect that the user is logged out
  
          
          // Clear login status in UserDefaults
          UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        navigateToLoginScreen()
           // Remove user data from Firestore
           db.collection("appeUser").document(user.uid).delete { error in
               if let error = error {
                   print("Error removing user data from Firestore: \(error.localizedDescription)")
                   // Handle the error (e.g., show a toast or alert)
                   return
               }
               
               // Delete user from Firebase Authentication
               user.delete { error in
                   if let error = error {
                       print("Error deleting user from Firebase Authentication: \(error.localizedDescription)")
                       // Handle the error (e.g., show a toast or alert)
                       return
                   }
                   
  
               }
           }
       }
    
    private func handleLogout() {
        do {
            print("ijref")
            try Auth.auth().signOut()
            appState.isUserLoggedIn = false
            // Update app state to reflect that the user is logged out
      
              
              // Clear login status in UserDefaults
              UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            navigateToLoginScreen()
                  
              
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    private func navigateToLoginScreen() {
//        shouldNavigateToLogin = true
        // Example of navigating to the login screen
        // You need to replace this with your actual navigation logic
        // For instance, use a NavigationLink, presenting a new view, etc.
        // If using a navigation stack, you might use a state variable to trigger navigation
        
        // Example:
        // shouldNavigateToLogin = true
    }
//    private func handleLogout() {
//        // Set the state to trigger navigation to the login page
//        shouldNavigateToLogin = true
//
//        // Additional logout logic, if any
//        // For example, clearing user session or credentials
//    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            setting()
        } else {
            // Fallback on earlier versions
        }
    }
}




