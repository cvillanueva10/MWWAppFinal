//
//  EndorsementController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/31/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class EndorsementController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellId = "cellId"
    
    let orgs = ["Delta Gamma", "Tri Delta", "Kappa Kappa Gamma", "Phi Mu", "Kappa Delta Chi", "Lambda Theta Nu", "New one"]
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "Choose an Organization!"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var returnHomeLabelView: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturnHome)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        return view
    }()
    
    let confirmView = EndorsementConfirm()
    
    var homeController: HomeController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        setupViews()
        setupReturnHomeLabelView()
    }
    
    func handleReturnHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupReturnHomeLabelView(){
        
        view.addSubview(returnHomeLabelView)
        returnHomeLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        returnHomeLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        returnHomeLabelView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        returnHomeLabelView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupViews() {
        collectionView.register(EndorsementCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: headerLabel)
        view.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(100)]-5-[v1]-15-|", views: headerLabel, collectionView)
    }
    
    func displayConfirmView(indexPath: Int) {
        if let window = UIApplication.shared.keyWindow {
            let confirmWidth: CGFloat = window.frame.width * 0.75
            let confirmHeight: CGFloat = window.frame.height * 0.2
            let confirmX = window.frame.width / 2 - (confirmWidth / 2)
            let confirmY = window.frame.height / 2 - (confirmHeight / 2)
            
            confirmView.frame = CGRect(x: confirmX, y: window.frame.height, width: confirmWidth, height: confirmHeight)
            dimView.frame = window.frame
            dimView.alpha = 0
            
            window.addSubview(dimView)
            window.addSubview(confirmView)
            confirmView.setupViews(orgName: orgs[indexPath])
            
            confirmView.cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            confirmView.confirmButton.tag = indexPath
            confirmView.confirmButton.addTarget(self, action: #selector(handleEndorse), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.confirmView.frame = CGRect(x: confirmX, y: confirmY, width: confirmWidth, height: confirmHeight)
                self.dimView.alpha = 1
            }, completion: nil)
        }
    }
    
    func handleEndorse(sender: UIButton) {
        
        let ref = Database.database().reference().child("endorsements").child(orgs[sender.tag])
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String: Any] {
                let value: String = dictionary["value"] as! String
                if var intValue = Int(value){
                    intValue = intValue + 1
                    ref.child("value").setValue("\(intValue)")
                }
            }
            self.handleDismiss()
            
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if error != nil {
                    print(error!)
                }
                let waitingController = WaitingController()
            
                waitingController.iniitalizeTimeStamp(uid: (user?.uid)!)
                
                self.homeController?.switchToWaitingPage()
            })
            
        }, withCancel: nil)
       
        

    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if let window = UIApplication.shared.keyWindow {
                let confirmWidth: CGFloat = window.frame.width * 0.75
                let confirmHeight: CGFloat = window.frame.height * 0.2
                let confirmX = window.frame.width / 2 - (confirmWidth / 2)
                
                self.confirmView.frame = CGRect(x: confirmX, y: window.frame.height, width: confirmWidth, height: confirmHeight)
                self.dimView.alpha = 0
            }
        }, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayConfirmView(indexPath: indexPath.item)
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
}

class EndorsementConfirm: UIView {
    
    lazy var messageTextView: UITextView = {
        let text = UITextView()
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 18)
        text.isUserInteractionEnabled = false
        return text
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews(orgName: String){
        
        messageTextView.text = "Would you like to endorse \(orgName)?"
        
        addSubview(messageTextView)
        addSubview(confirmButton)
        addSubview(cancelButton)
        
        cancelButton.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = UIColor.rgb(red: 200, green: 20, blue: 20)
        confirmButton.setImage(UIImage(named: "confirm")?.withRenderingMode(.alwaysTemplate), for: .normal)
        confirmButton.tintColor = UIColor.rgb(red: 20, green: 160, blue: 20)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
        addConstraintsWithFormat(format: "H:|[v0(\(frame.width/2))]", views: cancelButton)
        addConstraintsWithFormat(format: "V:|[v0]-0-[v1(\(frame.height * 0.4))]|", views: messageTextView, cancelButton)
        
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .top, relatedBy: .equal, toItem: messageTextView, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .left, relatedBy: .equal, toItem: cancelButton,     attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .right, relatedBy: .equal, toItem: messageTextView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: frame.height * 0.4))
   
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
