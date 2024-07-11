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
//                                            .onLongPressGesture {
//                                                deletingPerson = person
//                                                showAlert = true
//                                            }
                                            .swipeActions {
                                                Button {
                                                    deletingPerson = person
                                                    showAlert = true
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                                .tint(.red)
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
            .padding(.top)
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
