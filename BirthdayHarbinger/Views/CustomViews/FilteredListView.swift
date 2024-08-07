import SwiftUI
import WidgetKit
import SwiftData

struct FilteredListView: View {
    @Environment(\.modelContext) private var context
    @Binding var editMode: EditMode
    var category: Category
    var people: [Personn]
    
    var language: Language
    
    private let notificationManager = NotificationManager.shared
    
    @State private var showAlert = false
    @State private var alertType: AlertType = .delete
    @State private var personToDelete: Personn?
    @State private var personToHide: Personn?
    
    private var alertMessage: String {
        switch alertType {
        case .delete:
            return language == .turkish ? "\(personToDelete?.name ?? "bu kişiyi")'i silmek istediğinizden emin misiniz?" : "Are you sure you want to delete \(personToDelete?.name ?? "this person")?"
        case .hide:
            return language == .turkish ? "\(personToHide?.name ?? "bu kişiyi")'i gizlemek istediğinizden emin misiniz?" : "Are you sure you want to hide \(personToHide?.name ?? "this person")?"
        }
    }
    
    private var filteredPeople: [Personn] {
        let filtered = category == .All ? people : people.filter { $0.category == category.rawValue }
        
        return filtered.sorted { person1, person2 in
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
        List {
            ForEach(Array(filteredPeople.enumerated()), id: \.element) { index, person in
                HStack {
                    ListCell(person: person, language: language)
                    if editMode == .active {
                        Spacer()
                        VStack(spacing: 10) {
                            PinButton(person: person)
                            HideButton(person: person, showAlert: $showAlert, alertType: $alertType, personToHide: $personToHide)
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
            if filteredPeople.isEmpty, category != .Hidden {
                ContentUnavailableView("There is nobody".localized(language), systemImage: "person.slash.fill", description: Text("Add someone to see".localized(language)))
                    .offset(y: -60)
            } else if category == .Hidden {
                ContentUnavailableView("Locked Zone".localized(language), systemImage: "lock.fill", description: Text("Use face ID to unlock.".localized(language)))
                    .offset(y: -60)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertType == .delete ? "alertTitle".localized(language) : "hideAlertTitle".localized(language)),
                message: Text(alertMessage),
                primaryButton: .destructive(Text(alertType == .delete ? "Delete".localized(language) : "Hide".localized(language))) {
                    switch alertType {
                    case .delete:
                        if let personToDelete = personToDelete {
                            context.delete(personToDelete)
                            notificationManager.removeNotifications(for: personToDelete)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    case .hide:
                        if let personToHide = personToHide {
                            personToHide.isHidden.toggle()
                            try? context.save()
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct PinButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    
    var body: some View {
        Button(action: {
            person.isPinned.toggle()
            try? context.save()
        }) {
            Image(systemName: person.isPinned ? "pin.fill" : "pin")
                .foregroundColor(.blue)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct HideButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    @Binding var showAlert: Bool
    @Binding var alertType: AlertType
    @Binding var personToHide: Personn?
    
    var body: some View {
        Button(action: {
            personToHide = person
            alertType = .hide
            showAlert = true
        }) {
            Image(systemName: "eye.slash")
                .foregroundColor(.blue)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct DeleteButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    @Binding var showAlert: Bool
    @Binding var alertType: AlertType
    @Binding var personToDelete: Personn?
    
    var body: some View {
        Button(action: {
            personToDelete = person
            alertType = .delete
            showAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
