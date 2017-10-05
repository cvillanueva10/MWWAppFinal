//
//  MenuBar.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/5/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class LowerMenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    let iconNames = ["scoreboard", "announcements", "schedule"]
    
    var homeController: HomeController?
    var horizontalBarLeftAnchorConstrait : NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        cv.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
        cv.layer.borderWidth = 0.5
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

        let selectedIndex = NSIndexPath(item: 1, section: 0) as IndexPath
        collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.rgb(red: 200, green: 13, blue: 12)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstrait = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstrait?.isActive = true
        horizontalBarView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 5).isActive = true
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
            for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: iconNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 160, green: 160, blue: 160)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        horizontalBarLeftAnchorConstrait?.constant = frame.width / 3
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.scrollToSectionIndex(sectionIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.rgb(red: 200, green: 13, blue: 12) : UIColor.rgb(red: 160, green: 160, blue: 160)
        }
    }
    
    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:[v0(50)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}



