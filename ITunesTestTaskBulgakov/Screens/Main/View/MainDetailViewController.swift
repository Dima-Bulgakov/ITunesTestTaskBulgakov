//
//  MainDetailViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class MainDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var movie: Movie?
    private let vm = MainViewModel()
    
    private  let coverImagiView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let descriptionTitlleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Favorive", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .secondarySystemBackground
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateUI()
        setupFavoriteButton()
        setupShareButton()
    }
    
    // MARK: - Initializers
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupViews() {
        title = "Movie details"
        view.backgroundColor = .systemBackground
        view.addSubview(coverImagiView)
        view.addSubview(vStack)
        view.addSubview(shareButton)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(yearLabel)
        vStack.addArrangedSubview(genreLabel)
        view.addSubview(descriptionTitlleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(favoriteButton)
    }
    
    private func updateUI() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.trackName
        descriptionLabel.text = movie.shortDescription
        yearLabel.text = "Release date: \(vm.setDateFormat(date: movie.releaseDate))"
        genreLabel.text = "Genre: \(movie.primaryGenreName)"
        
        guard let url = movie.artworkUrl100 else { return }
        vm.setImage(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImagiView.image = image
            }
        }
    }
    
    private func setupFavoriteButton() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let movie = movie else { return }
        UserDefaultsManager.shared.addFavoriteMovie(movie)
    }
    
    private func setupShareButton() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc private func shareButtonTapped() {
        guard let movie = movie else {
            return
        }
        
        var items: [Any] = ["Check out this movie:"]
        
        if !movie.trackName.isEmpty {
            items.append("Title: \(movie.trackName)")
        }
        
        if let description = movie.shortDescription, !description.isEmpty {
            items.append("Description: \(description)")
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension MainDetailViewController {
    func setupConstraints() {
        
        let coverImageHeightConst: CGFloat = 160
        let coverImageWidthConst: CGFloat = 110
        let sideConst: CGFloat = 20
        let favoriteButtonHeightConst: CGFloat = 48
        let descriptionLabelTopConst: CGFloat = 10
        
        NSLayoutConstraint.activate([
            coverImagiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            coverImagiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            coverImagiView.heightAnchor.constraint(equalToConstant: coverImageHeightConst),
            coverImagiView.widthAnchor.constraint(equalToConstant: coverImageWidthConst),
            
            shareButton.leadingAnchor.constraint(equalTo: coverImagiView.trailingAnchor, constant: 20),
            shareButton.bottomAnchor.constraint(equalTo: coverImagiView.bottomAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: coverImagiView.trailingAnchor, constant: sideConst),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            
            descriptionTitlleLabel.topAnchor.constraint(equalTo: coverImagiView.bottomAnchor, constant: sideConst),
            descriptionTitlleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            descriptionTitlleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitlleLabel.bottomAnchor, constant: descriptionLabelTopConst),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            
            favoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -sideConst),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButtonHeightConst)
        ])
    }
}
