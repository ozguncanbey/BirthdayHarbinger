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
                        viewModel.filterPeople(by: category)
                    }
                }
                
                TabView(selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        if viewModel.peopleSortedByDaysLeft().filter({ $0.category! == category.rawValue || category == .All }).isEmpty {
                            ContentUnavailableView("There is nobody", systemImage: "person.slash.fill", description: Text("Add someone to see"))
                                .tag(category)
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.peopleSortedByDaysLeft().filter { $0.category! == category.rawValue || category == .All }) { person in
                                        ListCell(person: person)
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
                    .onDisappear {
                        viewModel.getPeople()
                    }
            }
        }
        .onAppear {
            viewModel.filterPeople(by: category)
        }
    }
}

#Preview {
    ListScreen()
}
