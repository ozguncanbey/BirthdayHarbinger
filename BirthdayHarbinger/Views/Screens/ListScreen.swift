import SwiftUI
import WidgetKit
import SwiftData

struct ListScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    @State private var editMode: EditMode = .inactive
    @State private var navigateToAddNewPersonScreen = false
    @State private var navigateToSettings = false
    @State private var showCelebration = false
    @State private var category: Category = .All
    
    @Query private var people: [Personn]
    
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
        NavigationStack {
            ZStack {
                VStack {
                    CustomCategoryPicker(selectedCategory: $category, language: language)
                        .padding(.horizontal)
                    
                    TabView(selection: $category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            if category != .Hidden {
                                FilteredListView(editMode: $editMode, category: category, people: people, language: language)
                            } else {
                                HiddenView(editMode: $editMode, people: people, language: language)
                            }
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
                        EditButton()
                            .environment(\.locale, LocaleManager.shared.language.locale)
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
                if showCelebration {
                    CelebrationView()
                        .transition(.opacity)
                        .zIndex(1)
                        .offset(y: -60)
                }
            }
        }
        .onAppear {
            checkForTodayBirthdays()
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
    }
    
    private func checkForTodayBirthdays() {
        for person in people {
            if person.calculateLeftDays() == "0" {
                withAnimation {
                    showCelebration = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    withAnimation {
                        showCelebration = false
                    }
                }
                break
            }
        }
    }
}

#Preview {
    ListScreen()
        .modelContainer(Personn.preview)
}
