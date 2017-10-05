//
//  DeleteController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 9/6/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class DeleteController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ViewCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelection = true
        observeAnnouncements()
        
    }
    
    var announcementObjs = [Announcement]()
    
    func observeAnnouncements() {
        
        let ref = Database.database().reference().child("announcements")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let announcement = Announcement()
                announcement.header = dictionary["header"] as? String
                announcement.name = dictionary["name"] as? String
                announcement.childRef = dictionary["childRef"] as? String
                self.announcementObjs.append(announcement)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let announcement = announcementObjs[indexPath.row]
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementObjs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let announcement = announcementObjs[indexPath.row]
        
        cell.textLabel?.text = announcement.header
        cell.detailTextLabel?.text = announcement.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.1
    }
}

class ViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
