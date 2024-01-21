import SwiftUI

enum Tab2: String, CaseIterable {
    case ficheiros = "Ficheiros"


    var systemImage: String {
        switch self {
        case .ficheiros:
            return "folder.fill"
        }
    }
}
//isto tem haver com a pasta ficheiros
