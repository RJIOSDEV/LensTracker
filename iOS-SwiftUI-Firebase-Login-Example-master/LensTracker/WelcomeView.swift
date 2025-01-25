import SwiftUI
//import AlertToast
import Firebase





public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

@available(iOS 14.0, *)
struct WelcomeView: View {
    
    @EnvironmentObject var appState: AppState
     var language = LocalizationService.shared.language
     @State private var isLoggingIn = false
    @EnvironmentObject private var networkMoniter:NetworkMonitor
    @State private var navigateToHome = false
    @State private var navigateToForgort = false
    @State private var navigateToSignup = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var signUpIsPresent: Bool = false
    @State private var signInIsPresent: Bool = false
    @State  var isChecked: Bool
    @State private var errorText: String = ""
    @State private var shouldAnimate = false
    @State private var showEmailAlert = false
    @State private var showPasswordAlert = false
    let textfiledBack = UIColor(named: "Mvolor") ?? .white
    @State private var toast : Toast? = nil
    
    let textBackgroundColor = UIColor(named: "textBackground") ?? .white
    let themeColor = UIColor(named: "themeColor") ?? .white

    var verifyEmailAlert: Alert {
        Alert(
            title: Text("Verify your Email ID"),
            message: Text("Please click the link in the verification email sent to you"),
            dismissButton: .default(Text("Dismiss")) {
                self.email = ""
                self.password = ""
                self.errorText = ""
                self.showEmailAlert = false
            }
        )
    }

    var passwordResetAlert: Alert {
        Alert(
            title: Text("Reset your password"),
            message: Text("Please click the link in the password reset email sent to you"),
            dismissButton: .default(Text("Dismiss")) {
                self.email = ""
                self.password = ""
                self.errorText = ""
                self.showPasswordAlert = false
            }
        )
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    if networkMoniter.isConnected {
                        
                            Color.white // Set background color to white
                   
                                VStack {
                                    Spacer(minLength: 10)
                                    
                                    VStack {
                                        Image("logo") // Replace with your image name
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.top, 0)
                                            .padding(.leading, 50)
                                            .frame(maxHeight: 200)
                                            .frame(maxWidth: .infinity)
                                    }
                                    
                                    VStack {
                                        Text("welcome_message".localized(language))

                                            .font(.custom("Montserrat", size: 24))
                                            .foregroundColor(.black)
                                        Text("signin_to".localized(language))
                                            .foregroundColor(.gray)
                                            .font(.custom("Montserrat", size: 16))
        //                                    .foregroundColor(.white)
                                    }
                                    .padding(.top, -80)
                                    
                                    VStack(spacing: 20) {
                                        ZStack(alignment: .trailing) {
                                            TextField("enter_email".localized(language), text: $email)
                                                .padding()
                                                .background(Color(textfiledBack))
                //                                .opacity(0.2)
                                                .foregroundColor(.black)
                                                .cornerRadius(16)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.black, lineWidth: 1)
                                                )
                                                .padding(.horizontal)
                                                .frame(height: 50)
                                                   
                                                     Image("Mail") // Replace with your desired icon
                                                       .foregroundColor(.black)
                                                       .padding(.trailing, 36) // Adjust as needed to position the icon correctly
                                               }
                                               .frame(height: 50)
                                        

                                      
                                        ZStack(alignment: .trailing) {
                                         
                                            SecureField("Password".localized(language), text: $password)
                                                .padding()
                                                .background(Color(textfiledBack))
                //                                .opacity(0.2)
                                                .foregroundColor(.black)
                                                .cornerRadius(16)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.black, lineWidth: 1)
                                                )
                                                .padding(.horizontal)
                                                .frame(height: 50)
                                                   
                                                     Image("Lock") // Replace with your desired icon
                                                       .foregroundColor(.black)
                                                       .padding(.trailing, 36) // Adjust as needed to position the icon correctly
                                               }
                                               .frame(height: 50)
                                        

                                        HStack {
                                            
                                            Button(action: {
                                                self.isChecked.toggle()
                                            }) {
                                                HStack(spacing: 0) {
                                                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                                        .foregroundColor(isChecked ? (Color(themeColor)): .gray)
                                                        .font(.system(size: 12))
                                                    Text("Rememberme".localized(language))
                                                        .font(.system(size: 9))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            Spacer()
                                            Button(action: {
                                                navigateToForgort = true
                                            }) {
                                                Text("Forget_password".localized(language))
                                                    .foregroundColor((Color(themeColor)))
                                                    .font(.system(size: 9))
                                            }
                                            NavigationLink(
                                                destination: ForgotPassword(isChecked: false),
                                                isActive: $navigateToForgort,
                                                label: { EmptyView() }
                                            )
                                        }
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 3)
                                        .padding(.bottom, 50)
                                 

                                      
//                                        AlertToast(type: .regular, title: errorText, subTitle: errorText);
                                        
                                        
//                                        Text(errorText)
//                                            .foregroundColor(.red)
//                                            .padding(.top, 5)
//                                        
                                        Button(action: {
                                            self.shouldAnimate = true
                                            self.signIn(email: self.email, password: self.password)
                                        }) {
                                            Text("Next".localized(language))
                                                .font(.custom("Montserrat", size: 20))
                                                .foregroundColor(.white)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 8)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white)
                                        }
                                        .frame(minHeight: 50)
                                        .padding(.horizontal, 120)
                                        .background(Color(themeColor))
                                        .cornerRadius(10)
        //                                .padding(.horizontal)
                                        
                                        HStack {
                                            Button(action: {
                                                // Handle forgot password action
                                            }) {
                                                Text("NewMember".localized(language))
                                                    .font(.custom("Montserrat", size: 13))
                                            
                                                    .foregroundColor(.black)
                                                
                                            }
                                            Button(action: {
                                                navigateToSignup = true
                                            }) {
                                                Text("Registernow".localized(language))
                                                    .foregroundColor(Color(themeColor))
                                                    .font(.custom("Montserrat", size: 13))
                                            }
                                        }
                                        .padding(.bottom, 100)
                                        NavigationLink(
                                            destination: signupScreen(),
                                            isActive: $navigateToSignup,
                                            label: { EmptyView() }
                                        )
                                    }
                                    
                                        .overlay(
                                            Group {
                                                if let toast = toast {
                                                    toastView(toast: Binding(
                                                        get: { toast },
                                                        set: { newValue in
                                                            // This will be called when dismissing the toast
                                                            self.toast = newValue
                                                        }
                                                    )) // Create a Binding from your optional Toast
                                                    .transition(.slide) // Add any transitions you like
                                                    .animation(.easeInOut)
                                                }
                                            }
                                        )
                                    .padding(.horizontal, 30)
                                    .padding(.top, 40)
                                    .padding(.bottom, 100)
                                    
                                    NavigationLink(
                                        destination: HomeScreen(),
                                        isActive: $navigateToHome,
                                        label: { EmptyView() }
                                    )
                                }
                                
                                .padding(.top, 200)
                                .ignoresSafeArea(.all, edges: .vertical)
                    } else {
                        VStack {
                                       LottieView(animationName: "Boat_Loader")
                                           .frame(width: 300, height: 300)
                                       
                                       Text("No Network Connection")
                                           .font(.headline)
                                           .padding()
                                   }
                        .onTapGesture {
                            networkMoniter.isConnected
                        }
                     
                        .onAppear {
                                   // Load Lottie animation file if necessary
                               }
                               .animation(.easeInOut, value: networkMoniter.isConnected)
                    }
                        
                }
        
                }
            
//            .toastView(toast: $toast)
                .alert(isPresented: $showEmailAlert, content: { self.verifyEmailAlert })
                .alert(isPresented: $showPasswordAlert, content: { self.passwordResetAlert })
                .overlay(
                    Group {
                        if shouldAnimate {
                            ProgressView()
                        }
                    }
                )
//              
            .navigationTitle("")
            .navigationBarHidden(true)
        } else {
            // Fallback on earlier versions
        }
        
            
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
       
            
            if let error = error {
                self.errorText = error.localizedDescription
                toast = Toast(message: errorText)
                self.shouldAnimate = false
                          print("Error logging in: \(error.localizedDescription)")
                      } else {
                          appState.isUserLoggedIn = true
                         
                           UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // Store login status
                     
                      }
            

            guard let user = user else { return }

            if !user.user.isEmailVerified {
                self.errorText = "verifyMAil".localized(language)
                toast = Toast(message: errorText)
                self.shouldAnimate = false
                self.showEmailAlert.toggle()
                return
            }
navigateToHome = true
            self.email = ""
            self.password = ""
            self.errorText = ""
            self.shouldAnimate = false
            self.navigateToHome = true
            appState.isUserLoggedIn = true
             UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // Store login status
       
            print("App state file login \(appState.isUserLoggedIn)")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            WelcomeView(isChecked: true)
        } else {
            // Fallback on earlier versions
        }
    }
}
enum NotificationAction: String {
    case dimiss
    case reminder
}

enum NotificationCategory: String {
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, ])
        } else {
            // Fallback on earlier versions
        }
    }
    
}
