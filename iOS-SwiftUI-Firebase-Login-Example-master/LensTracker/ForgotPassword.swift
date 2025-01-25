import SwiftUI
import Firebase


struct ForgotPassword: View {
     var language = LocalizationService.shared.language
    @State private var navigateToHome = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var rememberMe: Bool = false
    @State private var signUpIsPresent: Bool = false
    @State private var signInIsPresent: Bool = false
    @State private var viewState = CGSize.zero
    @State private var errorText: String = ""
    @State private var showAlert = false
    @State private var keyboardHeight: CGFloat = 100 // Track the keyboard height
    @State private var MainviewState = CGSize.zero
    let textBackgroundColor = UIColor(named: "textBackground") ?? .white
    let themeColor = UIColor(named: "themeColor") ?? .white
    let textfiledBack = UIColor(named: "Mvolor") ?? .white
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
 
    @State var isChecked: Bool
    var body:
    
    some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                ZStack {
                    Color.white // Set background color to white
                    
                    if Auth.auth().currentUser != nil {
                        VStack {
                            // Logged in view
                            Button(action: {
                                do {
                                    try Auth.auth().signOut()
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                            }) {
                                Text("logout".localized(language))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .background(Color.green)
                            .cornerRadius(5)
                            .padding()
                        }
                        .edgesIgnoringSafeArea(.top)
                        .offset(x: self.MainviewState.width)
//                        .animation(.spring())
                    } else {
                        if #available(iOS 14.0, *) {
                            VStack {
                                
                                
                                VStack() {
                                    Image("logo") // Replace with your image name
//                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.top,0)
//                                        .padding(.bottom,50)
                                        .padding(.leading, 50)
                                        .padding(.top, 0)
                                        .frame(maxHeight: 200)
                                        .frame(maxWidth: .infinity)
                           
                                    
                                }
                                
                                
                                VStack(content: {
                                    
                                    Text("Forgot".localized(language))
                                        .foregroundColor(.black) // Text color
                                        .font(.custom("Montserrat", size: 24))
//                                        .foregroundColor(.white)
                                        .padding(.bottom,6)
                                    
                                    // Adjusted font size
                                    //                            Spacer(minLength: 0)
                                    Text("reset".localized(language))
                                        .foregroundColor(.gray)
                                 // Text color
                                        .font(.custom("Montserrat", size: 16))
//                                        .foregroundColor(.white)// Adjusted font size size as needed
                                 
                                })
                                .padding(.top,-90)
                                //                        Spacer(minLength: 10)
                                
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
                                    

                                  
//                                    ZStack(alignment: .trailing) {
//                                     
//                                        SecureField("Password", text: $password)
//                                            .padding()
//                                            .background(Color(textfiledBack))
//            //                                .opacity(0.2)
//                                            .foregroundColor(.black)
//                                            .cornerRadius(16)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 16)
//                                                    .stroke(Color.black, lineWidth: 1)
//                                            )
//                                            .padding(.horizontal)
//                                            .frame(height: 50)
//                                               
//                                                 Image("Lock") // Replace with your desired icon
//                                                   .foregroundColor(.black)
//                                                   .padding(.trailing, 36) // Adjust as needed to position the icon correctly
//                                           }
//                                           .frame(height: 50)
                                    

//                                    ZStack(alignment: .trailing) {
//                                     
//                                        SecureField("Confirm Password", text: $confirmPassword)
//                                            .padding()
//                                            .background(Color(textfiledBack))
//            //                                .opacity(0.2)
//                                            .foregroundColor(.black)
//                                            .cornerRadius(16)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 16)
//                                                    .stroke(Color.black, lineWidth: 1)
//                                            )
//                                            .padding(.horizontal)
//                                            .frame(height: 50)
//                                               
//                                                 Image("Lock") // Replace with your desired icon
//                                                   .foregroundColor(.black)
//                                                   .padding(.trailing, 36) // Adjust as needed to position the icon correctly
//                                           }
                                           .frame(height: 50)


                            
                                    HStack {
                                        Button(action: {
                                            self.isChecked.toggle()
                                        }) {
                                            HStack(spacing: 0) {
                                                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                                    .foregroundColor(isChecked ? Color(themeColor) : .gray)
                                                    .font(.system(size: 12))
                                                Text("terms".localized(language)) .font(.system(size: 9))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        Spacer()
                             
                                    }
//                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 3)
                                    .padding(.bottom, 50)
                                    .padding(.leading, 60)
                                    
                                    Text(errorText)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 30)
                                .padding(.top, 0)
                                .padding(.bottom, 200)
                                
                                
                                
                                
                                HStack(content: {
                                    Button(action: {
                                        
                                      

                                     handlePasswordReset()
                                        appState.isUserLoggedIn = false
                                        
                                        // Update app state to reflect that the user is logged out
                                  
                                          
                                          // Clear login status in UserDefaults
                                          UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                                        // Handle login action
                                    }) {
                                        Text("Next".localized(language)) .font(.system(size: 18))
                                            .font(.custom("Montserrat", size: 20))
                                    
                                            .foregroundColor(.white)
                                            
                                            .padding(.vertical,8)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)

                                    }
                                    .frame(minHeight: 50)
                                    .padding(.horizontal,120)
                                    .background(Color(themeColor))
                                    .cornerRadius(10)
                           
                           
                                    .alert(isPresented: $showAlert, content: { self.alert })
                                }
                                )
                                HStack {
                                    Button(action: {
                                        // Handle forgot password action
                                    }) {
                                        Text("backto".localized(language))
                                            .foregroundColor(.black)
                                            .font(.custom("Montserrat", size: 13))
                                            .foregroundColor(.white)
                                    }
                                    Button(action: {
                                        navigateToHome = true
                                    }) {
                                        Text("login".localized(language))
                                            .foregroundColor(Color(themeColor))
                                            .font(.custom("Montserrat", size: 13))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
            
            .onAppear {
                         // Subscribe to keyboard notifications
                         let center = NotificationCenter.default
                         center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                             withAnimation {
                                 self.keyboardHeight = 100 // Adjust based on your keyboard height
                             }
                         }
                         center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                             withAnimation {
                                 self.keyboardHeight = 100
                             }
                         }
                     }
                     .onDisappear {
                         // Remove observers
                         NotificationCenter.default.removeObserver(self)
                     }
                 
            
            NavigationLink(
                destination: WelcomeView(isChecked: false),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        
        .navigationBarHidden(true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    var alert: Alert {
        Alert(
            title: Text("Forgot".localized(language)),
            message: Text("wesentpassword".localized(language)),
            dismissButton: .default(Text("dismiss".localized(language))) {
                // Reset the fields and dismiss the alert
                self.email = ""
            
                self.password = ""
                self.confirmPassword = ""
                self.isChecked = false
                self.errorText = ""
                self.navigateToHome = true

                // Dismiss the screen to go back
//                self.presentationMode.wrappedValue.dismiss()
            }
        )
    }
    
    
    func handlePasswordReset() {
          guard !email.isEmpty else {
              self.errorText = "enter_email".localized(language)
              return
          }
          
          // Check if email format is valid
          if !isValidEmail(email) {
              self.errorText = "badformatmail".localized(language)
              return
          }
          
          Auth.auth().sendPasswordReset(withEmail: email) { error in
              if let error = error {
                  self.errorText = handleFirebaseError(error)
//                  self.showAlert = true
              } else {
                  self.errorText = "wesentpassword".localized(language)
                  self.showAlert = true
                  
                  // Clear email field and update app state
//                  self.email = ""
//                  appState.isUserLoggedIn = false
//                  UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
              }
          }
      }
      
      func isValidEmail(_ email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
      }
      
      func handleFirebaseError(_ error: Error) -> String {
          let nsError = error as NSError
          switch nsError.code {
          case AuthErrorCode.invalidEmail.rawValue:
              return "The email address is invalid."
          case AuthErrorCode.userNotFound.rawValue:
              return "No user found with this email address."
          default:
              return error.localizedDescription
          }
      }
    
}

struct ForgotPassword_Previews: PreviewProvider {

    static var previews: some View {
        ForgotPassword(isChecked: true)
    }
}
