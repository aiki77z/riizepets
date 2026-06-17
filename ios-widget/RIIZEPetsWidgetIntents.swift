import AppIntents
import WidgetKit

// Add this file to the widget extension target.

struct NextMemoPageIntent: AppIntent {
    static var title: LocalizedStringResource = "Next Memo Page"

    func perform() async throws -> some IntentResult {
        var state = RIIZEPetSharedStore.shared.load()
        let memos = state.memosByPet[state.selectedPetId] ?? []
        let maxPage = max(0, Int(ceil(Double(memos.count) / 4.0)) - 1)
        state.activeMemoPage = min(maxPage, state.activeMemoPage + 1)
        RIIZEPetSharedStore.shared.save(state)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct PreviousMemoPageIntent: AppIntent {
    static var title: LocalizedStringResource = "Previous Memo Page"

    func perform() async throws -> some IntentResult {
        var state = RIIZEPetSharedStore.shared.load()
        state.activeMemoPage = max(0, state.activeMemoPage - 1)
        RIIZEPetSharedStore.shared.save(state)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct SwitchPetIntent: AppIntent {
    static var title: LocalizedStringResource = "Switch Pet"

    @Parameter(title: "Direction")
    var direction: Int

    init() {
        direction = 1
    }

    init(direction: Int) {
        self.direction = direction
    }

    func perform() async throws -> some IntentResult {
        var state = RIIZEPetSharedStore.shared.load()
        let petIds = ["doolbyeong", "meongryongie", "rizuko", "songyongdoli", "tonangdeok", "urakbam"]
        guard let index = petIds.firstIndex(of: state.selectedPetId) else { return .result() }
        let nextIndex = (index + direction + petIds.count) % petIds.count
        state.selectedPetId = petIds[nextIndex]
        state.selectedPetName = state.namesByPet[state.selectedPetId] ?? displayName(for: state.selectedPetId)
        state.activeMemoPage = 0
        RIIZEPetSharedStore.shared.save(state)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }

    private func displayName(for petId: String) -> String {
        switch petId {
        case "doolbyeong": return "Doolbyeong"
        case "meongryongie": return "Meongryongie"
        case "rizuko": return "Rizuko"
        case "songyongdoli": return "Songyongdoli"
        case "tonangdeok": return "Tonangdeok"
        case "urakbam": return "Urakbam"
        default: return "RIIZE Pet"
        }
    }
}
