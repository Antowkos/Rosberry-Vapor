import Vapor
import HTTP

final class AppController: ResourceRepresentable {
    typealias Model = App
    
    func index(req: Request) throws -> ResponseRepresentable {
        return try App.all().makeJSON()
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let app = try App(request: request)
        try app.save()
        return app
    }
    
    func show(request: Request, app: App) throws -> ResponseRepresentable {
        return app
    }
    
    func update(request: Request, app: App) throws -> ResponseRepresentable {
        try app.update(for: request)
        try app.save()
        return app
    }
    
    func replace(request: Request, app: App) throws -> ResponseRepresentable {
        let new = try App(request: request)
        app.name = new.name
        app.icon = new.icon
        app.rank = new.rank
        app.score = new.score
        try app.save()
        return app
    }
    
    func makeResource() -> Resource<Model> {
        return Resource(index: index,
                store: create,
                show: show,
                update: update,
                replace: replace)
    }
}

extension AppController: EmptyInitializable { }
