import SwiftUI
import SwiftData
import LocalAuthentication

struct HiddenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @State var people: [Personn]
    @State private var showingBiometricAuth = true
    @State private var authSuccess = false
    @State private var showTryAgainButton = false
    
    var language: Language
    
    private var hiddenPeople: [Personn] {
        let hidden = people.filter { $0.isHidden }
        
        return hidden.sorted { person1, person2 in
            if person1.isPinned && !person2.isPinned {
                return true
            } else if !person1.isPinned && person2.isPinned {
                return false
            } else {
                guard let leftDays1 = person1.calculateLeftDays(), let leftDays2 = person2.calculateLeftDays(),
                      let days1 = Int(leftDays1), let days2 = Int(leftDays2) else {
                    return false
                }
                return days1 < days2
            }
        }
    }
    
    var body: some View {
        VStack {
            if authSuccess {
                List {
                    ForEach(Array(hiddenPeople.enumerated()), id: \.element) { index, person in
                        ListCell(person: person, language: LocaleManager.shared.language)
                            .listRowBackground(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.1))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if hiddenPeople.isEmpty {
                        ContentUnavailableView("There is nobody".localized(language), systemImage: "person.slash.fill", description: Text("Add someone to see".localized(language)))
                            .offset(y: -60)
                    }
                }
            } else {
                VStack {
                    ContentUnavailableView {
                        Label("Use Biometric Pass to Unlock".localized(language), systemImage: "lock.fill")
                    } description: {
                        Text("")
                    } actions: {
                        Button("Try Again".localized(language)) {
                            authenticateUser { success in
                                if success {
                                    authSuccess = true
                                } else {
                                    authSuccess = false
                                    showTryAgainButton = true
                                }
                            }
                        }
                    }
                }
                .offset(y: -60)
            }
        }
        .onAppear {
            if showingBiometricAuth {
                authenticateUser { success in
                    if success {
                        authSuccess = true
                    } else {
                        authSuccess = false
                        showTryAgainButton = true
                    }
                    showingBiometricAuth = false
                }
            }
        }
    }
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Access your hidden people"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }
}

#Preview {
    HiddenView(people: [], language: .english)
}
