import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), name: "Alice", daysLeft: 5, isBirthday: false, age: 0)
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
            return SimpleEntry(date: date, name: nextBirthday.name, daysLeft: daysLeft, isBirthday: isBirthday, age: age)
        } else {
            return SimpleEntry(date: date, name: "Unknown", daysLeft: 0, isBirthday: false, age: 0)
        }
    }
    
    @MainActor func getNextUpcomingBirthday() -> Personn? {
        do {
            let container = try ModelContainer(for: Personn.self)
            let fetchDescriptor = FetchDescriptor<Personn>()
            let people = try container.mainContext.fetch(fetchDescriptor)
            
            // Find the person with the birthday today or the next upcoming birthday
            let today = Calendar.current.startOfDay(for: Date())
            if let todayBirthday = people.first(where: { Calendar.current.isDate($0.birthday, inSameDayAs: today) }) {
                return todayBirthday
            }
            
            return people.sorted { ($0.calculateLeftDays() ?? "0") < ($1.calculateLeftDays() ?? "0") }.first
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let daysLeft: Int
    let isBirthday: Bool
    let age: Int
}

struct BirthdayWidgetEntryView: View {
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 10) {
            if entry.isBirthday {
                Text("🎉")
                    .font(.largeTitle)
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(entry.age) " + (entry.age == 1 ? "year".localized(language) : "years".localized(language)) + " " + "old".localized(language))
                    .font(.subheadline)
                    .foregroundColor(.primary)
            } else {
                Image("cake2")
                    
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(entry.daysLeft) " + (entry.daysLeft == 1 ? "day".localized(language) : "days".localized(language)) + " " + "later".localized(language))
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .cornerRadius(10)
    }
}

struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Personn.self)
        }
        .configurationDisplayName("Birthday Widget")
        .description("Shows the name and days left for the next upcoming birthday or celebrates the birthday person.")
    }
}

#Preview(as: .systemSmall) {
    BirthdayWidget()
} timeline: {
    SimpleEntry(date: .now, name: "Alice", daysLeft: 5, isBirthday: false, age: 0)
    SimpleEntry(date: .now, name: "Bob", daysLeft: 10, isBirthday: false, age: 0)
    SimpleEntry(date: .now, name: "Charlie", daysLeft: 0, isBirthday: true, age: 25)
}
