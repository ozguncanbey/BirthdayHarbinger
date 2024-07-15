//
//  AddNewPersonScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI

struct AddNewPersonScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: UIImage? = nil
    @State private var name = ""
    @State private var date: Date = .init()
    @State private var category: Category = .Family
    
    let startDate = Calendar.current.date(byAdding: .year, value: -124, to: Date())!
    let endDate = Date()
    
    private var isAddButtonDisable: Bool {
        name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Photo") {
                    VStack {
                        Text("selectPhotoHip")
                            .font(.system(.footnote))
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                        
                        PhotoPickerView(selectedImage: $selectedImage)
                        
                        if selectedImage != nil {
                            Button("photoButton") {
                                selectedImage = nil
                            }
                            .padding(.top)
                            .font(.callout)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowSeparator(.hidden)
                
                Section("Name") {
                    TextField("Name", text: $name)
                }
                
                Section("Birth Date") {
                    DatePicker("Birth Date", selection: $date, in: startDate...endDate, displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                
                Section() {
                    HStack {
                        Picker("Category", selection: $category){
                            ForEach(Category.selectableCategories, id: \.self) {
                                Text($0.localizedString)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("addNewPersonTitle")
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
                        let person = _Person(name: name, birthday: date, category: category.rawValue)
                        context.insert(person)
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
        .modelContainer(_Person.preview)
}
