import Foundation

// Add this file to both the app target and the widget extension target.
let RIIZE_APP_GROUP = "group.com.riize.pets"

enum RIIZEAction: String, Codable, CaseIterable {
    case idle
    case runningRight
    case runningLeft
    case waving
    case jumping
    case failed
    case waiting
    case running
    case review

    var chip: String {
        switch self {
        case .idle: return "Idle"
        case .runningRight: return "Run ->"
        case .runningLeft: return "Run <-"
        case .waving: return "Wave"
        case .jumping: return "Jump"
        case .failed: return "Oops"
        case .waiting: return "Wait"
        case .running: return "Busy"
        case .review: return "Check"
        }
    }
}

struct RIIZEPetMemoState: Codable {
    var selectedPetId: String
    var selectedPetName: String
    var selectedAction: RIIZEAction
    var deskEnabled: Bool
    var activeMemoPage: Int
    var memosByPet: [String: [String]]
    var namesByPet: [String: String]

    static let fallback = RIIZEPetMemoState(
        selectedPetId: "rizuko",
        selectedPetName: "Rizuko",
        selectedAction: .idle,
        deskEnabled: true,
        activeMemoPage: 0,
        memosByPet: [
            "rizuko": ["剪视频", "喝水", "整理素材", "早点休息"]
        ],
        namesByPet: [:]
    )
}

final class RIIZEPetSharedStore {
    static let shared = RIIZEPetSharedStore()

    private let key = "riizePetMemoState"
    private let defaults = UserDefaults(suiteName: RIIZE_APP_GROUP)

    func load() -> RIIZEPetMemoState {
        guard let data = defaults?.data(forKey: key),
              let state = try? JSONDecoder().decode(RIIZEPetMemoState.self, from: data) else {
            return .fallback
        }
        return state
    }

    func save(_ state: RIIZEPetMemoState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults?.set(data, forKey: key)
    }
}
