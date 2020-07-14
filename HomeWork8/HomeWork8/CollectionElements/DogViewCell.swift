//
//  DogViewCell.swift
//  HomeWork8
//
//  Created by Gleb Uvarkin on 06.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class DogViewCell: UICollectionViewCell {
//    MARK: - Properties
    
    private var dogImageView: UIImageView?
    private var breedLabel: UILabel?

//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAndConfigureImageView()
        addAndConfigureBreedLabel()
        
        setImageViewConstraints()
        setBreedLabelConstraints()
        setGradientToImage()
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
//    MARK: Add and configure ImageView
    
    private func addAndConfigureImageView() {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        dogImageView = imageView
        contentView.addSubview(imageView)
    }
    
    private func setGradientToImage() {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.6, 1]
        dogImageView?.layer.insertSublayer(gradient, at: 0)
    }
    
//    MARK: - Add and configure UILabel
    
    private func addAndConfigureBreedLabel() {
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        textLabel.textColor = #colorLiteral(red: 0.7772983313, green: 0.2695689797, blue: 0.9137061238, alpha: 1)
        textLabel.numberOfLines = 0
        
        breedLabel = textLabel
        dogImageView?.addSubview(textLabel)
    }
    
//    MARK: - Set constraints
    
    private func setImageViewConstraints() {
        if let imageView = dogImageView {
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        }
    }
    
    private func setBreedLabelConstraints() {
        if let textLabel = breedLabel, let superView = textLabel.superview {
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 5),
                textLabel.bottomAnchor.constraint(equalTo: superView.bottomAnchor,constant: -5),
                textLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 5)
            ])
        }
    }
    
//    MARK: - Update content
    
    public func updateContent(with model: DogCellModel) {
        dogImageView?.image = UIImage(named: model.dogBreed)
        breedLabel?.text = model.dogBreed
    }
    
}
