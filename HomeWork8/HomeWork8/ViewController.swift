//
//  ViewController.swift
//  HomeWork8
//
//  Created by Gleb Uvarkin on 05.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
//    MARK: - Collection manager
    
    private var collectionManager: UICollectionViewManager?

//    MARK: - ViewController Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = #colorLiteral(red: 0.9570989013, green: 0.9075112939, blue: 0.9724140763, alpha: 1)
        configureCollectionView()
    }
    
//    MARK: - Configure collection view
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.register(DogViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(DogHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionManager = CollectionManager()
        
        collectionView.delegate = collectionManager
        collectionView.dataSource = collectionManager
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9570989013, green: 0.9075112939, blue: 0.9724140763, alpha: 1)
    }
}
