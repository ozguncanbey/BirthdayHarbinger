//
//  FilteredListView.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 14.07.2024.
//

import SwiftUI
import SwiftData

struct FilteredListView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var editMode: EditMode
    var category: Category
    var people: [_Person]
    
    var filteredPeople: [_Person] {
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
        List {
            ForEach(Array(filteredPeople.enumerated()), id: \.element) { index, person in
                HStack {
                    ListCell(person: person)
                    if editMode == .active {
                        Spacer()
                        Button(action: {
                            context.delete(person)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .listRowBackground(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.1))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .overlay {
            if filteredPeople.isEmpty {
                ContentUnavailableView("There is nobody", systemImage: "person.slash.fill", description: Text("Add someone to see"))
                    .offset(y: -60)
            }
        }
    }
}
