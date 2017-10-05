//
//  ProfileControllerViewController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/26/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileUserNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBarView()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    func setupNavigationBarView(){
        navigationItem.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func setupView() {
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(profileUserNameLabel)
        profileUserNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileUserNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        profileUserNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        profileUserNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(organizationNameLabel)
        organizationNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        organizationNameLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: -10).isActive = true
        organizationNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        organizationNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.profileUserNameLabel.text = dictionary["name"] as? String
                    self.organizationNameLabel.text = dictionary["organization"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                        self.profileImageView.loadImageUsingCacheWithURL(url: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        profileUserNameLabel.text = ""
        organizationNameLabel.text = ""
        navigationController?.popViewController(animated: true)
    }
}
