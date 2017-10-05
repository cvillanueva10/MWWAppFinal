//
//  CenterCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/18/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class CenterCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleManualRefresh(refreshControl:)), for: .valueChanged)
        return refresh
    }()
    
    var announcementObjs = [Announcement]()
    
    override func setupViews() {
        super.setupViews()
        
        observeAnnouncements()
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(AnnouncementCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.addSubview(refreshControl)
    }
    
    func handleManualRefresh(refreshControl: UIRefreshControl) {
        
        for announcement in announcementObjs {
            if let timeStamp = announcement.timeStamp {
                announcement.timeFormatted = checkAgeOfAnnouncement(postedTime: Int(timeStamp))
            }
        }
        announcementObjs.removeAll()
        observeAnnouncements()
        refreshControl.endRefreshing()
    }
    
    func handleAutoRefresh() {
        for announcement in announcementObjs {
            if let timeStamp = announcement.timeStamp {
                announcement.timeFormatted = checkAgeOfAnnouncement(postedTime: Int(timeStamp))
            }
        }
        announcementObjs.removeAll()
        observeAnnouncements()
        refreshControl.endRefreshing()
    }
    
    func observeAnnouncements(){
        
        let ref = Database.database().reference().child("announcements")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let announcement = Announcement()
                announcement.setValuesForKeys(dictionary)
                if let timeStamp = announcement.timeStamp {
                    announcement.timeFormatted = self.checkAgeOfAnnouncement(postedTime: Int(timeStamp))
                }
                
                self.announcementObjs.append(announcement)
                self.announcementObjs.sort(by: { (announcement1, announcement2) -> Bool in
                    return (announcement1.timeStamp?.intValue)! > (announcement2.timeStamp?.intValue)!
                })
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }
    
    func checkAgeOfAnnouncement(postedTime: Int) -> String {
        
        let currentTime: Int = Int(NSDate().timeIntervalSince1970)
        let difference = currentTime - postedTime
        let initialString = "Posted "
        if difference == 0 {
            return initialString + "Just Now"
        }
        else if difference > 0 && difference < 60 {
            return initialString + "\(difference) Seconds Ago"
        }
        else if difference >= 60 && difference < 120 {
            return initialString + "\(difference / 60) Minute Ago"
        }
        else if difference >= 120 && difference < 3600 {
            return initialString + "\(difference / 60) Minutes Ago"
        }
        else if difference >= 3600 && difference < 7200 {
            return initialString + "\(difference / 3600) Hour Ago"
        }
        else if difference >= 7200 && difference < 86400 {
            return initialString + "\(difference / 3600) Hours Ago"
        }
        else if difference >= 86400 && difference < 172800 {
            return initialString + "\(difference / 86400) Day Ago"
        }
        else if difference >= 172800 && difference < 604800 {
            return initialString + "\(difference / 86400) Days Ago"
        }
        else if difference >= 604800 && difference < 1209600 {
            return initialString + "\(difference / 604800) Week Ago"
        }
        else {
            return initialString + "\(difference / 604800) Weeks Ago"
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcementObjs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AnnouncementCell
        cell.centerCell = self
        cell.announcement = announcementObjs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let announcementText = announcementObjs[indexPath.item].text{
            
            let rect = NSString(string: announcementText).boundingRect(with: CGSize(width: frame.width, height: 2000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight: CGFloat = 16 + 30 + 8 + 44 + 8 + 16 + 1
            
            return CGSize(width: frame.width, height: rect.height + knownHeight + 60)
        }
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
