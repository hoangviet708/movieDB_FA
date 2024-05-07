//
//  DatabaseManager.swift
//  SmartMovie
//
//  Created by Hoang Viet on 08/04/2023.
//

import Foundation
import RealmSwift

class FavoriteMovieObject: Object {
    @Persisted var id: Int
    @Persisted var title: String?

    override static func primaryKey() -> String? {
           return "id"
    }

    convenience init(id: Int, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}

class DatabaseManager {

    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            return nil
        }
    }

    static let shared = DatabaseManager()

    func getDatabaseURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }

    func saveMovieData(data: FavoriteMovieObject) {
        guard let realm = realm else { return }

        if isMovieExist(id: data.id) {
            return
        }

        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving movie data: \(error.localizedDescription)")
        }
    }

    func getMovieDataById(movieId: Int) -> FavoriteMovieObject? {
        guard let realm = realm else { return nil }

        return realm.object(ofType: FavoriteMovieObject.self, forPrimaryKey: movieId)
    }

    func deleteMovieById(movieId: Int) {
        guard let realm = realm else { return }
        guard let movieToDelete = realm.object(ofType: FavoriteMovieObject.self, forPrimaryKey: movieId) else { return }

        do {
            try realm.write {
                realm.delete(movieToDelete)
            }
        } catch {
            print("Error deleting movie data: \(error.localizedDescription)")
        }
    }

    func isMovieExist(id: Int) -> Bool {
        guard let realm = realm else { return false }

        return realm.object(ofType: FavoriteMovieObject.self, forPrimaryKey: id) != nil
    }

    func getAllMovieData() -> [FavoriteMovieObject] {
        guard let realm = realm else { return [] }

        return Array(realm.objects(FavoriteMovieObject.self))
    }

    func saveAllMovieData(data: [FavoriteMovieObject]) {
        guard let realm = realm else { return }

        do {
            try realm.write {
                for item in data {
                    realm.add(item)
                }
            }
        } catch {
            print("Error saving all movie data: \(error.localizedDescription)")
        }
    }
}
