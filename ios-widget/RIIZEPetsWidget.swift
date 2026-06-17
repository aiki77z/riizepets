import SwiftUI
import WidgetKit
import AppIntents

// Add this file to the widget extension target.

struct RIIZEPetsWidgetEntry: TimelineEntry {
    let date: Date
    let state: RIIZEPetMemoState
}

struct RIIZEPetsWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> RIIZEPetsWidgetEntry {
        RIIZEPetsWidgetEntry(date: Date(), state: .fallback)
    }

    func getSnapshot(in context: Context, completion: @escaping (RIIZEPetsWidgetEntry) -> Void) {
        completion(RIIZEPetsWidgetEntry(date: Date(), state: RIIZEPetSharedStore.shared.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RIIZEPetsWidgetEntry>) -> Void) {
        let state = RIIZEPetSharedStore.shared.load()
        let now = Date()
        let entries = (0..<4).map { index in
            RIIZEPetsWidgetEntry(date: now.addingTimeInterval(Double(index) * 20), state: state)
        }
        completion(Timeline(entries: entries, policy: .after(now.addingTimeInterval(80))))
    }
}

struct RIIZEPetsWidgetView: View {
    let entry: RIIZEPetsWidgetEntry

    private var memos: [String] {
        let all = entry.state.memosByPet[entry.state.selectedPetId] ?? RIIZEPetMemoState.fallback.memosByPet["rizuko"]!
        let start = min(max(entry.state.activeMemoPage, 0) * 4, max(all.count - 1, 0))
        return Array(all.dropFirst(start).prefix(4))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 1.0, green: 0.98, blue: 0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.8), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    DeskStatus(enabled: entry.state.deskEnabled)
                }

                if entry.state.deskEnabled {
                    ForEach(Array(memos.enumerated()), id: \.offset) { item in
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("\(entry.state.activeMemoPage * 4 + item.offset + 1).")
                                .foregroundStyle(Color(red: 0.68, green: 0.48, blue: 0.42))
                            Text(item.element)
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)
                                .fontWeight(.semibold)
                        }
                        .font(.system(size: 22, weight: .medium))
                        Divider().overlay(Color(red: 0.75, green: 0.66, blue: 0.56).opacity(0.3))
                    }
                    Spacer(minLength: 54)
                } else {
                    Text("Desk memo is paused")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            VStack(spacing: 4) {
                Image("\(entry.state.selectedPetId)_\(assetActionName(entry.state.selectedAction))")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 128)
                Text(entry.state.selectedAction.chip)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white.opacity(0.8), in: Capsule())
            }
            .padding(.trailing, 26)
            .padding(.bottom, 58)

            HStack(spacing: 14) {
                Button(intent: SwitchPetIntent(direction: -1)) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)

                Text(entry.state.selectedPetName)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)

                Spacer()

                Button(intent: PreviousMemoPageIntent()) {
                    Image(systemName: "arrow.up")
                }
                .buttonStyle(.plain)

                Button(intent: NextMemoPageIntent()) {
                    Image(systemName: "arrow.down")
                }
                .buttonStyle(.plain)

                Button(intent: SwitchPetIntent(direction: 1)) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(.white.opacity(0.58), in: Capsule())
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .containerBackground(.clear, for: .widget)
    }

    private func assetActionName(_ action: RIIZEAction) -> String {
        switch action {
        case .runningRight: return "running_right_2"
        case .runningLeft: return "running_left_2"
        case .waving: return "waving_1"
        case .jumping: return "jumping_2"
        case .failed: return "failed_2"
        case .waiting: return "waiting_1"
        case .running: return "running_2"
        case .review: return "review_1"
        case .idle: return "idle_0"
        }
    }
}

struct DeskStatus: View {
    let enabled: Bool

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(enabled ? Color(red: 0.5, green: 0.64, blue: 0.44) : .gray)
                .frame(width: 9, height: 9)
            Text(enabled ? "Desk ON" : "Desk OFF")
                .font(.caption.bold())
                .foregroundStyle(enabled ? Color(red: 0.45, green: 0.56, blue: 0.36) : .secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(.white.opacity(0.58), in: Capsule())
    }
}

struct RIIZEPetsWidget: Widget {
    let kind: String = "RIIZEPetsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RIIZEPetsWidgetProvider()) { entry in
            RIIZEPetsWidgetView(entry: entry)
        }
        .configurationDisplayName("RIIZE Pets Memo")
        .description("A memo card with one active RIIZE pet.")
        .supportedFamilies([.systemMedium])
    }
}
