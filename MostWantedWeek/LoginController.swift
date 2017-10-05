//
//  LoginController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/21/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let registerLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 140, green: 32, blue: 31)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let nameField = UITextField()
        nameField.placeholder = "Name"
        nameField.translatesAutoresizingMaskIntoConstraints = false
        return nameField
    }()
    
    let nameSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(white: 200/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let emailTextField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.translatesAutoresizingMaskIntoConstraints = false
        return emailField
    }()
    
    let emailSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(white: 200/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let passwordTextField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    let passwordSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(white: 200/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user_profile")
        image.backgroundColor = .white
        image.layer.cornerRadius = 60
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let orgPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Login", "Register"])
        control.selectedSegmentIndex = 1
        control.tintColor = .white
        control.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let errorDisplayView: UILabel = {
        let error = UILabel()
        error.textColor = .white
        error.font = UIFont.systemFont(ofSize: 12)
        error.textAlignment = .center
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
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
    
    let profileController = ProfileController()
    
    var selectedOrg: String?
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var orgPickerViewHeightAnchor: NSLayoutConstraint?
    
    let pickerData: [String] = ["Select Organization", "Delta Gamma", "Kappa Kappa Gamma", "Delta Delta Delta", "Phi Mu", "Kappa Delta Chi", "Lambda Theta Nu", "Kappa Sigma"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        
        orgPickerView.dataSource = self
        orgPickerView.delegate = self
        
        handleEndEditing()
        
        setupReturnHomeLabelView()
        setupInputContainersView()
        setupRegisterLoginButtonView()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    func setupReturnHomeLabelView(){
        view.addSubview(returnHomeLabelView)
        returnHomeLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        returnHomeLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        returnHomeLabelView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        returnHomeLabelView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
   
    func setupLoginRegisterSegmentedControl(){
        view.addSubview(loginRegisterSegmentedControl)
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func displayErrorView(){
        
        view.addSubview(errorDisplayView)
        errorDisplayView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        errorDisplayView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 5).isActive = true
        errorDisplayView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        errorDisplayView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupInputContainersView(){
        
        view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorLine)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorLine.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorLine)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorLine.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorLine)
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        passwordSeparatorLine.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(orgPickerView)
        orgPickerView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        orgPickerView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        orgPickerView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        orgPickerViewHeightAnchor = orgPickerView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        orgPickerViewHeightAnchor?.isActive = true
    }
    
    func setupRegisterLoginButtonView(){
        view.addSubview(registerLoginButton)
        registerLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerLoginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        registerLoginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registerLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView(){
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOrg = pickerData[row]
    }
    
}
