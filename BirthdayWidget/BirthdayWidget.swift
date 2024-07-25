import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), name: "Alice", daysLeft: 5)
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry: SimpleEntry
        if let nextBirthday = getNextUpcomingBirthday() {
            entry = SimpleEntry(date: Date(), name: nextBirthday.name, daysLeft: Int(nextBirthday.calculateLeftDays() ?? "0") ?? 0)
        } else {
            entry = SimpleEntry(date: Date(), name: "Unknown", daysLeft: 0)
        }
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry: SimpleEntry
            if let nextBirthday = getNextUpcomingBirthday() {
                entry = SimpleEntry(date: entryDate, name: nextBirthday.name, daysLeft: Int(nextBirthday.calculateLeftDays() ?? "0") ?? 0)
            } else {
                entry = SimpleEntry(date: entryDate, name: "Unknown", daysLeft: 0)
            }
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

@MainActor func getNextUpcomingBirthday() -> Personn? {
    do {
        let container = try ModelContainer(for: Personn.self)
        let fetchDescriptor = FetchDescriptor<Personn>()
        let people = try container.mainContext.fetch(fetchDescriptor)
        
        return people.sorted { ($0.calculateLeftDays() ?? "0") < ($1.calculateLeftDays() ?? "0") }.first
    } catch {
        print("Error fetching data: \(error)")
        return nil
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let daysLeft: Int
}

struct BirthdayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Next Birthday:")
            Text(entry.name)
                .font(.headline)
            Text("Days Left: \(entry.daysLeft)")
                .font(.subheadline)
        }
        .padding()
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
        .description("Shows the name and days left for the next upcoming birthday.")
    }
}

#Preview(as: .systemSmall) {
    BirthdayWidget()
} timeline: {
    SimpleEntry(date: .now, name: "Alice", daysLeft: 5)
    SimpleEntry(date: .now, name: "Bob", daysLeft: 10)
}
