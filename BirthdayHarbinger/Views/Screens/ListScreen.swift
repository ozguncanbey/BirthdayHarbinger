//
//  ListScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI

struct ListScreen: View {
    @StateObject var viewModel = ListViewModel()
    @State private var navigateToAddNewPersonScreen = false
    @State private var category: Category = .All
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("", selection: $category) {
                    ForEach(Category.allCases, id: \.self) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: category) {
                    viewModel.filterPeople(by: category)
                }
                
                if viewModel.peopleSortedByDaysLeft().isEmpty {
                    
                    ContentUnavailableView("There is nobody", systemImage: "person.slash.fill", description: Text("Add someone to see"))
                    
                } else {
                    LazyVStack {
                        ForEach(viewModel.peopleSortedByDaysLeft()) { person in
                            ListCell(person: person)
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Happy Birthday")
            .padding(.top)
            .sheet(isPresented: $navigateToAddNewPersonScreen) {
                AddNewPersonScreen()
                    .onDisappear {
                        viewModel.getPeople()
                    }
            }
            
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
        .onAppear {
            viewModel.filterPeople(by: category)
        }
    }
}

#Preview {
    ListScreen()
}
