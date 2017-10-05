//
//  ScoreCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/18/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class ScoreCell: BaseCell {
    
    let teamLogo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.layer.masksToBounds = true
        //  logo.layer.cornerRadius = 40
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.borderWidth = 0.5
        return logo
    }()
    
    let teamName: UILabel = {
        let name = UILabel()
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = 0
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.textAlignment = .center
        name.baselineAdjustment = .alignBaselines
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let scoreNumber: UILabel = {
        let num = UILabel()
        num.font = UIFont.boldSystemFont(ofSize: 18)
        num.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        num.textAlignment = .center
        num.translatesAutoresizingMaskIntoConstraints = false
        return num
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
    
    let ranks: [String] = ["1st", "2nd", "3rd", "4th", "5th"]
    
    var score: Score? {
        didSet{
            self.teamName.text = score?.name
            
            
            if let scoreRank = score?.rank?.intValue{
                self.rankLabel.text = ranks[scoreRank]
            }
            if let scoreNum = score?.score {
                self.scoreNumber.text = "\(scoreNum) PTS"
            }
            if let logoName = score?.logo{
                self.teamLogo.image = UIImage(named: logoName)
            }
        }
    }
    
    override func setupViews(){
        addSubview(teamLogo)
        addSubview(teamName)
        addSubview(scoreNumber)
        addSubview(rankLabel)
        addSubview(separatorLine)
        
        addConstraintsWithFormat(format: "H:|-10-[v0(40)]-5-[v1]-5-[v2(120)]-10-|", views: rankLabel, teamName, teamLogo)
        
        addConstraintsWithFormat(format: "V:|-35-[v0(40)]", views: rankLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        addConstraintsWithFormat(format: "V:|-20-[v0]-20-[v1(10)]|", views: teamLogo, separatorLine)
        
        addConstraintsWithFormat(format: "V:|-10-[v0(50)]", views: teamName)
        
        addConstraint(NSLayoutConstraint(item: scoreNumber, attribute: .top, relatedBy: .equal, toItem: teamName, attribute: .bottom, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: scoreNumber, attribute: .left, relatedBy: .equal, toItem: teamName, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: scoreNumber, attribute: .right, relatedBy: .equal, toItem: teamName, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: scoreNumber, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40))
    }
}

