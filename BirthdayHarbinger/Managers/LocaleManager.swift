//
//  LocaleManager.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 18.07.2024.
//

import SwiftUI

enum AppLanguage {
    case english
    case turkish
    
    var locale: Locale {
        switch self {
        case .english:
            return Locale(identifier: "en")
        case .turkish:
            return Locale(identifier: "tr")
        }
    }
}


final class LocaleManager {
    
    static let shared = LocaleManager()
    private init() {}
    
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    var currentLanguage: AppLanguage {
        get {
            return selectedLanguage == "tr" ? .turkish : .english
        }
        set {
            switch newValue {
            case .english:
                selectedLanguage = "en"
            case .turkish:
                selectedLanguage = "tr"
            }
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
