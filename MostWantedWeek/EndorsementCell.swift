//
//  EndorsementCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 9/2/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class EndorsementCell: BaseCell {
    
    let orgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(orgImageView)
        orgImageView.layer.cornerRadius = frame.width / 2
        addConstraintsWithFormat(format: "H:|[v0]|", views: orgImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: orgImageView)
        
    }

}
