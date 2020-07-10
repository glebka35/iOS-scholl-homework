//
//  UserInfoTextField.swift
//  Registration
//
//  Created by Gleb Uvarkin on 10.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class UserInfoTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .left
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
