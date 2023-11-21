//
//  MainViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

enum Names: String {
    case title = "Movies"
    case search = "Search"
}

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var timer: Timer?
    private let searchConntroller = UISearchController(searchResultsController: nil)
    private let vm = MainViewModel()

    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellId)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstraints()
        setupSearchController()
        vm.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        vm.fetchMovies()
    }
    
    // MARK: - Methods
    private func setupViews() {
        title = Names.title.rawValue
        navigationItem.searchController = searchConntroller
        view.backgroundColor = .systemBackground
        view.addSubview(table)
    }
    
    private func setupDelegates() {
        table.delegate = self
        table.dataSource = self
        searchConntroller.searchBar.delegate = self
    }
    
    private func setupSearchController() {
        searchConntroller.searchBar.placeholder = Names.title.rawValue
        searchConntroller.obscuresBackgroundDuringPresentation = false
    }
}

// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell() }
        let movie = vm.movies[indexPath.row]
        cell.updateUICell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 150
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = vm.movies[indexPath.row]
        let detailVC = MainDetailViewController(movie: selectedMovie)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.vm.fetchMovies(movieName: searchText)
        }
    }
}

extension MainViewController {
    func setupConstraints() {
        
        let sideConst: CGFloat = 20
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
