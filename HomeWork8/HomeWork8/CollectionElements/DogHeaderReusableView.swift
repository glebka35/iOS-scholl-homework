//
//  DogHeaderReusableView.swift
//  HomeWork8
//
//  Created by Gleb Uvarkin on 06.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class DogHeaderReusableView: UICollectionReusableView {
    private var textLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAndConfigureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setLabelConstraints()
    }
    
    private func addAndConfigureLabel() {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = #colorLiteral(red: 0.9461402297, green: 0.8609151244, blue: 0.9620150924, alpha: 1)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = #colorLiteral(red: 0.4627425075, green: 0.2627956271, blue: 0.8391128182, alpha: 0.7607555651)
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.3647171259, green: 0.06686695665, blue: 0.9685086608, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        textLabel = label
        self.addSubview(label)
    }
    
    private func setLabelConstraints() {
        if let label = textLabel, let superView = label.superview {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: superView.topAnchor, constant: 50),
                label.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        }
    }
    
    public func updateContent(with model: DogCellModel) {
        textLabel?.text = model.dogColor.rawValue
    }
}
