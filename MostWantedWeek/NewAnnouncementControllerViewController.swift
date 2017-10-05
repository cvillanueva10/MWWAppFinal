//
//  NewAnnouncementControllerViewController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/31/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class NewAnnouncementController: UIViewController {
    
    let announcementHeaderField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Header Title"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let announcementNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var announcementTextField : UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 20)
        text.isEditable = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let headerSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 150, green: 150, blue: 150)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let nameSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 150, green: 150, blue: 150)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    lazy var postButtonView : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCreatePost), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "New Announcement"
        view.backgroundColor = .white
        
        setupAnnouncementTextFields()
        setupPostButtonView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        announcementTextField.becomeFirstResponder()
    }
    
    func handleCreatePost(){
        
        if announcementTextField.text.isEmpty{
            print("Message is empty")
            return
        }
        if (announcementHeaderField.text?.isEmpty)!{
            print("Header is empty")
            return
        }
        if (announcementNameField.text?.isEmpty)!{
            print("Name is empty")
            return
        }
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        let ref = Database.database().reference().child("announcements")
        let childRef = ref.childByAutoId()
        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
        let childRefString = String(describing: childRef)
        if let headerText = self.announcementHeaderField.text, let bodyText = self.announcementTextField.text, let nameText = self.announcementNameField.text {
            
            let values = ["header" : headerText, "text" : bodyText, "name" : nameText, "timeStamp" : timeStamp, "timeFormatted" : formatter.string(from: date), "childRef" : childRefString] as [String : Any]
            
            childRef.updateChildValues(values)
        }
        else {
            
            //IMPLEMENT ERROR MESSAGE
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    func setupAnnouncementTextFields(){
        view.addSubview(announcementHeaderField)
        view.addSubview(announcementNameField)
        view.addSubview(announcementTextField)
        view.addSubview(headerSeparatorLine)
        view.addSubview(nameSeparatorLine)
        
        announcementHeaderField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        announcementHeaderField.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        announcementHeaderField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        announcementHeaderField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerSeparatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerSeparatorLine.topAnchor.constraint(equalTo: announcementHeaderField.bottomAnchor, constant: 5).isActive = true
        headerSeparatorLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        announcementNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        announcementNameField.topAnchor.constraint(equalTo: headerSeparatorLine.bottomAnchor, constant: 5).isActive = true
        announcementNameField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        announcementNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameSeparatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nameSeparatorLine.topAnchor.constraint(equalTo: announcementNameField.bottomAnchor, constant: 5).isActive = true
        nameSeparatorLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        announcementTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        announcementTextField.topAnchor.constraint(equalTo: nameSeparatorLine.bottomAnchor, constant: 5).isActive = true
        announcementTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        announcementTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupPostButtonView(){
        view.addSubview(postButtonView)
        
        postButtonView.rightAnchor.constraint(equalTo: announcementTextField.rightAnchor).isActive = true
        postButtonView.topAnchor.constraint(equalTo: announcementTextField.bottomAnchor, constant: 20).isActive = true
        postButtonView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        postButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
