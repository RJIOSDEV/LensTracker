import SwiftUI
import Firebase
import FirebaseFirestore

struct signupScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome = false
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var keyboardHeight: CGFloat = 100 // Track the keyboard height
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isChecked: Bool = false
    @State private var errorText: String = ""
    @State private var showAlert = false
    @State private var shouldAnimate = false
    let textBackgroundColor = UIColor(named: "textBackground") ?? .white
    let textfiledBack = UIColor(named: "Mvolor") ?? .white
    let themeColor = UIColor(named: "themeColor") ?? .white

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack {
                    Color.white // Set background color to white
                    
                    VStack {
                        Spacer(minLength: 10)
                        
                        VStack() {
                            Image("logo") // Replace with your image name
                                .aspectRatio(contentMode: .fit)
                                .padding(.top,0)
                                .padding(.leading, 50)
                                .frame(maxHeight: 200)
                                .frame(maxWidth: .infinity)
                        }
                        
                        VStack {
                            Text("GetStarted".localized(language))
                                .font(.custom("Montserrat", size: 36))
                                .padding(.bottom, 0)

                            Text("by_creating".localized(language))
                                .foregroundColor(.gray)
                                .font(.custom("Montserrat", size: 16))
                        }
                        .padding(.top,-95)

                        VStack(spacing: 20) {
                            ZStack(alignment: .trailing) {
                                       TextField("fullname".localized(language), text: $username)
//                                           .padding(.horizontal, 40) // Add extra padding to accommodate the icon
                                           .padding()
                                           .background(Color(textfiledBack))
                                           .foregroundColor(.black)
                                           .cornerRadius(16)
                                           .overlay(
                                               RoundedRectangle(cornerRadius: 16)
                                                   .stroke(Color.black, lineWidth: 1)
                                           )
                                           .frame(height: 50)
                                           .padding(.horizontal)
                                       
                                         Image("man") // Replace with your desired icon
                                           .foregroundColor(.black)
                                           .padding(.trailing, 36) // Adjust as needed to position the icon correctly
                                   }
                                   .frame(height: 50)
                            
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
                            

                            ZStack(alignment: .trailing) {
                             
                                SecureField("Confirm_Password".localized(language), text: $confirmPassword)
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
                                            .foregroundColor(isChecked ? Color(themeColor) : .gray)
                                            .font(.system(size: 12))
                                        Text("terms".localized(language))
                                            .font(.system(size: 9))
                                            .foregroundColor(.black)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 50)
                            .padding(.vertical, 3)

                            Text(errorText)
                                .foregroundColor(.red)

//                            actIndSignup(shouldAnimate: $shouldAnimate)
                        }
                        .padding(.horizontal, 30)

                        VStack {
                            HStack {
                                Button(action: {
                                    if self.password == self.confirmPassword {
                                        if self.isChecked {
                                            self.shouldAnimate = true
                                            self.signUp(email: self.email, password: self.password)
                                        } else {
                                            self.errorText = "please_agree".localized(language)
                                        }
                                    } else {
                                        self.errorText = "no_match".localized(language)
                                    }
                                }) {
                                    Text("Next".localized(language))
                                        .font(.custom("Montserrat", size: 20))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .frame(minHeight: 50)
                                .padding(.horizontal, 120)
                                .background(Color(themeColor))
                                .cornerRadius(10)
                            }
                            
                            HStack {
                                Button(action: {
                                    // Handle forgot password action
                                }) {
                                    Text("already".localized(language))
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
                    }
                    .ignoresSafeArea(.all, edges: .vertical)
                    .padding(.top, 100)
                    .padding(.bottom, keyboardHeight)
                    
                }
                .onAppear {
                             // Subscribe to keyboard notifications
                             let center = NotificationCenter.default
                             center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                                 withAnimation {
                                     self.keyboardHeight = 300 // Adjust based on your keyboard height
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
                     
                .alert(isPresented: $showAlert, content: { self.alert })
                NavigationLink(
                    destination: WelcomeView(isChecked: false),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        } else {
            // Fallback on earlier versions
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.errorText = error?.localizedDescription ?? "Unknown error"
                self.shouldAnimate = false
                return
            }

            // Create Firestore document
            let db = Firestore.firestore()
            let userRef = db.collection("appeUser").document(user.uid)

            let userData: [String: Any] = [
                "uid":user.uid,
                "name": self.username,
                "email": self.email,
                "created_at": Timestamp()
            ]

            userRef.setData(userData) { error in
                if let error = error {
                    self.errorText = error.localizedDescription
                } else {
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if let error = error {
                            self.errorText = error.localizedDescription
                        } else {
                            self.showAlert = true // Use assignment to trigger alert
                        }
                        self.shouldAnimate = false
                    }
                }
            }
        }
    }

    var alert: Alert {
        Alert(
            title: Text("verifyMAil".localized(language)),
            message: Text("accountconfirm".localized(language)),
            dismissButton: .default(Text("dissmiss".localized(language))) {
                // Reset the fields and dismiss the alert
                self.email = ""
                self.username = ""
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
}

struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        signupScreen()
    }
}
