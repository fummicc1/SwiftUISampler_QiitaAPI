import Foundation
import SwiftUI

struct Qiita: Decodable, Hashable, Identifiable {
    let id: String
    let title: String
}

struct User: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
}
