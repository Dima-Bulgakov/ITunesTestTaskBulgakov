//
//  ViewModel.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class MainViewModel {
    
    // MARK: - Properties
    var movies: [Movie] = []
    var onUpdate: (() -> Void)?
    
    // ProfileViewController Property
    var logoutAction: (() -> Void)?
    
    // MARK: - UserDefaults Methods
    func findUserInDataBase(email: String) -> User? {
        let dataBase = UserDefaultsManager.shared.users
        print(dataBase)
        
        for user in dataBase {
            if user.email == email {
                return user
            }
        }
        return nil
    }
    
    // MARK: - API Methods
    func fetchMovies(movieName: String? = nil) {
        var urlString = "https://itunes.apple.com/search?entity=movie&attribute=movieTerm"
        
        if let movieName = movieName, !movieName.isEmpty {
            urlString += "&term=\(movieName)"
        }
        
        URLSession.shared.request(url: URL(string: urlString), expecting: MovieResult.self) { [weak self] (result: Result<MovieResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let movieModel):
                self.movies = movieModel.results.map {
                    Movie(trackName: $0.trackName,
                          artworkUrl100: $0.artworkUrl100,
                          releaseDate: $0.releaseDate,
                          primaryGenreName: $0.primaryGenreName,
                          shortDescription: $0.shortDescription)
                }.sorted(by: { $0.trackName < $1.trackName })
                
                self.onUpdate?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - ProfileViewController Methods
    func fetchProfileInformation(completion: @escaping (User?) -> Void) {
        if let userData = UserDefaults.standard.data(forKey: UserDefaultsManager.shared.activeUserKey),
           let user = try? PropertyListDecoder().decode(User.self, from: userData) {
            completion(user)
        } else {
            completion(nil)
        }
    }
    
    func logout() {
        UserDefaultsManager.shared.clearActiveUser()
        logoutAction?()
    }
    
    // MARK: - Date Format
    func setDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateFormatter.date(from: date) else { return "" }
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy"
        let formattedDate = formatDate.string(from: backendDate)
        return formattedDate
    }
}
