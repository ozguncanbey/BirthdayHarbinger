//
//  EditButtons.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.08.2024.
//

import SwiftUI

struct PinButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    
    var body: some View {
        Button(action: {
            person.isPinned.toggle()
            try? context.save()
        }) {
            Image(systemName: person.isPinned ? "pin.fill" : "pin")
                .foregroundColor(.blue)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct HideButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    @Binding var showAlert: Bool
    @Binding var alertType: AlertType
    @Binding var personToHide: Personn?
    
    var body: some View {
        Button(action: {
            personToHide = person
            alertType = .hide
            showAlert = true
        }) {
            Image(systemName: person.isHidden ? "eye.slash.fill" : "eye.slash")
                .foregroundColor(.blue)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct DeleteButton: View {
    @Environment(\.modelContext) private var context
    var person: Personn
    @Binding var showAlert: Bool
    @Binding var alertType: AlertType
    @Binding var personToDelete: Personn?
    
    var body: some View {
        Button(action: {
            personToDelete = person
            alertType = .delete
            showAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
