//
//  UserDefaultsManager.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

enum Key: String {
    case user
    case activeUser
    case favoriteMovies
}

final class UserDefaultsManager {
    
    // MARK: - Properties
    static let shared = UserDefaultsManager()
    private var observers: [() -> Void] = []
    
    let userKey = Key.user.rawValue
    let activeUserKey = Key.activeUser.rawValue
    let favoriteMoviesKey = Key.favoriteMovies.rawValue
    
    let defaults = UserDefaults.standard
    
    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        } set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    var favoriteMovies: [Movie] {
        get {
            if let data = defaults.value(forKey: favoriteMoviesKey) as? Data {
                return try! PropertyListDecoder().decode([Movie].self, from: data)
            } else {
                return [Movie]()
            }
        } set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: favoriteMoviesKey)
            }
        }
    }
    
    // MARK: - User Methods
    func saveUser(email: String, password: String) {
        let user = User(email: email, password: password)
        users.insert(user, at: 0)
        print("User saved: \(user.email)")
    }
    
    func setActiveUser(email: String) {
        if let user = users.first(where: { $0.email == email }) {
            let userData = try? PropertyListEncoder().encode(user)
            defaults.set(userData, forKey: activeUserKey)
            print("Active user set: \(user.email)")
        }
    }
    
    func clearActiveUser() {
        defaults.removeObject(forKey: activeUserKey)
        print("Active user cleared")
    }
    
    // MARK: - FavoriteController Methods
    func addFavoriteMovie(_ movie: Movie) {
        var favoriteMovies = favoriteMovies
        favoriteMovies.append(movie)
        favoriteMovies = Array(Set(favoriteMovies))
        self.favoriteMovies = favoriteMovies
        print("Movie added to favorites: \(movie.trackName)")
        notifyObservers()
    }
    
    func addObserver(_ observer: @escaping () -> Void) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer()
        }
    }
}
