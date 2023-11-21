//
//  FavoriteViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private let table: UITableView = {
        let table = UITableView()
        table.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.cellId)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstraints()
        UserDefaultsManager.shared.addObserver { [weak self] in
            self?.table.reloadData()
        }
    }
    
    // MARK: - Methods
    private func setupViews() {
        title = "Favorite"
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(table)
    }
    
    private func setupDelegates() {
        table.delegate = self
        table.dataSource = self
    }
}

// MARK: - Extensions
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultsManager.shared.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        let movie = UserDefaultsManager.shared.favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedMovie = UserDefaultsManager.shared.favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Movie removed from favorites: \(removedMovie.trackName)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 150
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = UserDefaultsManager.shared.favoriteMovies[indexPath.row]
        let detailVC = FavoriteDetailViewController(movie: selectedMovie)
        self.navigationController?.pushViewController(detailVC, animated:true)
    }
}

extension FavoriteViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
