//
//  SettingsController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/9/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class MenuController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    lazy var dimView: UIView = {
        let view = UIView()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let logo = UIImageView()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        logo.addGestureRecognizer(swipeLeft)
        logo.isUserInteractionEnabled = true
        logo.image = UIImage(named: "MH")
        logo.backgroundColor = UIColor.red
        return logo
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        cv.addGestureRecognizer(swipeLeft)
        cv.backgroundColor = UIColor.white
        return cv
    }()
  
    var menuTabObjs: [MenuTab] = {
        var aboutTab = MenuTab(logoName: "about", labelName: "About MWW", imageName: "mww_group")
        var moneyTab = MenuTab(logoName: "money", labelName: "Penny Wars", imageName: "jugs")
        var tieTab = MenuTab(logoName: "tiegame", labelName: "Charm-A-Sig", imageName: "charm")
        var scTab = MenuTab(logoName: "star", labelName: "Star & Crescent", imageName: "sc")
        var brosTab = MenuTab(logoName: "bros", labelName: "Meet the Bros", imageName: "brothers")
        var endorseTab = MenuTab(logoName: "endorse", labelName: "Endorsements", imageName: "")
        var adminTab = MenuTab(logoName: "user_profile", labelName: "Admin Only", imageName: "")
        var fillerTab = MenuTab(logoName: "", labelName: "", imageName: "")
        
        return [aboutTab, brosTab, moneyTab, tieTab, scTab, adminTab, fillerTab]
    }()
    
    var homeController: HomeController?
    
    func showSettings(){
        
        if let window = UIApplication.shared.keyWindow{
            dimView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            dimView.alpha = 0
            
            window.addSubview(dimView)
            window.addSubview(backgroundView)
            window.addSubview(collectionView)
            window.addSubview(logoView)
            
            let width = window.frame.width * 0.7
            let logoHeight = window.frame.height * 0.33
            
            collectionView.frame = CGRect(x: -1 * width, y: logoHeight + 15, width: width, height: window.frame.height - logoHeight - 15)
            logoView.frame = CGRect(x: -1 * width, y: 15, width: width, height: logoHeight)
            backgroundView.frame = CGRect(x: -1 * width, y: 0, width: width, height: window.frame.height)
            dimView.frame = window.frame
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: logoHeight + 15 + 10, width: width, height: window.frame.height - logoHeight - 15 - 10)
                self.logoView.frame = CGRect(x: 0, y: 15, width: width, height: logoHeight)
                self.backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss(gesture: UISwipeGestureRecognizer){
        
        if let window = UIApplication.shared.keyWindow{
            let width = window.frame.width * 0.7
            let logoHeight = window.frame.height * 0.3
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 0
                self.collectionView.frame = CGRect(x: -1 * width, y: logoHeight + 15 + 10, width: width, height: window.frame.height - logoHeight - 15 - 10)
                self.logoView.frame = CGRect(x: -1 * width, y: 15, width: width, height: logoHeight)
                self.backgroundView.frame = CGRect(x: -1 * width, y: 0, width: width, height: window.frame.height)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTabObjs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SideMenuCells
        
        cell.menuTab = menuTabObjs[indexPath.item]
        if cell.menuTab?.tabLabelName == "" {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let window = UIApplication.shared.keyWindow{
            return CGSize(width: window.frame.width * 0.7 , height: window.frame.height * 0.106)
        }
        return CGSize(width: 200, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        if let window = UIApplication.shared.keyWindow{
            let width = window.frame.width * 0.7
            let logoHeight = window.frame.height * 0.3
            self.dimView.alpha = 0
            self.collectionView.frame = CGRect(x: -1 * width, y: logoHeight + 15 + 10, width: width, height: window.frame.height - logoHeight - 15 - 10)
            self.logoView.frame = CGRect(x: -1 * width, y: 15, width: width, height: logoHeight)
            self.backgroundView.frame = CGRect(x: -1 * width, y: 0, width: width, height: window.frame.height)
        }
        
    }){(completion: Bool) in
        let menutab = self.menuTabObjs[indexPath.item]
        self.homeController?.showControllerForMenuTab(menutab: menutab)
        }
    }
    
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SideMenuCells.self, forCellWithReuseIdentifier: cellId)
    }
}
