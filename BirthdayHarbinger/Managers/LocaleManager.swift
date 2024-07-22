import Foundation
import SwiftUI

enum Language: String {
    case english = "en"
    case turkish = "tr"
    
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
    static let changedLanguage = Notification.Name("changedLanguage")
    
    private init() {}
    
    var language: Language {
        get {
            if let languageString = UserDefaults.standard.string(forKey: "language"),
               let savedLanguage = Language(rawValue: languageString) {
                return savedLanguage
            } else if let deviceLanguageCode = Locale.current.language.languageCode?.identifier,
                      let deviceLanguage = Language(rawValue: deviceLanguageCode) {
                return deviceLanguage
            } else {
                return .english
            }
        }
        set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocaleManager.changedLanguage, object: nil)
            }
        }
    }
}
