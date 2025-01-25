//
//  appstate.swift
//  FirebaseLogin
//
//  Created by Raj on 16/08/24.
//  Copyright © 2024 Bala. All rights reserved.
//

import SwiftUI

class AppState: ObservableObject{
@Published var isUserLoggedIn: Bool {
   
    didSet {
        print("App state file1 \(isUserLoggedIn)")
        // Save the updated login state to UserDefaults
        UserDefaults.standard.set(isUserLoggedIn, forKey: "isUserLoggedIn")
    }
}

init() {
 
    // Read the authentication state from UserDefaults
    self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    print("App state file2 \(self.isUserLoggedIn)")
}
}
