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
        showGaleryImagePicker()

        let client = TranslationClient()
        client.getTranslation(of: "House!", from: "en", to: "es") { (translation) in
            print(translation)
        }
    }
    
    private func displayImageAndObjects(with image: UIImage) {

                let imageName = "cup"
        //        if let image = UIImage(named: imageName){
        //            print("Initial image size = ", image.size)
        //
        //            let aspectRatio = image.size.height / image.size.width
        //            let width: CGFloat = 3024
        //            let height = aspectRatio * width
        //            let newSize = CGSize(width: width, height: height)
        //            UIGraphicsBeginImageContext( newSize )
        //            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        //            let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        //            UIGraphicsEndImageContext();

        //            let newImage = image


//        print("Last image size = ", image.size)
        if let data = image.jpegData(compressionQuality: 1) {
            imageView.image = UIImage(data: data)
            let nsData = NSData(data: data)
            var imageSize: Int = nsData.count
            print(Double(imageSize) / 1000000)
            let cloudMersive = CloudMersiveClient()
            cloudMersive.getRecognition(of: data, name: imageName) {[weak self] objects, success in
                if let object = objects?.first {
                    let rect = CGRect(x: object.x, y: object.y, width: object.width - object.x, height: object.height - object.y)
                    DispatchQueue.main.async { [weak self] in
                        self?.drawRectangleOnImage(with: UIImage(data: data)!, and: rect)
                    }
                } else {
                    print("Objects is empty")
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

    func showGaleryImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        self.present(pickerController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            displayImageAndObjects(with: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
