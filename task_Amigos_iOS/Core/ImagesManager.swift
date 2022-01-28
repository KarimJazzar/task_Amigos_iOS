//
//  ImagerManager.swift
//  task_Amigos_iOS
//
//  Created by febinrukfan772 on 1/20/22.
//

import Foundation
import UIKit

class ImagesManager {
    
    private var imagesList: [String] = [String]()
    private let fileManager: FileManager = FileManager.default
    private let directory: URL
    private var view: UIViewController = UIViewController()
    private var imagePicker: UIImagePickerController = UIImagePickerController()
    
    init(){
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            directory = dir
        } else {
            directory = URL(fileURLWithPath: "")
        }
    }
    
    func setUpManager(view: UIViewController, imagePicker: UIImagePickerController) {
        self.view = view
        self.imagePicker = imagePicker
        
    }
    
    func setImagesList(imagesList: [String]) {
        self.imagesList = imagesList
    }
    
    func generateView() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            view.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openGallery() {
        imagePicker.delegate = view as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        view.present(imagePicker, animated: true, completion: nil)
    }

    func savePicketmage(info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage{
            if let fileUrl = info[.imageURL] as? URL {
                var tempName = "\(Date())"
                tempName = tempName.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
                print("\(tempName)")
                saveImage(image: editedImage, name: "\(tempName).png")
            }
        }
    }
    
    private func saveImage(image: UIImage, name: String) {
        guard let data = image.pngData() else {
            print("Error getting data.")
            return
        }
        
        if directory.path == "/" { return }
        
        let path = directory.appendingPathComponent("\(name)")
        
        do {
            try data.write(to: path)
            
            if let avc = view as? AddViewController {
                imagesList.append(name)
                avc.updateImagesTable(images: imagesList)
            }
        } catch let error {
            print("\(error)")
        }
    }
    
    func removeNotSavedImages(images: [String]) {
        if directory.path == "/" { return }
        
        for name in imagesList {
            if images.firstIndex(of: name) ?? -1 < 0 {
                do {
                    let path = directory.appendingPathComponent(name)
                    
                    try fileManager.removeItem(at: path)
                } catch {
                    print("Could not remove image: \(error)")
                }
            }
        }
    }
    
    func loadImage(name : String) -> UIImage {
        let defaultImg = UIImage(systemName: "doc")!
        
        if directory.path == "/" { return defaultImg }
        
        let path = directory.appendingPathComponent("\(name)")
        
        do {
            let imageData = try Data(contentsOf: path)
            return UIImage(data: imageData) ?? defaultImg
        } catch let error {
            print("\(error)")
        }
        
        return defaultImg
   }
}

