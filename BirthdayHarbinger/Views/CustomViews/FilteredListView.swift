import SwiftUI
import WidgetKit
import SwiftData

struct FilteredListView: View {
    @Environment(\.modelContext) private var context
    @Binding var editMode: EditMode
    var category: Category
    var people: [Personn]
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    private let notificationManager = NotificationManager.shared
    
    @State private var showAlert = false
    @State private var personToDelete: Personn?
    
    private var alertMessage: String {
        if Locale.current.isTurkish {
            return "\(personToDelete?.name ?? "bu kişiyi")'i silmek istediğinizden emin misiniz?"
        } else {
            return "Are you sure you want to delete \(personToDelete?.name ?? "this person")?"
        }
    }
    
    var filteredPeople: [Personn] {
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
                    ListCell(person: person)
                    if editMode == .active {
                        Spacer()
                        Button(action: {
                            person.isPinned.toggle()
                            try? context.save()
                        }) {
                            Image(systemName: person.isPinned ? "pin.fill" : "pin")
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            personToDelete = person
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("alertTitle".localized(language)),
                                message: Text(alertMessage),
                                primaryButton: .destructive(Text("Delete".localized(language))) {
                                    if let personToDelete = personToDelete {
                                        context.delete(personToDelete)
                                        notificationManager.removeNotifications(for: personToDelete)
                                        WidgetCenter.shared.reloadTimelines(ofKind: "BirthdayWidget")
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
                .listRowBackground(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.1))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .overlay {
            if filteredPeople.isEmpty {
                ContentUnavailableView("There is nobody".localized(language), systemImage: "person.slash.fill", description: Text("Add someone to see".localized(language)))
                    .offset(y: -60)
            }
        }
    }
}
