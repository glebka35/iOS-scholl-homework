//
//  MainViewController.swift
//  Registration
//
//  Created by Gleb Uvarkin on 10.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

//MARK: - Constants

struct MainViewConstants {
    enum ElementsNames: String {
        case login = "Login"
        case password = "Password"
        case signOut = "SignOut"
    }
}

class MainViewController: UIViewController {
    
//    MARK: - Model variables
    
    var login: String?
    var password: String?
    
//    MARK: - UI elements
    
    private let loginLabel = UILabel()
    private let passwordLabel = UILabel()
    private let signOutButton = UIButton()

//    MARK: Initialisation
    
    init(login: String?, password: String?) {
        super.init(nibName: nil, bundle: nil)
        self.login = login
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureLoginLabel()
        configurePasswordLabel()
        configureSignOutButton()
        
        embedInStack()
    }
    
//    MARK: - UI configuration
    
    private func configureLoginLabel() {
        if let login = login {
            loginLabel.text = MainViewConstants.ElementsNames.login.rawValue + ": " + login
            
        }
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePasswordLabel() {
        if let password = password {
            passwordLabel.text = MainViewConstants.ElementsNames.password.rawValue + ": " + password
            
        }
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSignOutButton() {
        signOutButton.setTitle(MainViewConstants.ElementsNames.signOut.rawValue, for: .normal)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.backgroundColor = UIColor(named: "AttentionColor")
        signOutButton.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        signOutButton.layer.cornerRadius = 5
    }
    
    private func embedInStack() {
        let stack = UIStackView(arrangedSubviews: [loginLabel, passwordLabel, signOutButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            stack.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
//    MARK: - Tap handling
    
    @objc private func signOutButtonPressed() {
           Defaults.clearUserData()
           navigationController?.popViewController(animated: false)
       }
       
}
