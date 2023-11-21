//
//  ITunesModel.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import Foundation

struct MovieResult: Codable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let trackName: String
    let artworkUrl100: String?
    let releaseDate: String
    let primaryGenreName: String
    let shortDescription: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackName)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.trackName == rhs.trackName
    }
}
