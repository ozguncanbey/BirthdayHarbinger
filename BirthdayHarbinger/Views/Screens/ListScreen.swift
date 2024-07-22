import SwiftUI
import SwiftData

struct ListScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    @State private var editMode: EditMode = .inactive
    @State private var navigateToAddNewPersonScreen = false
    @State private var navigateToSettings = false
    @State var category: Category = .All
    
    @Query private var people: [Personn]
    
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
        NavigationStack {
            VStack {
                CustomCategoryPicker(selectedCategory: $category, language: language)
                    .padding(.horizontal)
                
                TabView(selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        FilteredListView(editMode: $editMode, category: category, people: people)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                Button(action: {
                    navigateToAddNewPersonScreen = true
                }, label: {
                    Text("Add person".localized(language))
                        .font(.headline)
                        .padding(.vertical, .dHeight / 140)
                        .padding(.horizontal, .dWidth / 12)
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(20)
                })
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .navigationTitle("navigationTitle".localized(language))
            .padding(.top)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            editMode = editMode == .active ? .inactive : .active
                        }
                    }) {
                        Text(editMode == .active ? "Done".localized(language) : "Edit".localized(language))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigateToSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $navigateToAddNewPersonScreen) {
                AddNewPersonScreen()
            }
            .sheet(isPresented: $navigateToSettings) {
                SettingsScreen(people: people)
                    .presentationDetents([.height(.dHeight / 2)])
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
    }
}

#Preview {
    ListScreen()
        .modelContainer(Personn.preview)
}
