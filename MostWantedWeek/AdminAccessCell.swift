//
//  AdminAccessCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/27/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class AdminAccessCell: BaseCell {
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.rgb(red: 150, green: 150, blue: 150)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let accessNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        addSubview(iconImageView)
        addSubview(accessNameLabel)
        
        addConstraintsWithFormat(format: "V:|-5-[v0]", views: iconImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: accessNameLabel)
        addConstraintsWithFormat(format: "H:|[v0(\(frame.width * 0.25))]-0-[v1]|", views: iconImageView, accessNameLabel)
    }
}

