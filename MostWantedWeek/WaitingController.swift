//
//  WaitingController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 9/4/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class WaitingController: UIViewController {
    
    let messageTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.boldSystemFont(ofSize: 32)
        view.textAlignment = .center
        view.text = "You may endorse an organization again in "
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let minutesNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minutesTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.text = "Minutes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var homeController: HomeController?
    
    func iniitalizeTimeStamp(uid: String){
        let initialTimeStamp: Int = Int(NSDate().timeIntervalSince1970)
        
            let values = ["initial": initialTimeStamp]
            Database.database().reference().child("sessions").child(uid).updateChildValues(values)
    }
    
    func calculateWaitTime() {
        
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("sessions").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let currentTime: Int = Int(NSDate().timeIntervalSince1970)
                if let dictionary = snapshot.value as? [String: Any] {
                    let initialTime = dictionary["initial"] as! Int
                    let timeElapsed = (currentTime - initialTime) / 60
                    let timeRemaining = 1 - timeElapsed
                    
                    if timeRemaining == 1 {
                        self.minutesTextLabel.text = "Minute"
                    }
                    
                    if timeRemaining > 0 {
                        self.minutesNumberLabel.text = "\(timeRemaining)"
                    }
                    else if timeRemaining <= 0 {
                        self.minutesNumberLabel.text = "0"
                        let user = Auth.auth().currentUser
                        user?.delete(completion: { (error) in
                            if error != nil {
                                print(error!)
                                do {
                                    try Auth.auth().signOut()
                                } catch let logoutError {
                                    print(logoutError)
                                }
                            }
                            self.homeController?.switchToEndorsementPage()
                        })
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func setupViews() {
        view.addSubview(minutesNumberLabel)
        minutesNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        minutesNumberLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        minutesNumberLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        minutesNumberLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(minutesTextLabel)
        minutesTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        minutesTextLabel.topAnchor.constraint(equalTo: minutesNumberLabel.bottomAnchor).isActive = true
        minutesTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        minutesTextLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(messageTextView)
        messageTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: minutesNumberLabel.topAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        messageTextView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calculateWaitTime()
    }
    
}
