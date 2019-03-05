//
//  ViewController.swift
//  altoriaPolice_new
//
//  Created by 伊藤永光 on 2019/02/19.
//  Copyright © 2019 Nito. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var service = CustomVisionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultLabel.text = ""
    }
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected an image, but was provided \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        resultLabel.text = ""
        self.activityIndicator.startAnimating()
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)!
        //ここでcustomvisionserviceを呼び出して、変換した画像を送信している
        service.predict(image: imageData, completion: { (result: CustomVisionResult?, error: Error?) in DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.resultLabel.text = error.localizedDescription
                }else if let result = result{
                    let prediction = result.Predictions[0]
                    let probabilityLabel = String(format: "%.1f", prediction.Probability * 100)
                    self.resultLabel.text = "\(probabilityLabel)% sure this is \(prediction.Tag)"
                }
            }
        })
    }
}

