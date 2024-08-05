import SwiftUI
import SwiftData

struct HiddenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @State var people: [Personn]
    @State private var showingBiometricAuth = true
    @State private var authSuccess = false
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(people.enumerated()), id: \.element) { index, person in
                    ListCell(person: person, language: LocaleManager.shared.language)
                        .listRowBackground(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.1))
                        .listRowSeparator(.hidden)
                }
            }
            .onAppear {
                loadHiddenPeople()
            }
        }
    }
    
    @MainActor private func loadHiddenPeople() {
        do {
            let container = try ModelContainer(for: Personn.self)
            let fetchDescriptor = FetchDescriptor<Personn>(predicate: #Predicate { $0.isHidden })
            let people = try container.mainContext.fetch(fetchDescriptor)
            self.people = people
        } catch {
            print("Error loading hidden people: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HiddenView(people: [])
}
