//
//  MainTableViewCell.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellId = "MainTableViewCell"
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
    
    func updateUICell(movie: Movie) {
        titleLabel.text = movie.trackName
        yearLabel.text = "Release date: \(vm.setDateFormat(date: movie.releaseDate))"
        genreLabel.text = "Genre: \(movie.primaryGenreName)"
        
        guard let urlString = movie.artworkUrl100 else {
            coverImagiView.image = nil
            return
        }
        
        vm.setImage(urlString: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.coverImagiView.image = image
            }
        }
    }
}

// MARK: - Extension
extension MainTableViewCell {
    func setupConstraints() {
        
        let coverImageSidetConst: CGFloat = 10
        let coverImageWidthConst: CGFloat = 90
        let sideConst: CGFloat = 20
        
        NSLayoutConstraint.activate([
            coverImagiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImagiView.topAnchor.constraint(equalTo: topAnchor, constant: coverImageSidetConst),
            coverImagiView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -coverImageSidetConst),
            coverImagiView.widthAnchor.constraint(equalToConstant: coverImageWidthConst),
            
            vStack.leadingAnchor.constraint(equalTo: coverImagiView.trailingAnchor, constant: sideConst),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: sideConst),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideConst)
        ])
    }
}
