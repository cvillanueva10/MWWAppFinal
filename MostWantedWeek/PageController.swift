//
//  DescriptionController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/19/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class PageController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let headerId = "headerId"
    let bodyId = "bodyId"
    var pageTabName: String?
    
    var tab: MenuTab? {
        didSet{
            navigationItem.title = tab?.tabLabelName
            pageTabName = tab?.tabLabelName
        }
    }
    
    var pageObjs = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observePages()
        setupCollectionView()
    }
    
    func observePages(){
        Database.database().reference().child("pagetabs").child(pageTabName!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let page = Page()
                page.breakdownLabel = dictionary["breakdownlabel"] as? String
                page.breakdownText = dictionary["breakdowntext"] as? String
                page.descriptionText = dictionary["description"] as? String
                page.headerImage = dictionary["headerimage"] as? String
                page.headerLabel = dictionary["headerlabel"] as? String
                self.pageObjs.append(page)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func setupCollectionView(){
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(PageHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(PageBodyCell.self, forCellWithReuseIdentifier: bodyId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PageHeaderCell
        if pageObjs.count > 0 {
            header.pageHeader = pageObjs[indexPath.item]
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageObjs.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bodyId, for: indexPath) as! PageBodyCell
        cell.pageBody = pageObjs[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 1.5)
    }
}


