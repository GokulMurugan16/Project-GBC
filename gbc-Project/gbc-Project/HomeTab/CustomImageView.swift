//
//  CustomImageView.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-11-25.
//

import Foundation
import UIKit


let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        image = nil
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("Couldn't load image")
                return
            }
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}

