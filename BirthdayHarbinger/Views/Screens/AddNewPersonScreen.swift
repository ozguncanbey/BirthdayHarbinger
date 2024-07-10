//
//  AddNewPersonScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI

struct AddNewPersonScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var date: Date = .init()
    @State private var category: Category = .Family
    
    @ObservedObject private var viewModel = ListViewModel()
    
    let startDate = Calendar.current.date(byAdding: .year, value: -124, to: Date())!
    let endDate = Date()

    private var isAddButtonDisable: Bool {
        name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    TextField("Name", text: $name)
                }
                
                Section("Birth Date") {
                    DatePicker("Birth Date", selection: $date, in: startDate...endDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                Section() {
                    HStack {
                        Picker("Category", selection: $category){
                            ForEach(Category.selectableCategories, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Add New Person")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
//                        let person = Person(name: name, birthday: DateFormatter.custom.string(from: date), category: category.rawValue)
//                        viewModel.savePerson(person: person)
                        dismiss()
                    }
                    .disabled(isAddButtonDisable)
                }
            }
        }
    }
}

#Preview {
    AddNewPersonScreen()
}
