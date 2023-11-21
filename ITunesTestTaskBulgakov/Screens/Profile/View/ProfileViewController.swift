//
//  ProfileViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var activeUser: User?
    private let vm = MainViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.text = "User information"
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        getProfileInformation()
        vm.logoutAction = { [weak self] in
            self?.handleLogoutAction()
        }
        setupButtonActions()
    }
    
    // MARK: - Methods
    private func setupViews() {
        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(loginLabel)
        vStack.addArrangedSubview(passwordLabel)
        view.addSubview(logoutButton)
    }
    
    private func setupButtonActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func getProfileInformation() {
        vm.fetchProfileInformation { [weak self] user in
            self?.activeUser = user
            self?.loginLabel.text = "Usernname: \(user?.email ?? "User not found")"
            self?.passwordLabel.text = "Password: \(user?.password ?? "Password not found")"
        }
    }
    
    @objc private func logoutButtonTapped() {
        vm.logout()
    }
    
    private func handleLogoutAction() {
        let signInVC = SignInViewController()
        let navController = UINavigationController(rootViewController: signInVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate {
            windowDelegate.window?.rootViewController = navController
            windowDelegate.window?.makeKeyAndVisible()
        }
    }
}

// MARK: - Extensions
extension ProfileViewController {
    func setupConstraints() {
        
        let sideConst: CGFloat = 20
        let logoutButtonHeightConst: CGFloat = 48
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: sideConst),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            logoutButton.heightAnchor.constraint(equalToConstant: logoutButtonHeightConst)
        ])
    }
}
