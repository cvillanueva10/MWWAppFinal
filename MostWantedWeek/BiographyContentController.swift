//
//  BiographyContentController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/14/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class BiographyContent: NSObject {
    
    lazy var bioImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 1
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        return iv
    }()
    
    lazy var bioContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
        return view
    }()
    
    lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let classLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let majorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.rgb(red: 100, green: 100, blue: 100)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let backgroundFillerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        return view
    }()

    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    var contentHeight: CGFloat?
    var centerX: CGFloat?
    var imageCenterY: CGFloat?
    
    func setupBioContentView(biography: Biography){
        
        if let imageUrl = biography.imageUrl {
            bioImageView.loadImageUsingCacheWithURL(url: imageUrl)
        }
   
        if let year = biography.year {
            yearLabel.text = "Year: " + year
        }
     
        nameLabel.text = biography.name
        majorLabel.text = biography.major
        classLabel.text = biography.pledgeClass
        descriptionTextView.text = biography.descriptionText
   
        bioContentView.addSubview(nameLabel)
        bioContentView.addSubview(yearLabel)
        bioContentView.addSubview(majorLabel)
        bioContentView.addSubview(classLabel)
        bioContentView.addSubview(separatorLine)
        bioContentView.addSubview(descriptionTextView)

        bioContentView.addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        bioContentView.addConstraintsWithFormat(format: "H:|-0-[v0(\(bioContentView.frame.width * 0.5))]-0-[v1]-0-|", views: yearLabel, classLabel)
        bioContentView.addConstraintsWithFormat(format: "H:|[v0]|", views: majorLabel)
        bioContentView.addConstraintsWithFormat(format: "H:|[v0]|", views: descriptionTextView)
        bioContentView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)

        bioContentView.addConstraintsWithFormat(format: "V:|-(\(bioImageView.frame.height * 0.5 - 30))-[v0(40)]-0-[v1(35)]-0-[v2(35)]-0-[v3(3)]-0-[v4]-0-|", views: nameLabel, yearLabel, majorLabel, separatorLine, descriptionTextView)
        
        classLabel.topAnchor.constraint(equalTo: yearLabel.topAnchor).isActive = true
        classLabel.heightAnchor.constraint(equalTo: yearLabel.heightAnchor).isActive = true
        
    }
    
    func showBioView(biography: Biography){
        
        if let window = UIApplication.shared.keyWindow{
            let imageWidth = window.frame.width * 0.4
            let imageHeight = imageWidth
            let contentHeight = window.frame.height * 0.5
            let centerX = window.frame.width * 0.5
            let centerY = window.frame.height * 0.5
            
            window.addSubview(dimView)
            window.addSubview(bioContentView)
            window.addSubview(bioImageView)
            
            dimView.frame = window.frame
            dimView.alpha = 0
            
            bioImageView.layer.cornerRadius = imageHeight * 0.5
            bioImageView.frame = CGRect(x: centerX - (imageWidth * 0.5), y: window.frame.height, width: imageWidth, height: imageHeight)
            bioContentView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: contentHeight)

            setupBioContentView(biography: biography)
     
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.dimView.alpha = 1
                self.bioImageView.frame = CGRect(x: centerX - (imageWidth * 0.5), y: centerY - (imageHeight * 0.5) - 30, width: imageWidth, height: imageHeight)
                self.bioContentView.frame = CGRect(x: 0, y: window.frame.height - contentHeight, width: window.frame.width, height: contentHeight)
            }, completion: nil)
        }
    }
    
    func handleDismiss(gesture: UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow {
                let imageWidth = window.frame.width * 0.4
                let imageHeight = imageWidth
                let contentHeight = window.frame.height * 0.5
                let centerX = window.frame.width * 0.5
                
                self.bioImageView.frame = CGRect(x: centerX - (imageWidth * 0.5), y: window.frame.height, width: imageWidth, height: imageHeight)
                self.bioContentView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: contentHeight)
                self.dimView.alpha = 0
            }
        }, completion: nil)
    }
    
    override init() {
        super.init()
    }
}

