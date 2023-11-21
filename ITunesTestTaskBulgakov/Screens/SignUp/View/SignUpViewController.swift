//
//  SignUpViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

enum SignUpErrorMessage: String {
    case invalidInput = "Enter valid email and password"
    case emptyFields = "Enter email and password"
}

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
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
        textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
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
        setupViews()
        setupDelegates()
        setupConstraints()
        setupButtonActions()
    }
    
    // MARK: - Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(vStack)
        vStack.addArrangedSubview(registrationLabel)
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(signUpButton)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupButtonActions() {
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        
    }
    
    @objc private func signUpButtonAction() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showError(message: SignUpErrorMessage.invalidInput.rawValue)
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            showError(message: SignUpErrorMessage.emptyFields.rawValue)
            return
        }
        
        UserDefaultsManager.shared.saveUser(email: email, password: password)
        UserDefaultsManager.shared.setActiveUser(email: email)
        handleRegistrationCompletion()
    }
    
    private func handleRegistrationCompletion() {
        registrationLabel.text = "Registration completed"
        registrationLabel.textColor = UIColor.systemGreen
        print("Registration completed")
    }
    
    private func showError(message: String) {
        registrationLabel.text = message
        registrationLabel.textColor = UIColor.systemRed
        print(message)
    }
}

// MARK: - Extensions
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController {
    func setupConstraints() {
        
        let topConst: CGFloat = 200
        let sideConst: CGFloat = 20
        let heightConst: CGFloat = 238
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideConst),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideConst),
            vStack.heightAnchor.constraint(equalToConstant: heightConst)
        ])
    }
}


