import Foundation

struct InsurewalletEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var date: Date = Date()
    var provider: String = ""
    var policyNumber: String = ""
    var note: String = ""
}
