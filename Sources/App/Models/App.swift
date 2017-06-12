import Vapor
import FluentProvider

final class App: Model {
    let storage = Storage()
    
    var name: String
    var icon: String
    var rank: Int
    var score: Int
    func usage() throws -> Usage? {
        return try children().first()
    }
    
    /// Creates a new Post
    init(name: String, icon: String, rank: Int, score: Int) {
        self.name = name
        self.icon = icon
        self.rank = rank
        self.score = score
    }
    
    convenience init(request: Request) throws {
        guard let json = request.json else { throw Abort.badRequest }
        try self.init(json: json)
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        name = try row.get("name")
        icon = try row.get("icon")
        rank = try row.get("rank")
        score = try row.get("score")
    }
        
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("icon", icon)
        try row.set("name", name)
        try row.set("rank", rank)
        try row.set("score", score)
        return row
    }
}

extension App: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.string("icon")
            builder.string("rank")
            builder.string("score")
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension App: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get("name"),
                      icon: json.get("icon"),
                      rank: json.get("rank"),
                      score: json.get("score"))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("icon", icon)
        try json.set("rank", rank)
        try json.set("score", score)
        return json
    }
}

extension App: ResponseRepresentable { }

extension App: Updateable {
    static var updateableKeys: [UpdateableKey<App>] {
        return [
            UpdateableKey("name", String.self) { app, name in
                app.name = name
            }
        ]
    }
}
