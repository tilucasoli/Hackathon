//
//  POCsWidgets.swift
//  POCsWidgets
//
//  Created by Lucas Alves de Oliveira on 29/08/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), family: context.family)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, family: context.family)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, family: context.family)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let family: WidgetFamily
}

struct POCsWidgetsEntryView: View {
    var entry: Provider.Entry
    
    private var numberOfCells: Int {
        switch entry.family {
        case .systemSmall:
            return 2
        default:
            return 4
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(.background)
            VStack(alignment: .leading) {
                headerView
                    .padding(.init(top: 16, leading: 18, bottom: 0, trailing: 0))
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(0..<numberOfCells) { number in
                        FeatureCell(model: .init(id: number,
                                                 title: "Pix",
                                                 iconName: "Pix",
                                                 url: ""))
                        Spacer()
                    }
                }
            }
        }
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image("logo")
            Text("Sugere")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.textColor)
        }
    }
}

@main
struct POCsWidgets: Widget {
    let kind: String = "POCsWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            POCsWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Sugestões de atalhos")
        .description("Identificamos o que você mais usa e trouxemos para perto de você")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct POCsWidgets_Previews: PreviewProvider {
    static var previews: some View {
        POCsWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), family: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        POCsWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), family: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
