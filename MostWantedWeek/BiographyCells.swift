//
//  BiographyCells.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/14/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class BiographyCell: BaseCell {
    
    lazy var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.5
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.layer.masksToBounds = true
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    var biography: Biography? {
        didSet {
            nameLabel.text = biography?.name
            if let imageUrl = biography?.imageUrl {
                thumbnailImageView.loadImageUsingCacheWithURL(url: imageUrl)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        addSubview(nameLabel)

        thumbnailImageView.layer.cornerRadius = (frame.width-16)/2
        addConstraintsWithFormat(format: "H:|-8-[v0(\(frame.width-16))]", views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0(\(frame.width-16))]-8-[v1(\(frame.height/4))]", views: thumbnailImageView, nameLabel)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(\(frame.width-16))]", views: nameLabel)

    }
}

