//
//  CollectionManager.swift
//  HomeWork8
//
//  Created by Gleb Uvarkin on 05.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation
import UIKit

public typealias UICollectionViewManager = UICollectionViewDelegateFlowLayout & UICollectionViewDataSource

class CollectionManager: NSObject {
    
    //Hardcode contents of a cell (as menthioned in task)
    let dogs: [[DogCellModel]] = [[DogCellModel(breed: "Boseron", color: .black),
                                DogCellModel(breed: "Mudi", color: .black)],
                                [DogCellModel(breed: "Akita-Inu", color: .orange),
                                DogCellModel(breed: "Boxer", color: .orange)],
                                [DogCellModel(breed: "EnglishBuldog", color: .white),
                                DogCellModel(breed: "ArgentinianDog", color: .white)]]
}

extension CollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DogColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let color = DogColor.allCases[section]
        return DogCellModel.dogCounter[color] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogViewCell
        cell.updateContent(with: dogs[indexPath.section][indexPath.row])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? DogHeaderReusableView
                else {
                    fatalError("Invalid header view type")
            }
            headerView.updateContent(with: dogs[indexPath.section][indexPath.row])
            return headerView
        default:
            assert(false, "Invalid element type")
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 75, height: 20)
    }
    
}

extension CollectionManager: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 50)
    }
    
    
}
