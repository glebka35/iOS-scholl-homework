//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    
    lazy var targetView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAndSetConstraintsToImageView()
        
        displayImageAndObjects()
    }
    
    private func displayImageAndObjects() {
        let imageName = "pen"
        if let image = UIImage(named: imageName){
            print("image size = ", image.size)
            if let data = image.jpegData(compressionQuality: 0.3) {
//                imageView.image = UIImage(data: data)
                let cloudMersive = CloudMersiveClient()
                cloudMersive.getRecognition(of: data, name: imageName) {[weak self] objects, success in
                    if let object = objects?.first {
                        let rect = CGRect(x: object.x, y: object.y, width: object.width - object.x, height: object.height - object.y)
                        DispatchQueue.main.async { [weak self] in
                            self?.drawRectangleOnImage(with: UIImage(data: data)!, and: rect)
                        }
                    }
                }
            }
        }
    }
    
    private func drawRectangleOnImage(with image: UIImage, and rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(at: CGPoint.zero)
        let path = UIBezierPath(rect: rect)
        UIColor.red.setStroke()
        path.lineWidth = 10
        path.stroke()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = newImage
        
        print("rect in api response = ", rect)
        print("image size after data = ", image.size)
    }
    
    private func configureAndSetConstraintsToImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
}

