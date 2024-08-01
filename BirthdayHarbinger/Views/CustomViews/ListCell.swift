import SwiftUI

struct ListCell: View {
    
    let person: Personn
    var isBirthdayToday: Bool
    var turnsAgeText: String
    var leftDaysText: String
    var leftDays: String?
    var language: Language
    
    init(person: Personn, language: Language) {
        self.person = person
        self.language = language
        self.isBirthdayToday = person.calculateLeftDays() == "0"
        self.turnsAgeText = language == .turkish ? "\(person.calculateTurnsAge()) olmaya" : "turns \(person.calculateTurnsAge())"
        self.leftDays = person.calculateLeftDays()
        self.leftDaysText = self.leftDays == "1" ? "Day".localized(language) : "Days".localized(language)
    }
    
    var body: some View {
        HStack {
            if let imageData = person.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(.circle)
                    .frame(width: 60, height: 60)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.secondary)
                    .clipShape(.circle)
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(person.name)
                        .font(.system(size: 14, weight: .bold))
                    
                    if person.isPinned {
                        Image(systemName: "pin.fill")
                            .resizable()
                            .frame(width: 8, height: 11)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text(person.birthday.formatted(using: language))
                        .font(.system(size: 12, weight: .medium))
                    
                    if isBirthdayToday {
                        Text("birthdayMessage".localized(language))
                            .font(.system(size: 12, weight: .medium))
                            .padding(10)
                    } else {
                        Text(turnsAgeText)
                            .font(.system(size: 12, weight: .medium))
                            .padding(10)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                if isBirthdayToday {
                    Text("🎉")
                        .font(.system(size: 30))
                        .padding(10)
                } else {
                    Text(leftDays ?? "0")
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(leftDaysText)
                        .font(.system(size: 14, weight: .medium))
                        .padding(10)
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    ListCell(person: .dummy, language: .english)
//        .modelContainer(Personn.preview)
//}
