//
//  AdminAccessController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/27/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class AdminAccessController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let icons = ["write", "close", ""]
    let labels = ["New Announcement", "Delete Announcement", "Update Score"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        collectionView?.backgroundColor = .white
        collectionView?.register(AdminAccessCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func handleNewAnnouncement() {
        let newAnnouncementController = NewAnnouncementController()
        navigationController?.pushViewController(newAnnouncementController, animated: true)
    }
    func handleDeleteAnnouncement() {
//        let layout = UICollectionViewFlowLayout()
//        let deleteAnnouncementController = DeleteAnnouncementController(collectionViewLayout: layout)
//        navigationController?.pushViewController(deleteAnnouncementController, animated: true)
        
        let deleteController = DeleteController()
        navigationController?.pushViewController(deleteController, animated: true)
    }
    func handleUpdateScore() {
        print(123)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.75, height: view.frame.height * 0.1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AdminAccessCell
        cell.iconImageView.image = UIImage(named: icons[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.accessNameLabel.text = labels[indexPath.item]
        if cell.accessNameLabel.text == labels[0] {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNewAnnouncement)))
        }
        else if cell.accessNameLabel.text == labels[1] {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDeleteAnnouncement)))
        }
        else if cell.accessNameLabel.text == labels[2] {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUpdateScore)))
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 0, 0, 0)
    }
}
