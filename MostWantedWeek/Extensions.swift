//
//  Extensions.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/5/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
            options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
        func loadImageUsingCacheWithURL(url: String){
            let url = URL(string: url)
            if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage{
                self.image = cachedImage
                return
            }
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!){
                        imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                        self.image = downloadedImage
                    }
                   
                })
            }).resume()

        }
    }




