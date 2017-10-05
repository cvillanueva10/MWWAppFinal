//
//  LoginControllerHandlers.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/27/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImage(){
        
    }
    
    
    func handleEndEditing(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func handleReturnHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleLoginRegister(){
        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? handleLogin() : handleRegister()
    }
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        registerLoginButton.setTitle(title, for: .normal)
        
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        //Change height of container
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 200
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        orgPickerViewHeightAnchor?.isActive = false
        orgPickerViewHeightAnchor = orgPickerView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/4)
        orgPickerViewHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.errorDisplayView.text = "Invalid password"
                self.displayErrorView()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(self.profileController, animated: true)
        }
    }
    
    func handleRegister(){
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            errorDisplayView.text = "Form is not valid"
            displayErrorView()
            return
        }
        guard let org = selectedOrg else {
            errorDisplayView.text = "Please Select an Organization"
            displayErrorView()
            return
        }
        if name == "" {
            self.errorDisplayView.text = "Please enter your name"
            self.displayErrorView()
            return
        }
        
        if email == "" {
            self.errorDisplayView.text = "Please enter a valid email"
            self.displayErrorView()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                self.errorDisplayView.text = error!.localizedDescription
                self.displayErrorView()
                print(error!)
                
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            let imageID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageID).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                        let values = ["name": name, "email": email, "organization" : org, "profileImageUrl" : profileImageURL]
                        registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    }
                    
                })
            }
        }
        
        func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]){
            let ref = Database.database().reference(fromURL: "https://mostwantedweek-e840a.firebaseio.com/")
            let usersRef = ref.child("users").child(uid)
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                print("Successfully created user in database")
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(self.profileController, animated: true)
                
            })
        }
    }
    
}
