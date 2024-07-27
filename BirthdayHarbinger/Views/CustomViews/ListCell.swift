import SwiftUI

struct ListCell: View {
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    let person: Personn
    var isBirthdayToday: Bool
    
    init(person: Personn) {
        self.person = person
        self.isBirthdayToday = person.calculateLeftDays() == "0"
    }
    
    var body: some View {
        HStack {
            if let imageData = person.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(.circle)
                    .frame(width: 60, height: 60, alignment: .center)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.secondary)
                    .clipShape(.circle)
                    .frame(width: 60, height: 60, alignment: .center)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(person.name)
                        .font(.system(size: 14, weight: .bold))
                    
                    if person.isPinned {
                        Image(systemName: "pin.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
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
                        if Locale.current.isTurkish {
                            Text("\(person.calculateTurnsAge()) olmaya")
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
                        .font(.system(size: 30))
                        .padding(10)
                } else {
                    Text(person.calculateLeftDays() ?? "0")
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(person.calculateLeftDays() == "1" ? "Day".localized(language) : "Days".localized(language))
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
//        .modelContainer(Personn.preview)
//}
