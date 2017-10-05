//
//  SettingCells.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/10/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class SideMenuCells: BaseCell {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.white
            tabLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            tabIcon.tintColor = isHighlighted ? UIColor.white : UIColor.lightGray
        }
    }
    var menuTab: MenuTab? {
        didSet{
            tabLabel.text = menuTab?.tabLabelName
            tabLabel.font = menuTab?.tabLabelFont
            
           if let logoImageName = menuTab?.tabLogoName{
                tabIcon.image = UIImage(named: logoImageName)?.withRenderingMode(.alwaysTemplate)
                tabIcon.tintColor = UIColor.rgb(red: 180, green: 180, blue: 180)
            }
        }
    }
    
    let tabLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tabIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tabLabel)
        addSubview(tabIcon)
        addSubview(separatorLine)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(\(frame.width * 0.2))]-8-[v1]|", views: tabIcon, tabLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine )
        
        addConstraintsWithFormat(format: "V:|-0-[v0(1)]-[v1(\(frame.width * 0.2))]-8-|", views: separatorLine, tabIcon)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: tabLabel)
        
        addConstraint(NSLayoutConstraint(item: tabIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
       
        }
}
