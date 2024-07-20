//
//  AddNewPersonScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI
import PhotosUI

struct AddNewPersonScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("secondAlertHour") private var saHour: Int = 0
    @AppStorage("secondAlertMinute") private var saMinute: Int = 0
    
    private let notificationManager = NotificationManager.self
    
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data?
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
                    Text("selectPhotoHip")
                        .font(.system(.footnote))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                    
                    PhotosPickerView(selectedImage: $selectedImage, selectedImageData: $selectedImageData)
                        .frame(maxWidth: .infinity)
                    
                    if selectedImageData != nil {
                        Button("removePhotoButton") {
                            selectedImage = nil
                            selectedImageData = nil
                        }
                        .frame(maxWidth: .infinity)
                        .font(.callout)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section("Name") {
                    TextField("Name", text: $name)
                }
                
                Section("Birth Date") {
                    DatePicker("Birth Date", selection: $date, in: startDate...endDate, displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .environment(\.locale, selectedLanguage == "tr" ? Locale(identifier: "tr_TR") : Locale(identifier: "en_TR"))
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
                        let person = Personn(name: name, birthday: date, category: category.rawValue)
                        person.imageData = selectedImageData
                        context.insert(person)
                        notificationManager.shared.scheduleNotification(for: person, hour: saHour, minute: saHour)
                        dismiss()
                    }
                    .disabled(isAddButtonDisable)
                }
            }
            .task(id: selectedImage) {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
}

#Preview {
    AddNewPersonScreen()
        .modelContainer(Personn.preview)
}
