import Foundation

struct Country: Codable, Identifiable {
    var id: Int
    var name: String
    var capital: String
    var area: Double
    var population: Int
    var gdp: Double
    var currency: String
}
