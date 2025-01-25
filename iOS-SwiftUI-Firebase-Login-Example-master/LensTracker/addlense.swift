import SwiftUI
import Firebase
import FirebaseFirestore
import UserNotifications


struct addlense: View {
    @State private var navigateToDetail = false
    @State private var selectedLensType: String?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(30 * 60 * 24 * 30)
    @State private var reminderBeforeWeek: Bool = false
    @State private var reminderBeforeWeek2: Bool = false
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var selectedDays: Int = 1 // Default to 1 day
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    var body: some View {
   
            if #available(iOS 16.0, *) {
                NavigationStack {
                    VStack {
                        ZStack {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("addlense".localized(language))
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.leading, 16)
                                        .padding(.top, 70)
                                        .frame(height: 120)
                                    
                                    Image("addlense")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .padding(.top, 70)
                                        .frame(height: 120)
                                    Spacer()
                                    Text("done".localized(language))
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.trailing, 16)
                                        .padding(.top, 70)
                                        .frame(height: 120)
                                        .onTapGesture {
                                            saveLensData()
                                        }
                                }
                                .background(Color.themeColor)
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                                NavigationLink(
                                    destination:lensList(),
                                    isActive: $navigateToDetail,
                                    label: { EmptyView() }
                                )
                                
                                List {
                                    HStack {
                                        Image("logoss")
                                        Text("lens_type".localized(language))
                                        Spacer()
                                        Image("downArrow") // Replace with actual image asset name
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    // Lens Type Picker
                                    
                                    LensTypeButton(lensType: "rightlense".localized(language), selectedLensType: $selectedLensType, textColor: .black)
                                    LensTypeButton(lensType: "leftlense".localized(language), selectedLensType: $selectedLensType, textColor: .black)
                                    LensTypeButton(lensType: "bothlense".localized(language), selectedLensType: $selectedLensType, textColor: .black)

                                    
                                    
                                    // Date Pickers
                                    HStack {
                                        Image("logoss")
                                        Text("lensdate".localized(language))
                                        Spacer()
                                        Image("downArrow") // Replace with actual image asset name
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                    
                                    HStack {
                                        Button(action: {
                                            showStartDatePicker.toggle()
                                            
                                            // Handle forgot password action
                                        }) {
                                            HStack {
                                                
                                                Image("logoss")
                                                Text("\("startdate".localized(language)) \(formattedDate(startDate))") .foregroundColor(.black)
                                                Spacer()
                                                Image("calander") // Replace with actual image asset name
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                
                                            }
                                            if showStartDatePicker {
                                                DatePicker("startdate".localized(language), selection: $startDate, displayedComponents: .date)
                                                    .datePickerStyle(GraphicalDatePickerStyle())
                                                    .onChange(of: startDate) { newValue in
                                                        if endDate < newValue {
                                                            endDate = newValue
                                                        }
                                                    }
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                    .padding(.leading, 30)
                                    HStack {
                                        Button(action: {
                                            showEndDatePicker.toggle()
                                            
                                            // Handle forgot password action
                                        }) {
                                            HStack {
                                                
                                                Image("logoss")
                                                Text("\("enddate".localized(language))\(formattedDate(endDate))").foregroundColor(.black)
                                                Spacer()
                                                Image("calander") // Replace with actual image asset name
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                
                                            }
                                            if showEndDatePicker {
                                                DatePicker("\("enddate".localized(language))", selection: $endDate, in: startDate..., displayedComponents: .date)
                                                    .datePickerStyle(GraphicalDatePickerStyle())
                                            }
                                            
                                        }
                                    }
                                    .padding(.leading, 30)
                                    // Reminder Toggle
                                    reminderToggle
                                    reminderToggle2
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, -10)
                    .ignoresSafeArea(.all, edges: .vertical)
                }
                .ignoresSafeArea(.all, edges: .vertical)

                .navigationTitle("")
                .navigationBarHidden(true)

                .onAppear {
                    requestNotificationPermission()
                }
       
            }
        
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
            print("Notification permission granted: \(granted)")
        }
    }
    
    private func scheduleNotification2() {
        
        if reminderBeforeWeek2 {
            
            
            let center = UNUserNotificationCenter.current()
//            center.removeAllPendingNotificationRequests()
            // create content
            let content = UNMutableNotificationContent()
            content.title = "\("reminder".localized(language))"
            content.body =  "\("reminder_your".localized(language)) \(selectedLensType ?? "lens") \("is_about".localized(language)) \(selectedDays) \("days".localized(language)) ."
            content.categoryIdentifier = NotificationCategory.general.rawValue
            content.userInfo = ["customData": "Some Data"]
            
            if let url = Bundle.main.url(forResource: "coffee", withExtension: "png") {
                if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
                    content.attachments = [attachment]
                }
            }
            
            let reminderDate = Calendar.current.date(byAdding: .day, value: -selectedDays, to: endDate) ?? Date()
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let timeInterval = reminderDate.timeIntervalSince(Date())
                     
                     // Ensure the time interval is positive
                     guard timeInterval > 0 else {
                         toastMessage = "The reminder date is in the past."
                         showToast = true
                         return
                     }
            // create trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            // create request
            let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
            
            // define actions
            let dismiss = UNNotificationAction(identifier: NotificationAction.dimiss.rawValue, title: "Dismiss", options: [])
            
            let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
            
            let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismiss, reminder], intentIdentifiers: [], options: [])
            
            center.setNotificationCategories([generalCategory])
            
            // add request to notification center
            center.add(request) { error in
                if let error = error {
                    print(error)
                }
            }
            
            
        } else {
            //            center.removeAllPendingNotificationRequests()
        }
    }
        
        
    private func scheduleNotification() {
        
        
        
        if reminderBeforeWeek {
            
            
            let center = UNUserNotificationCenter.current()
//            center.removeAllPendingNotificationRequests()
            // create content
            let content = UNMutableNotificationContent()
            content.title = "\("reminder".localized(language))"
            content.body =  "\("reminder_your".localized(language)) \(selectedLensType ?? "lens") \("is_about".localized(language)) \("week".localized(language)) ."
        
            content.categoryIdentifier = NotificationCategory.general.rawValue
            content.userInfo = ["customData": "Some Data"]
            
            if let url = Bundle.main.url(forResource: "coffee", withExtension: "png") {
                if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
                    content.attachments = [attachment]
                }
            }
            
            let reminderDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: endDate) ?? Date()
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let timeInterval = reminderDate.timeIntervalSince(Date())
                     
                     // Ensure the time interval is positive
                     guard timeInterval > 0 else {
                         toastMessage = "The reminder date is in the past."
                         showToast = true
                         return
                     }
            // create trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            // create request
            let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
            
            // define actions
            let dismiss = UNNotificationAction(identifier: NotificationAction.dimiss.rawValue, title: "Dismiss", options: [])
            
            let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
            
            let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismiss, reminder], intentIdentifiers: [], options: [])
            
            center.setNotificationCategories([generalCategory])
            
            // add request to notification center
            center.add(request) { error in
                if let error = error {
                    print(error)
                }
            }
            
            
        } else {
            //            center.removeAllPendingNotificationRequests()
        }
    }
    
    
    
    //    private func saveLensData() {
    //        let db = Firestore.firestore()
    //        let auth = Auth.auth()
    //        let currentUser = auth.currentUser
    //        let uid = currentUser?.uid ?? "unknown"
    //
    //        // Get the current date and time
    //        let createdAt = Date()
    //
    //        // Prepare the data
    //        let lensData: [String: Any] = [
    //            "lensType": selectedLensType,
    //            "startDate": Timestamp(date: startDate),
    //            "endDate": Timestamp(date: endDate),
    //            "reminderBeforeWeek": reminderBeforeWeek,
    //            "created_at": Timestamp(date: createdAt),
    //            "UID": uid
    //        ]
    //
    //        // Add a new document with a generated ID
    //        db.collection("lensData").addDocument(data: lensData) { error in
    //            if let error = error {
    //                print("Error adding document: \(error)")
    //            } else {
    //                print("Document added successfully")
    //                navigateToDetail = true
    //            }
    //        }
    //    }
    
    
    func saveLensData() {
        // Validate inputs
        guard let lensType = selectedLensType, !lensType.isEmpty else {
            toastMessage = "Lens type is not selected"
            showToast = true
            return
        }
        
        guard endDate > startDate else {
            toastMessage = "End date must be after start date"
            showToast = true
            return
        }
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        let currentUser = auth.currentUser
        let uid = currentUser?.uid ?? "unknown"
        
        // Get the current date and time
        let createdAt = Date()
        
        // Prepare the data
        let lensData: [String: Any] = [
            "lensType": lensType,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "reminderBeforeWeek": reminderBeforeWeek,
            "created_at": Timestamp(date: createdAt),
            "UID": uid
        ]
        
        // Add a new document with a generated ID
        db.collection("lensData").addDocument(data: lensData) { error in
            if let error = error {
                toastMessage = "Error adding document: \(error.localizedDescription)"
                showToast = true
            } else {
                if(reminderBeforeWeek == true){
                    scheduleNotification()
                }
                if(reminderBeforeWeek2 == true){
                    scheduleNotification2()
                }
                toastMessage = "Document added successfully"
      
                showToast = true
                navigateToDetail = true
            }
        }
    }
    
    
    
    private var datePickers: some View {
        VStack {
            HStack {
                Button(action: {
                    showStartDatePicker.toggle()
                }) {
                    HStack {
                        Image("logoss")
                        Text("Start Date: \(formattedDate(startDate))")
                        Spacer()
                        Image("calander")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                if showStartDatePicker {
                    if #available(iOS 14.0, *) {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .onChange(of: startDate) { newValue in
                                if endDate < newValue {
                                    endDate = newValue
                                }
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .padding(.leading, 30)
            
            HStack {
                Button(action: {
                    showEndDatePicker.toggle()
                }) {
                    HStack {
                        Image("logoss")
                        Text("End Date: \(formattedDate(endDate))")
                        Spacer()
                        Image("calander")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                if showEndDatePicker {
                    if #available(iOS 14.0, *) {
                        DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .padding(.leading, 30)
        }
    }
    
    private var reminderToggle2: some View {
        
        VStack {
            HStack {
                Image("quest")
                Text("reminder".localized(language))
                Text("before".localized(language))
                    .foregroundColor(Color(.gray))
                
                // Toggle for enabling/disabling reminders
                if #available(iOS 14.0, *) {
                    Toggle(isOn: $reminderBeforeWeek2) {
                        Text("\(selectedDays)")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.themeColor))
                    .onChange(of: reminderBeforeWeek2) { value in
                        print("Reminder before week toggle is now: \(value ? "On" : "Off")")
                        
                        // Schedule notification if needed
                        // scheduleNotification()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            if reminderBeforeWeek2 {
                if #available(iOS 14.0, *) {
                    Picker(
                      "select_days".localized(language), selection: $selectedDays) {
                        ForEach(1..<13) { day in
                            Text("\(day) \("days".localized(language))").tag(day)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Change to another style if desired
                    .padding()
                } else {
                    // Fallback on earlier versions
                }
                
                Text("\("selected_rem".localized(language)) \(selectedDays) \("days".localized(language)) \("before".localized(language))")
                    .padding()
            }
        }
    }
    
    
    
    
    private var reminderToggle: some View {
        HStack {
            Image("quest")
            Text("reminderbeforeweek".localized(language))
//            Text(NSLocalizedString("before", comment: ""))
                .foregroundColor(Color(.gray))
            if #available(iOS 14.0, *) {
                Toggle("", isOn: $reminderBeforeWeek)
                    .toggleStyle(SwitchToggleStyle(tint: Color.themeColor))
                    .onChange(of: reminderBeforeWeek) { value in
                        print("Reminder before week toggle is now: \(value ? "On" : "Off")")
                        
                        
                        //                        scheduleNotification()
                    }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


struct AddLense_Previews: PreviewProvider {
    static var previews: some View {
        addlense()
    }
}
struct LensTypeButton: View {
    let lensType: String
    @Binding var selectedLensType: String?
    var textColor: Color = .black // Default text color is black


    var body: some View {
        Button(action: {
            selectedLensType = lensType
        }) {
            HStack {
                Image("receipt")
                Text(lensType)
                                  .foregroundColor(textColor)
                Spacer()
                if selectedLensType == lensType {
                    Image("check2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                } else {
                    Image("uncheck2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .contentShape(Rectangle()) // Explicitly define tap area
        }
        .padding(.leading, 30)
    }
}
