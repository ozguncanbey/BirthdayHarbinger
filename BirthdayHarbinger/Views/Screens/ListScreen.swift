//
//  ListScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI
import SwiftData

struct ListScreen: View {
    
    @Environment(\.modelContext) private var context
    @State private var editMode: EditMode = .inactive
    @State private var navigateToAddNewPersonScreen = false
    @State var category: Category = .All
    
    @Query private var people: [_Person]
    
    private var filteredPeople: [_Person] {
        let filtered = category == .All ? people : people.filter { $0.category == category.rawValue }
        
        return filtered.sorted { person1, person2 in
            guard let leftDays1 = person1.calculateLeftDays(), let leftDays2 = person2.calculateLeftDays(),
                  let days1 = Int(leftDays1), let days2 = Int(leftDays2) else {
                return false
            }
            return days1 < days2
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                CustomCategoryPicker(selectedCategory: $category)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                TabView(selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        FilteredListView(editMode: $editMode, category: category, people: people)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                Button(action: {
                    navigateToAddNewPersonScreen = true
                }, label: {
                    Text("Add person")
                        .font(.headline)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 30)
                        .background(Color(UIColor.black))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                })
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .navigationTitle("Birthdays")
            .padding(.top)
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $navigateToAddNewPersonScreen) {
                AddNewPersonScreen()
            }
        }
    }
}

#Preview {
    ListScreen()
        .modelContainer(_Person.preview)
}
