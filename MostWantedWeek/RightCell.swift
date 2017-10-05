//
//  RightCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/18/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class DirectoryCell: BaseCell{
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        layer.cornerRadius = 5
        
        addSubview(dateLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dateLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: dateLabel)
    }
}

class RightCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    let dates = ["Before MWW", "Monday, October 16", "Tuesday, October 17", "Wednesday, October 18", "Thursday, October 19", "Friday, October 20"]
    let dimView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 225, green: 225, blue: 225)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.rgb(red: 225, green: 225, blue: 225)
        addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        collectionView.register(DirectoryCell.self, forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DirectoryCell
        cell.dateLabel.text = dates[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eventCollectionView = EventCollectionView()
        eventCollectionView.selectedDate = indexPath.item
        eventCollectionView.showView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.8, height: frame.height * 0.12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

