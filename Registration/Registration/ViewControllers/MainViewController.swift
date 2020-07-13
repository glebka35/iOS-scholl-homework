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
        case name = "First Name"
        case surName = "Second Name"
        case login = "Login"
        case password = "Password"
        case signOut = "SignOut"
    }
}

class MainViewController: UIViewController {
    
//    MARK: - Model variables
    
    var name: String?
    var surName: String?
    var login: String?
    var password: String?
    
    var coreDataManager = CoreDataManager.shared
    
//    MARK: - UI elements
    
    private var showCarsButton = UIButton()
    private var addCarButton = UIButton()
    private let nameLabel = UILabel()
    private let surNameLabel = UILabel()
    private let loginLabel = UILabel()
    private let passwordLabel = UILabel()
    private let signOutButton = UIButton()

    
//    MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupFromCoreData()
        
        configureShowCarsButton()
        configureAddCarButton()
        embedButtonsInStack()
        
        configureNameLabel()
        configureSurNameLabel()
        configureLoginLabel()
        configurePasswordLabel()
        configureSignOutButton()
        
        embedInStack()
    }
    
//    MARK: - UI configuration
    
    private func setupFromCoreData() {
        let user = coreDataManager.fetchUserInfo()
        name = user?.name
        surName = user?.surName
        login = user?.login
        password = user?.password
    }
    
    private func configureShowCarsButton() {
        showCarsButton.translatesAutoresizingMaskIntoConstraints = false
        
        showCarsButton.setTitle("Show cars", for: .normal)
        showCarsButton.setTitleColor(.black, for: .normal)
        showCarsButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        showCarsButton.layer.borderWidth = 2
        showCarsButton.layer.cornerRadius = 5
        
        showCarsButton.addTarget(self, action: #selector(showCarsButtonPressed), for: .touchUpInside)
    }
    
    private func configureAddCarButton() {
        addCarButton.translatesAutoresizingMaskIntoConstraints = false
        
        addCarButton.setTitle("+", for: .normal)
        addCarButton.setTitleColor(.black, for: .normal)
        addCarButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        addCarButton.layer.borderWidth = 2
        addCarButton.layer.cornerRadius = 5
        addCarButton.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .medium)
        
        addCarButton.addTarget(self, action: #selector(addCarButtonPressed), for: .touchUpInside)
    }
    
    private func embedButtonsInStack() {
        let stack = UIStackView(arrangedSubviews: [showCarsButton, addCarButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 30
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    private func configureNameLabel() {
        if let name = name {
            nameLabel.text = MainViewConstants.ElementsNames.name.rawValue + ": " + name
        }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSurNameLabel() {
        if let surName = surName {
            surNameLabel.text = MainViewConstants.ElementsNames.surName.rawValue + ": " + surName
        }
        
        surNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        let stack = UIStackView(arrangedSubviews: [nameLabel, surNameLabel, loginLabel, passwordLabel, signOutButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stack.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
//    MARK: - Tap handling
    
    @objc private func signOutButtonPressed() {
        coreDataManager.deleteUserInfo()
        coreDataManager.deleteCarsInfo()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addCarButtonPressed() {
        let alert = UIAlertController(title: "New car", message: "Add a new car", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            let coreDataManager = CoreDataManager.shared
            coreDataManager.addCarRecordIntoCoreData(car: CarInfo(name: nameToSave))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func showCarsButtonPressed() {
        let nextVC = TableViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
