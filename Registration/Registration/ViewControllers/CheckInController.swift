//
//  ViewController.swift
//  Registration
//
//  Created by Gleb Uvarkin on 09.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

//MARK: - Constants

struct CheckInViewConstants {
    enum ElementsNames: String {
        case name = "First Name"
        case surName = "Second Name"
        case login = "Login"
        case password = "Password"
        case confirmButton = "Register"
    }
}

class CheckInController: UIViewController {
    
//    MARK: - Model variables
    
    private var name: String? {
           didSet {
               nameField.text = name
           }
       }

    private var surName: String? {
        didSet {
            surNameField.text = surName
        }
    }
    
    private var login: String? {
              didSet {
                  loginField.text = login
              }
          }

       private var password: String? {
           didSet {
               passwordField.text = password
           }
       }
    
    private var coreDataManager = CoreDataManager.shared
    
//    MARK: - UI elements
    
    private var nameField = UserInfoTextField()
    private var surNameField = UserInfoTextField()
    private var loginField = UserInfoTextField()
    private var passwordField = UserInfoTextField()
    private var confirmButton = UIButton()
    
//    MARK: - LifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        configureNameField()
        configureSurNameField()
        configureLoginField()
        configurePasswordField()
        configureConfirmButton()
        
        embedInStackView()
        
        configureTapGesture()
    }
    
//    MARK: - UI configuration
    
    private func configureNameField() {
        nameField.placeholder = CheckInViewConstants.ElementsNames.name.rawValue
        nameField.delegate = self
    }
    
    private func configureSurNameField() {
        surNameField.placeholder = CheckInViewConstants.ElementsNames.surName.rawValue
        surNameField.delegate = self
    }
    
    private func configureLoginField() {
        loginField.placeholder = CheckInViewConstants.ElementsNames.login.rawValue
        loginField.delegate = self
    }

    private func configurePasswordField() {
        passwordField.placeholder = CheckInViewConstants.ElementsNames.password.rawValue
        passwordField.delegate = self

//        This cause some errors
//        passwordField.isSecureTextEntry = true
    }
    
    private func configureConfirmButton() {
        confirmButton.setTitle(CheckInViewConstants.ElementsNames.confirmButton.rawValue, for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.backgroundColor = UIColor(named: "AttentionColor")
        confirmButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func embedInStackView() {
        let stack = UIStackView(arrangedSubviews: [nameField, surNameField, loginField, passwordField, confirmButton])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            stack.heightAnchor.constraint(equalToConstant: 270)
        ])
    }
    
//    MARK: - Tap handling
    
    @objc private func handleTap () {
        view.endEditing(true)
    }
    
    @objc private func registerButtonTapped() {
        view.endEditing(true)
        
        if let login = login, let password = password, let name = name, let surName = surName {
            let userInfo = UserInfo(name: name, surName: surName, login: login, password: password)
            coreDataManager.addUserRecordIntoCoreData(user: userInfo)
            let mainController = MainViewController()
            navigationController?.pushViewController(mainController, animated: true)
            
            clearController()
        }
    }
    
//    MARK: - Clear controller
    
    private func clearController() {
        login = nil
        password = nil
        name = nil
        surName = nil
    }
}

//MARK: - TextFieldDelegate

extension CheckInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var nextResponder: UserInfoTextField?
        
        switch(textField) {
        case nameField:
            nextResponder = surNameField
        case surNameField:
            nextResponder = loginField
        case loginField:
            nextResponder = passwordField
        default:
            break
        }
        
        if let nextResponder = nextResponder {
            nextResponder.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text != "" {
            switch (textField) {
            case loginField:
                login = text
            case passwordField:
                password = text
            case nameField:
                name = text
            case surNameField:
                surName = text
                
            default: break
            }
        }
    }
}
