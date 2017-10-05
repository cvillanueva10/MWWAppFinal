//
//  AdminLoginController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 8/27/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class AdminLoginController: UIViewController {
    
    let adminHeader: UILabel = {
        let header = UILabel()
        header.text = "Granted Admin Only"
        header.textColor = .white
        header.textAlignment = .center
        header.font = UIFont.boldSystemFont(ofSize: 26)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    let passwordContaionerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 140, green: 32, blue: 31)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let passwordTextField: UITextField = {
        let passwordField = UITextField()
        passwordField.text = ""
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.isSecureTextEntry = true
        return passwordField
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
    
    let errorDisplayView: UILabel = {
        let error = UILabel()
        error.textColor = .white
        error.font = UIFont.systemFont(ofSize: 16)
        error.textAlignment = .center
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()
    
    var homeController: HomeController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        
        setupLoginButton()
        setupPasswordContainerView()
        setupPasswordTextField()
        setupReturnHomeLabelView()
        setupAdminHeader()
    }
    
    func setupAdminHeader(){
        view.addSubview(adminHeader)
        adminHeader.bottomAnchor.constraint(equalTo: passwordContaionerView.topAnchor, constant: -15).isActive = true
        adminHeader.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        adminHeader.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        adminHeader.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupLoginButton(){
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupPasswordContainerView(){
        view.addSubview(passwordContaionerView)
        passwordContaionerView.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
        passwordContaionerView.leftAnchor.constraint(equalTo: loginButton.leftAnchor).isActive = true
        passwordContaionerView.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        passwordContaionerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func setupPasswordTextField(){
        view.addSubview(passwordTextField)
        passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: loginButton.leftAnchor, constant: 5).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    func setupReturnHomeLabelView(){
        view.addSubview(returnHomeLabelView)
        returnHomeLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        returnHomeLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        returnHomeLabelView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        returnHomeLabelView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func displayErrorView(){
        view.addSubview(errorDisplayView)
        errorDisplayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorDisplayView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5).isActive = true
        errorDisplayView.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        errorDisplayView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    let adminAccessController = AdminAccessController()
    
    func handleReturnHome(){
        passwordTextField.text = ""
        errorDisplayView.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleLogin() {
        
        guard let passwordText = passwordTextField.text else {
            return
        }
        
        Database.database().reference().child("admin").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if passwordText == dictionary["password"] as? String {
                    self.passwordTextField.text = ""
                    self.dismiss(animated: true, completion: nil)
                    self.homeController?.showAdminPage()
                    
                } else {
                    self.errorDisplayView.text = "Invalid password"
                    self.displayErrorView()
                    return
                }
                
            }
        }, withCancel: nil)
    }
}
