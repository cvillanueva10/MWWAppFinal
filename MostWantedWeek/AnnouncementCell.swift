//
//  AnnouncementCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/5/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnnouncementCell: BaseCell{
    
    var matchingFromId: Bool?
    var fromId: String?
    var childRef: String?
    
    var announcement: Announcement? {
        didSet{
            self.announcementTextView.text = announcement?.text
            self.timeStamp.text = announcement?.timeFormatted
            self.userName.text = announcement?.name
            self.fromId = announcement?.fromId
            self.childRef = announcement?.childRef
            self.headerLabel.text = announcement?.header
        }
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let announcementTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let headerLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        return line
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        return view
    }()
    
    let userName: UILabel = {
        let name = UILabel()
        name.backgroundColor = .white
        name.textAlignment = .right
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let timeStamp: UILabel = {
        let text = UILabel()
        text.backgroundColor = .white
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.rgb(red: 140, green: 140, blue: 140)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var centerCell: CenterCell?
    
    override func setupViews(){
        
        addSubview(headerLabel)
        addSubview(announcementTextView)
        addSubview(seperatorView)
        addSubview(userName)
        addSubview(timeStamp)
        addSubview(headerLine)
        
        //Horizontal
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: announcementTextView)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: headerLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: headerLine)
        addConstraintsWithFormat(format: "H:|-16-[v0(\(frame.width/2))]", views: timeStamp)
        
        //Vertical
        addConstraintsWithFormat(format: "V:|-8-[v0(40)]-4-[v1(2)]-4-[v2]-8-[v3(30)]-16-[v4(10)]|", views: headerLabel, headerLine, announcementTextView, timeStamp, seperatorView)
        
        //Username constraints
        //top
        addConstraint(NSLayoutConstraint(item: userName, attribute: .top, relatedBy: .equal, toItem: timeStamp, attribute: .top, multiplier: 1, constant: 0))
        
        //left
        addConstraint(NSLayoutConstraint(item: userName, attribute: .left, relatedBy: .equal, toItem: timeStamp, attribute: .right, multiplier: 1, constant: 8))
        
        //right
        addConstraint(NSLayoutConstraint(item: userName, attribute: .right, relatedBy: .equal, toItem: announcementTextView, attribute: .right, multiplier: 1, constant: 0))
        
        //height
        addConstraint(NSLayoutConstraint(item: userName, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        //Seperator line
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        
        
    }
}


