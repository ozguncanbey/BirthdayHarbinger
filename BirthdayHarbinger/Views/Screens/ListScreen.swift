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
    @State private var deletingPerson: _Person?
    @State private var showAlert = false
    @State private var navigateToAddNewPersonScreen = false
    @State var category: Category = .All
    
    @Query(sort: \_Person.birthday) private var people: [_Person]
    
    private var filteredPeople: [_Person] {
        let filtered = category == .All ? people : people.filter { $0.category == category.rawValue }
        return filtered.sorted { ($0.calculateLeftDays() ?? "") < ($1.calculateLeftDays() ?? "") }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)
                
                TabView(selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        if filteredPeople.isEmpty {
                            ContentUnavailableView("There is nobody", systemImage: "person.slash.fill", description: Text("Add someone to see"))
                                .tag(category)
                                .offset(y: -60)
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(filteredPeople) { person in
                                        ListCell(person: person)
                                            .onTapGesture {
                                                deletingPerson = person
                                                showAlert = true
                                            }
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .tag(category)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
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
            .sheet(isPresented: $navigateToAddNewPersonScreen) {
                AddNewPersonScreen()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Person"),
                    message: Text("Are you sure you want to delete this person?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let deletingPerson = deletingPerson {
                            context.delete(deletingPerson)
                            self.deletingPerson = nil
                        }
                    },
                    secondaryButton: .cancel {
                        self.deletingPerson = nil
                    }
                )
            }
        }
    }
}

#Preview {
    ListScreen()
        .modelContainer(_Person.preview)
}
