import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageData: nil, name: "Alice", daysLeft: 5, isBirthday: false, age: 0)
    }
    
    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = createEntry(for: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    @MainActor func createEntry(for date: Date = Date()) -> SimpleEntry {
        if let nextBirthday = getNextUpcomingBirthday() {
            let daysLeft = Int(nextBirthday.calculateLeftDays() ?? "0") ?? 0
            let isBirthday = daysLeft == 0
            let age = nextBirthday.calculateTurnsAge()
            let imageData = nextBirthday.imageData
            print("Next birthday: \(nextBirthday.name), Days left: \(daysLeft), Is Birthday: \(isBirthday), Age: \(age)")
            return SimpleEntry(date: date, imageData: imageData, name: nextBirthday.name, daysLeft: daysLeft, isBirthday: isBirthday, age: age)
        } else {
            return SimpleEntry(date: date, imageData: nil, name: "Unknown", daysLeft: 0, isBirthday: false, age: 0)
        }
    }
    
    @MainActor func getNextUpcomingBirthday() -> Personn? {
        do {
            let container = try ModelContainer(for: Personn.self)
            let fetchDescriptor = FetchDescriptor<Personn>()
            let people = try container.mainContext.fetch(fetchDescriptor)
            
            let today = Calendar.current.startOfDay(for: Date())
            if let todayBirthday = people.first(where: { Calendar.current.isDate($0.birthday, inSameDayAs: today) }) {
                return todayBirthday
            }
            
            return people.sorted {
                let daysLeft0 = Int($0.calculateLeftDays() ?? "0") ?? 0
                let daysLeft1 = Int($1.calculateLeftDays() ?? "0") ?? 0
                return daysLeft0 < daysLeft1
            }.first
        } catch {
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageData: Data?
    let name: String
    let daysLeft: Int
    let isBirthday: Bool
    let age: Int
}

struct BirthdayWidgetEntryView: View {
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    var entry: Provider.Entry
    
    var body: some View {
        if entry.name == "Unknown" {
            ContentUnavailableView("There is nobody".localized(language), systemImage: "person.slash.fill", description: Text("Add someone to see".localized(language)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(spacing: 10) {
                if entry.isBirthday {
                    ZStack {
                        Image("bd")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 120)
                        
                        VStack {
                            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .clipShape(.circle)
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 10)
                                    .padding(.bottom, 3)
                            } else {
                                Text("HPD".localized(language))
                                    .font(.system(size: 13, weight: .regular))
                                    .padding(.top, 10)
                                    .padding(.bottom, 8)
                            }
                            
                            Text(entry.name)
                                .font(.headline)
                                .foregroundColor(.black)
                                .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
                                .padding(.bottom, 2)
                            
                            Text("\(entry.age) " + (entry.age == 1 ? "year".localized(language) : "years".localized(language)) + " " + "old".localized(language))
                                .font(.footnote)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                    }
                } else {
                    ZStack {
                        Image("cake3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 120)
                        
                        VStack {
                            Text(entry.name)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
                            
                            Text("\(entry.daysLeft) " + (entry.daysLeft == 1 ? "day".localized(language) : "days".localized(language)) + " " + "later".localized(language))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .cornerRadius(10)
        }
    }
}

struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
                .environment(\.locale, LocaleManager.shared.language.locale)
                .containerBackground(.white, for: .widget)
                .modelContainer(for: Personn.self)
        }
        .configurationDisplayName("Birthday Widget")
        .description("Shows the name and days left for the next upcoming birthday or celebrates the birthday person.")
    }
}

#Preview(as: .systemSmall) {
    BirthdayWidget()
} timeline: {
    SimpleEntry(date: .now, imageData: nil, name: "Alice", daysLeft: 5, isBirthday: false, age: 10)
    SimpleEntry(date: .now, imageData: nil, name: "Charlie", daysLeft: 0, isBirthday: true, age: 25)
    SimpleEntry(date: .now, imageData: nil, name: "Unknown", daysLeft: 0, isBirthday: false, age: 0)
}
