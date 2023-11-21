//
//  SignInViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

enum SignInErrorMessage: String {
    case userNotFound = "User not found"
    case wrongPassword = "Wrong password"
}

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    private let vm = MainViewModel()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("You don`t have account? Sign Up", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        setupViews()
        setupDelegates()
        setupConstraints()
    }
    
    // MARK: - Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(vStack)
        vStack.addArrangedSubview(loginLabel)
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(signInButton)
        vStack.addArrangedSubview(signUpButton)
    }
    
    @objc private func signUpButtonAction() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupButtonActions() {
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    @objc private func signInButtonAction() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if let user = vm.findUserInDataBase(email: email) {
            handleSuccessfulLogin(user: user, password: password)
        } else {
            handleUserNotFound()
        }
    }
    
    private func handleSuccessfulLogin(user: User, password: String) {
        if user.password == password {
            UserDefaultsManager.shared.setActiveUser(email: user.email)
            let tabBarController = TabBarController()
            navigationController?.setViewControllers([tabBarController], animated: true)
        } else {
            handleWrongPassword()
        }
    }
    
    private func handleUserNotFound() {
        loginLabel.text = SignInErrorMessage.userNotFound.rawValue
        loginLabel.textColor = UIColor.systemRed
    }
    
    private func handleWrongPassword() {
        loginLabel.text = SignInErrorMessage.wrongPassword.rawValue
        loginLabel.textColor = UIColor.systemRed
    }
}

// MARK: - Extensions
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignInViewController {
    func setupConstraints() {
        
        let topConst: CGFloat = 200
        let sideConst: CGFloat = 20
        let heightConst: CGFloat = 300
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            vStack.heightAnchor.constraint(equalToConstant: heightConst)
        ])
    }
}
