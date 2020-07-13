//
//  TableViewController.swift
//  Registration
//
//  Created by Gleb Uvarkin on 13.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
//    MARK: - Models variables
    
    private var cars = [CarInfo]()
    
//    MARK: - UI elements
    
    private var topBar = UIView()
    private var tableView = UITableView()
    
//    MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        title = "Cars"
        
        fetchCarsFromCoreData()
        addAndConfigureTopBar()
        addAndConfigureTableView()
    }
    
//    MARK: - Fetch data from core data
    
    private func fetchCarsFromCoreData() {
        let coreDataManager = CoreDataManager.shared
        if let userCars = coreDataManager.fetchCarsOfUser() {
            cars = userCars
        }
    }
    
//    MARK: - UI elements configuration
    
    private func addAndConfigureTopBar() {
        let backButton = UIButton()
        backButton.setTitle("<Back", for: .normal)
        backButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784809947, blue: 0.9998757243, alpha: 1), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addSubview(backButton)
        
        NSLayoutConstraint.activate([
                   backButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
                   backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 15)
               ])

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topBar)
        
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addAndConfigureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "standardCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    MARK: - Tap recognising
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Table view stuff

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath)
        cell.textLabel?.text = cars[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coreDataManager = CoreDataManager.shared
            coreDataManager.deleteCarInfo(car: cars[indexPath.row])
        
            cars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
