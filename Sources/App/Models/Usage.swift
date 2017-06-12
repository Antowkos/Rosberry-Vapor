import Vapor
import FluentProvider

import Foundation

final class Usage: Model {
    let storage = Storage()
    
    var newUsers: Int
    var sessionsPerUser: Float
    var crashFreeUsers: Float
    
    init(row: Row) throws {
        newUsers = try row.get("newUsers")
        sessionsPerUser = try row.get("sessionsPerUser")
        crashFreeUsers = try row.get("crashFreeUsers")
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("newUsers", newUsers)
        try row.set("sessionsPerUser", sessionsPerUser)
        try row.set("crashFreeUsers", crashFreeUsers)
        return row
    }
}
