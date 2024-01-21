import SwiftUI

enum Tab: String, CaseIterable {
    case questoes = "Questões"


    var systemImage: String {
        switch self {
        case .questoes:
            return "bubble.left.and.bubble.right"
        }
    }
}
//isto tem haver com a pasta geralquestao
