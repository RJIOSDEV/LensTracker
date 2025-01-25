//
//  LocalizationManager.swift
//  LensTracker
//
//  Created by Raj on 24/08/24.
//  Copyright © 2024 Bala. All rights reserved.
//

import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            // Reload app content or notify views to update
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        // Set the language for the application
        setLanguage(selectedLanguage)
    }
    
    func setLanguage(_ language: String) {
        let languageCode = language == "Hungarian" ? "hu" : "en"
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
