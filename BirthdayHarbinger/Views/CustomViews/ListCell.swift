//
//  ListCell.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI

struct ListCell: View {
    let person: _Person
    var isBirthdayToday: Bool
    
    init(person: _Person) {
        self.person = person
        self.isBirthdayToday = person.calculateLeftDays() == "0"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading)
                
                HStack {
                    Text(DateFormatter.custom.string(from: person.birthday))
                        .font(.system(size: 14, weight: .medium))
                        .padding(.leading)
                    
                    if isBirthdayToday {
                        Text("Happy Birthday!")
                            .font(.system(size: 14, weight: .medium))
                            .padding(10)
                    } else {
                        Text("turns \(person.calculateTurnsAge())")
                            .font(.system(size: 14, weight: .medium))
                            .padding(10)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                if isBirthdayToday {
                    Text("🎉")
                        .font(.system(size: 40))
                        .padding(10)
                } else {
                    Text(person.calculateLeftDays() ?? "0")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text(person.calculateLeftDays() == "1" ? "Day" : "Days")
                        .font(.system(size: 16, weight: .medium))
                        .padding(10)
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    ListCell(person: .dummy)
//}
