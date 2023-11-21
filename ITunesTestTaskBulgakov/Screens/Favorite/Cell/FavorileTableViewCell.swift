//
//  FavorileTableViewCell.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
        
    // MARK: - Properties
    static let cellId = "FavoriteTableViewCell"
    var isFavorite: Bool = false
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
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupViews() {
        addSubview(coverImagiView)
        addSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(yearLabel)
        vStack.addArrangedSubview(genreLabel)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.trackName
        yearLabel.text = "Release date: \(vm.setDateFormat(date: movie.releaseDate))"
        genreLabel.text = "Genre: \(movie.primaryGenreName)"
        
        guard let url = movie.artworkUrl100 else { return }
        vm.setImage(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImagiView.image = image
            }
        }
    }
}

// MARK: - Extension
extension FavoriteTableViewCell {
    func setupConstraints() {
        
        let coverImageSideConst: CGFloat = 10
        let coverImageWidthConst: CGFloat = 90
        let vStackLeadingConst: CGFloat = 20
        let vStackTopConst: CGFloat = 20
        let vStackTrailingConst: CGFloat = -40
        
        NSLayoutConstraint.activate([
            coverImagiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImagiView.topAnchor.constraint(equalTo: topAnchor, constant: coverImageSideConst),
            coverImagiView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -coverImageSideConst),
            coverImagiView.widthAnchor.constraint(equalToConstant: coverImageWidthConst),
            
            vStack.leadingAnchor.constraint(equalTo: coverImagiView.trailingAnchor, constant: vStackLeadingConst),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: vStackTopConst),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: vStackTrailingConst)
        ])
    }
}

