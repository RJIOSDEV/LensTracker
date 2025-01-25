import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Foundation

// Define a custom color for the theme
extension Color {
    static let themeColor = Color("themeColor") // Define this color in Assets.xcassets or use a direct color value
    static let redColor = Color.red // You can also use Color.red directly
    static let textBackground = Color("textBackground") // Define this color in Assets.xcassets
}
 var language = LocalizationService.shared.language

struct LensItem: Identifiable {
   
    var id: String // Unique identifier
    var startDate: Date
    var endDate: Date
    var lenstype: String
    
    var label1: String {
        // Calculate duration in days
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return "\(days) \("day".localized(language))"
    }
    
    var label2: String {
        // Format start date
        return DateFormatter.displayFormatter.string(from: startDate)
    }
    
    var label3: String {
        // Format end date
        return DateFormatter.displayFormatter.string(from: endDate)
    } 
    var progressPercentage: Double {
        // Calculate progress percentage
        let today = Date()
        guard today >= startDate else { return 0 }
        guard today <= endDate else { return 1 }
        
        let totalDuration = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let elapsedDuration = Calendar.current.dateComponents([.day], from: startDate, to: today).day ?? 0
        return min(Double(elapsedDuration) / Double(totalDuration), 1.0)
    }
//    var progressPercentage: Double {
//        // Calculate progress percentage
//        let today = Date()
//        guard today >= startDate else { return 0 }
//        guard today <= endDate else { return 1 }
//        
//        // Calculate total duration in days
//        let totalDuration = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
//        
//        // Guard against zero duration
//        guard totalDuration > 0 else { return 0 }
//
//        // Calculate elapsed duration in days
//        let elapsedDuration = Calendar.current.dateComponents([.day], from: startDate, to: today).day ?? 0
//        
//        // Calculate and return progress percentage
//        return min(Double(elapsedDuration) / Double(totalDuration), 1.0)
//    }
}

// Custom DateFormatter extension
extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Change according to your date format in Firestore
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM" // Desired date format
        return formatter
    }()
}

struct lensList: View {
    var language = LocalizationService.shared.language
//    private var language = LocalizationService.shared.language
    
    @State private var items: [LensItem] = [] // Use @State for dynamic data
    @State private var userName: String = "" // Default value
    @State private var isLoading: Bool = true // State to track loading
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Text("\("hi".localized(language)) \(userName)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            .padding(.top, 50) // Adjust padding as needed
                            .frame(height: 100)

                        Spacer()
                    }
                    .background(Color.themeColor)
                    .frame(width: UIScreen.main.bounds.width, height: 120)

                    if #available(iOS 15.0, *) {
                        if items.isEmpty {
                            Text("\("hi".localized(language))")
                            Text(NSLocalizedString("no_lense", comment: ""))
                                .font(.custom("Montserrat", size: 18))
                                           .font(.headline)
                                           .foregroundColor(.white)
                                           .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center the message
                                                      
                            
                        } else{
                            List(items) { item in
                                LensListItem(item: item)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            deleteItem(item.id)
                                        } label: {
                                            Label(NSLocalizedString("delete".localized(language), comment: ""), systemImage: "trash")
                                        }
                                    }
                            }
                            .listStyle(PlainListStyle()) // Use PlainListStyle to avoid default list styling
                         
                            .background(Color(UIColor.systemGray6))
                            //                .accentColor(.purple)
                            .accentColor(.themeColor)
                            .listRowSeparator(.hidden)
                        
                        }
                   
                            
                        } else {
                            // Fallback on earlier versions
                        } // Hide the separator lines
                    
                }
                .background(Color.themeColor)
                .padding(.top, 0)
                .ignoresSafeArea(.all, edges: .vertical)
                .onAppear(perform: loadData) // Load data when the view appears
                .onAppear(perform: loadUser) // Load user data when the view appears
            }
            .navigationTitle("") // Optionally set an empty title
            .navigationBarHidden(true) // Hide the navigation bar
        } else {
            // Fallback on earlier versions
        }
    }

    private func loadUser() {
      
      
   
//            print(auth.currentUser?.uid)
//            print(snapshot?.documents.first?.get("name"))
            print("222222222")
            fetchUserData()
        
    }
    
    


    func fetchUserData() {
        let db = Firestore.firestore()
        let auth = Auth.auth()

        // Ensure that `auth` and `firestore` are properly initialized
        guard let uid = auth.currentUser?.uid else {
            print("No current user UID available.")
            return
        }

        print("Current User UID: \(uid)")

        // Fetch documents from Firestore
        db.collection("appeUser").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            if let documents = snapshot?.documents {
                var userFound = false
                for document in documents {
                    let documentID = document.documentID
                    print("Checking Document ID: \(documentID)")
                    if documentID == uid {
                        let data = document.data()
                        let name = data["name"] as? String ?? "Unknown"
                        print("Document ID: \(documentID), Name: \(name)")
                        userName = name // Assuming userName is a variable defined elsewhere
                        userFound = true
                        break // Exit the loop if a match is found
                    }
                }
                if !userFound {
                    print("No matching document found for UID: \(uid)")
                }
            } else {
                print("No documents found.")
            }
        }
    }

    
    
    private func deleteItem(_ id: String) {
        let db = Firestore.firestore()
        db.collection("lensData").document(id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                // Remove the item from the local state
                if let index = items.firstIndex(where: { $0.id == id }) {
                    items.remove(at: index)
                }
                print("Document successfully removed!")
            }
        }
    }

    private func loadData() {
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        guard let uid = auth.currentUser?.uid else {
            isLoading = false
            return
        }
        
        // Fetch lens data
        db.collection("lensData")
            .whereField("UID", isEqualTo: uid)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.items = querySnapshot?.documents.compactMap { document in
                        let data = document.data()
                        
                        // Handle Firestore timestamp or string conversion
                        let startDateTimestamp = data["startDate"] as? Timestamp
                        let endDateTimestamp = data["endDate"] as? Timestamp
                        let type = data["lensType"] as? String ?? ""
                        let id = document.documentID // Use document ID as a unique identifier
                        
                        let startDate = startDateTimestamp?.dateValue() ?? Date()
                        let endDate = endDateTimestamp?.dateValue() ?? Date()
                        
                        // Ensure you map each field correctly
                        return LensItem(id: id, startDate: startDate, endDate: endDate, lenstype: type)
                    } ?? []
                }
                
                isLoading = false // Set loading to false after data fetch is complete
            }
    }
}

struct LensListItem: View {
     var language = LocalizationService.shared.language
    let item: LensItem

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // First Image
                Image("receipt") // Replace with actual image asset name
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 2) // Adjust padding as needed
                
                // Text
                Text("\("lens_type".localized(language)) \(item.lenstype)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                
                // Second Image
                Image("downArrow") // Replace with actual image asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .padding(.leading, 8)
            .padding(.trailing, 12)
            
            HStack {
                // Percentage bar
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(Color.themeColor) // Use theme color for the background circle
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(item.progressPercentage))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .foregroundColor(item.progressPercentage == 1.0 ? Color.redColor : Color.themeColor) // Conditional color
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(item.progressPercentage * 100))%")
                        .font(.headline)
                        .bold()
                }
                .frame(width: 70, height: 70)
                .padding(.leading, 12)
                .padding(.bottom, 12)
                .padding(.trailing, 12)

                // Labels on the right
                VStack(alignment: .leading, spacing: 4) {
                    Text("\("in_Use".localized(language)) \(item.label1)") // Duration in days
                    Text("\("since".localized(language))  \(item.label2)") // Formatted start date
                    Text("\("until".localized(language))  \(item.label3)") // Formatted end date
                }
                .font(.subheadline)
                .foregroundColor(.black)
            }
            .padding(.leading, 8)
            .padding(.bottom, 12)
            .padding(.trailing, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.textBackground) // Background color for each list item
        .cornerRadius(12) // Apply rounded corners
        .shadow(radius: 5) // Optional: Add shadow for better visibility
        .padding(.vertical, 4) // Optional: Add vertical padding between items
    }
}

struct LensList_Previews: PreviewProvider {
    static var previews: some View {
        lensList()
    }
}
