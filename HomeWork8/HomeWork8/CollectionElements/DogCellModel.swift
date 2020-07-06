//
//  DogCellModel.swift
//  HomeWork8
//
//  Created by Gleb Uvarkin on 05.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

enum DogColor: String, CaseIterable {
    case black = "Black"
    case white = "White"
    case orange = "Orange"
}

struct DogCellModel {
    static var dogCounter = [DogColor:Int]()
      
    private let breed: String
    private let color: DogColor
    
    var dogBreed: String {
        breed
    }
    
    var dogColor: DogColor {
        color
    }
    
    init(breed: String, color: DogColor) {
        self.breed = breed
        self.color = color
        
        countDog(with: color)
    }
    
    private func countDog(with color: DogColor) {
        DogCellModel.dogCounter[color] = (DogCellModel.dogCounter[color] ?? 0) + 1
    }
    
}
