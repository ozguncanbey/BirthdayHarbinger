import SwiftUI
import WidgetKit
import SwiftData
import LocalAuthentication

struct HiddenView: View {
    @Environment(\.modelContext) private var context
    
    @Binding var editMode: EditMode
    
    @State var people: [Personn]
    @State private var showingBiometricAuth = true
    @State private var authSuccess = false
    @State private var showTryAgainButton = false
    
    @State private var showAlert = false
    @State private var alertType: AlertType = .delete
    @State private var personToDelete: Personn?
    @State private var personToUnhide: Personn?
    
    var language: Language
    
    private let notificationManager = NotificationManager.shared
    
    private var alertMessage: String {
        switch alertType {
        case .delete:
            return language == .turkish ? "\(personToDelete?.name ?? "bu kişiyi") silmek istediğinizden emin misiniz?" : "Are you sure you want to delete \(personToDelete?.name ?? "this person")?"
        case .hide:
            return language == .turkish ? "\(personToUnhide?.name ?? "bu kişiyi") geri almak istediğinizden emin misiniz?" : "Are you sure you want to unhide \(personToUnhide?.name ?? "this person")?"
        }
    }
    
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
                        HStack {
                            ListCell(person: person, language: language)
                            if editMode == .active {
                                Spacer()
                                VStack(spacing: 10) {
                                    PinButton(person: person)
                                    HideButton(person: person, showAlert: $showAlert, alertType: $alertType, personToHide: $personToUnhide)
                                    DeleteButton(person: person, showAlert: $showAlert, alertType: $alertType, personToDelete: $personToDelete)
                                }
                            }
                        }
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertType == .delete ? "alertTitle".localized(language) : "unhideAlertTitle".localized(language)),
                        message: Text(alertMessage),
                        primaryButton: .destructive(Text(alertType == .delete ? "Delete".localized(language) : "Unhide".localized(language))) {
                            switch alertType {
                            case .delete:
                                if let personToDelete = personToDelete {
                                    if let index = people.firstIndex(where: { $0.id == personToDelete.id }) {
                                        people.remove(at: index)
                                    }
                                    context.delete(personToDelete)
                                    notificationManager.removeNotifications(for: personToDelete)
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            case .hide:
                                if let personToUnhide = personToUnhide {
                                    personToUnhide.isHidden.toggle()
                                    try? context.save()
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            } else {
                VStack {
                    ContentUnavailableView {
                        Label("Use Biometric Pass to Unlock".localized(language), systemImage: "lock.fill")
                    } description: {
                        Text("")
                    } actions: {
                        if showTryAgainButton {
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

//#Preview {
//    HiddenView(editMode: Binding<EditMode>, people: [], language: .english)
//}
