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
    @State private var navigateToAddNewPersonScreen = false
    @State var category: Category = .All
    
    @Query(sort: \Person.birthday) private var people: [Person]
    
    private var filteredPeople: [Person] {
        if category == .All {
            return people
        } else {
            return people.filter { $0.category == category.rawValue }
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
                .onChange(of: category) {
                    withAnimation {
                        
                    }
                }
                
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
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                    .onDelete { indexSet in
                                        for index in indexSet {
                                            context.delete(filteredPeople[index])
                                        }
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
        }
    }
}

#Preview {
    ListScreen()
        .modelContainer(Person.preview)
}
