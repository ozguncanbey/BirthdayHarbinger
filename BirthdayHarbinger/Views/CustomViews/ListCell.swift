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
            ZStack {
                Circle()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: 50, height: 50)
                
//                if let imageData = person.image, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .clipShape(Circle())
//                } else {
//                    Image(systemName: "person.circle")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.gray)
//                        .clipShape(Circle())
//                }
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.leading)
                
                HStack {
                    Text(person.birthday, format: Date.FormatStyle().day().month().year())
                        .font(.system(size: 12, weight: .medium))
                        .padding(.leading)
                    
                    if isBirthdayToday {
                        Text("birthdayMessage")
                            .font(.system(size: 12, weight: .medium))
                            .padding(10)
                    } else {
                        if Locale.current.isTurkish {
                            Text("\(person.calculateTurnsAge()) olacak")
                                .font(.system(size: 12, weight: .medium))
                                .padding(10)
                        } else {
                            Text("turns \(person.calculateTurnsAge())")
                                .font(.system(size: 12, weight: .medium))
                                .padding(10)
                        }
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
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(person.calculateLeftDays() == "1" ? "Day" : "Days")
                        .font(.system(size: 14, weight: .medium))
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
