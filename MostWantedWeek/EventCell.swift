//
//  EventCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/18/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase


class EventCollectionView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var selectedDate: Int?
    let headerId = "headerId"
    let bodyId = "bodyId"
    let dateIds = ["B", "M", "T", "W", "R", "F"]
    let headerNames = ["Before MWW", "M: Fellowship Day", "T: Service Day", "W: Scholarship Day", "R: Leadership Day", "F: Reveal Day"]
    let dimView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        cv.addGestureRecognizer(swipeDown)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init() {
        super.init()
        collectionView.frame = CGRect(x: 0, y: 1000, width: 500, height: 500)
        collectionView.backgroundColor = UIColor.rgb(red: 225, green: 225, blue: 225)
        collectionView.register(EventHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(EventBodyCell.self, forCellWithReuseIdentifier: bodyId)
    }
    
    func showView(){
        
        if let selectedIndex = selectedDate{
            observeEvents(dateId: dateIds[selectedIndex])
        }
        
        if let window = UIApplication.shared.keyWindow {
            let cvHeight = window.frame.height * 0.7
            let windowHeight = window.frame.height
            let windowWidth = window.frame.width
            
            window.addSubview(dimView)
            window.addSubview(collectionView)
            
            dimView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            dimView.frame = window.frame
            dimView.alpha = 0
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.collectionView.frame = CGRect(x: 0, y: windowHeight - cvHeight, width: windowWidth, height: cvHeight)
                self.dimView.alpha = 1
                
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow {
                let windowHeight = window.frame.height
                self.collectionView.frame = CGRect(x: 0, y: windowHeight, width: window.frame.width, height: windowHeight)
                self.dimView.alpha = 0
            }
        }, completion: nil)
    }
    
    var eventObjs = [Event]()
    func observeEvents(dateId: String){
        
        self.eventObjs.removeAll()
        
        let ref = Database.database().reference().child("schedule").child(dateId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let event = Event()
                event.setValuesForKeys(dictionary)
                
                self.eventObjs.append(event)
                self.eventObjs.sort(by: { (e1, e2) -> Bool in
                    (e1.orderNum?.intValue)! < (e2.orderNum?.intValue)!
                })
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let window = UIApplication.shared.keyWindow {
            return CGSize(width: window.frame.width, height: window.frame.height * 0.1)
        }
        return CGSize (width: 500, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EventHeaderCell
        
        if let selectedIndex = selectedDate{
            header.headerLabel.text = headerNames[selectedIndex]
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventObjs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bodyId, for: indexPath) as! EventBodyCell
        cell.event = eventObjs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let eventDescription = eventObjs[indexPath.item].eventDescription, let window = UIApplication.shared.keyWindow {
            
            let rect = NSString(string: eventDescription).boundingRect(with: CGSize(width: window.frame.width, height: 2000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight: CGFloat = 40 + 30
            
            return CGSize(width: window.frame.width, height: rect.height + knownHeight + 40)
        }
        return CGSize(width: 500 , height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

class EventHeaderCell: BaseCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        
        addSubview(headerLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: headerLabel)
        
    }
    
}

class EventBodyCell: BaseCell {
    
    var event: Event? {
        didSet{
            self.eventDate.text = event?.date
            self.eventName.text = event?.name
            self.eventLocation.text = event?.location
            self.eventTime.text = event?.time
            self.eventDescription.text = event?.eventDescription
        }
    }
    
    let eventDate: UILabel = {
        let date = UILabel()
        date.font = UIFont.boldSystemFont(ofSize: 26)
        date.layer.borderColor = UIColor.black.cgColor
        date.layer.borderWidth = 0.5
        date.textAlignment = .center
        date.backgroundColor = UIColor.rgb(red: 200, green: 31, blue: 32)
        date.textColor = .white
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    let eventName: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 24)
        name.textAlignment = .center
        name.layer.borderColor = UIColor.black.cgColor
        name.layer.borderWidth = 0.5
        name.backgroundColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let eventTime: UILabel = {
        let time = UILabel()
        time.textAlignment = .center
        time.layer.borderColor = UIColor.black.cgColor
        time.layer.borderWidth = 0.5
        time.font = UIFont.boldSystemFont(ofSize: 16)
        time.backgroundColor = .white
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    let eventLocation: UILabel = {
        let location = UILabel()
        location.textAlignment = .center
        location.layer.borderColor = UIColor.black.cgColor
        location.layer.borderWidth = 0.5
        location.font = UIFont.boldSystemFont(ofSize: 16)
        location.backgroundColor = .white
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    
    let eventDescription: UITextView = {
        let description = UITextView()
        description.font = UIFont.systemFont(ofSize: 14)
        description.layer.borderColor = UIColor.black.cgColor
        description.layer.borderWidth = 0.5
        description.isEditable = false
        description.isScrollEnabled = false
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    override func setupViews() {
        addSubview(eventDate)
        addSubview(eventName)
        addSubview(eventTime)
        addSubview(eventLocation)
        addSubview(eventDescription)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: eventDate)
        addConstraintsWithFormat(format: "H:|[v0]|", views: eventName)
        addConstraintsWithFormat(format: "H:[v0(\(frame.width/2))]|", views: eventTime)
        addConstraintsWithFormat(format: "H:|[v0]|", views: eventDescription)
        
        addConstraintsWithFormat(format: "V:|[v0(40)]-0-[v1(30)]-0-[v2]|", views: eventName, eventTime, eventDescription)
        
        addConstraint(NSLayoutConstraint(item: eventLocation, attribute: .left, relatedBy: .equal, toItem: eventName, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: eventLocation, attribute: .top, relatedBy: .equal, toItem: eventTime, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: eventLocation, attribute: .width, relatedBy: .equal, toItem: eventTime, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: eventLocation, attribute: .height, relatedBy: .equal, toItem: eventTime, attribute: .height, multiplier: 1, constant: 0))
        
    }
}
