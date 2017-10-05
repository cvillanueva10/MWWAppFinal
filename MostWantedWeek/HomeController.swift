//
//  ViewController.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/3/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let centerCellId = "centerCellId"
    let leftCellId = "leftCellId"
    let rightCellId = "rightCellId"
    
    lazy var lowerMenuBar: LowerMenuBar = {
        let menu = LowerMenuBar()
        menu.homeController = self
        return menu
    }()
    
    lazy var menuController: MenuController = {
        let controller = MenuController()
        controller.homeController = self
        return controller
    }()
    
    let menuButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        iv.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageView()
        loadPageView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPageView()
        
        let initialIndex = IndexPath(item: 1, section: 0) as IndexPath
        lowerMenuBar.collectionView.selectItem(at: initialIndex, animated: false, scrollPosition: [])
        collectionView?.scrollToItem(at: initialIndex, at: .centeredHorizontally, animated: false)
        
    }
    
    func setupPageView() {
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let pageTitle = UILabel(frame: CGRect(x:0,y:0,width:100,height:100))
        pageTitle.text = "MWW"
        pageTitle.textAlignment = .center
        pageTitle.font = UIFont.boldSystemFont(ofSize: 24)
        pageTitle.textColor = UIColor.white
        navigationItem.titleView = pageTitle
    }
    
    func loadPageView(){
        
        setupCollectionView()
        setupMenuButton()
        setupLowerMenuBar()
    }
    
    func setupCollectionView(){
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }

        collectionView?.backgroundColor = .white
        collectionView?.register(RightCell.self, forCellWithReuseIdentifier: rightCellId)
        collectionView?.register(CenterCell.self, forCellWithReuseIdentifier: centerCellId)
        collectionView?.register(LeftCell.self, forCellWithReuseIdentifier: leftCellId)
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.isPagingEnabled = true
        
        lowerMenuBar.horizontalBarLeftAnchorConstrait?.constant = view.frame.width / 3
    }

    func setupMenuButton() {
        
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(named:  "menu"), for: .normal)
        leftButton.addTarget(self, action:#selector(handleMenu), for: .touchUpInside)
        leftButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        leftButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
//        let rightButton = UIButton(type: .custom)
//        rightButton.setImage(UIImage(named: "endorse"), for: .normal)
//        rightButton.addTarget(self, action: #selector(handlePresentEndorsementController), for: .touchUpInside)
//        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        let rightBarButton = UIBarButtonItem(customView: rightButton)
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupLowerMenuBar(){
        view.addSubview(lowerMenuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|",views: lowerMenuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]|",views: lowerMenuBar)
    }
    
    func handleMenu(){
        menuController.showSettings()
    }
    
    // Load other controller from side menu
    let adminLoginController = AdminLoginController()
    let endorsementController = EndorsementController()
    let waitingController = WaitingController()
    
    func showControllerForMenuTab(menutab: MenuTab){
        let layout = UICollectionViewFlowLayout()
        let pageController = PageController(collectionViewLayout: layout)
        let biographyController = BiographyController(collectionViewLayout: layout)
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.tintColor = .white
        
        if(menutab.tabLabelName == "About MWW" || menutab.tabLabelName == "Penny Wars" || menutab.tabLabelName == "Charm-A-Sig" || menutab.tabLabelName == "Star & Crescent"){
            pageController.navigationItem.title = menutab.tabLabelName
            pageController.tab = menutab
            navigationController?.pushViewController(pageController, animated: true)
        }
        else if (menutab.tabLabelName == "Admin Only"){
           adminLoginController.homeController = self
           present(adminLoginController, animated: true, completion: nil)
        }
        else if (menutab.tabLabelName == "Meet the Bros"){
            biographyController.navigationItem.title = menutab.tabLabelName
            biographyController.tab = menutab
            navigationController?.pushViewController(biographyController, animated: true)
        }
        else if (menutab.tabLabelName == "Endorsements") {
            handlePresentEndorsementController()
        }
    }
    
    func handlePresentEndorsementController() {
        
        let navigationTitle = "Endorsements"
        
        if Auth.auth().currentUser?.uid == nil {
            endorsementController.homeController = self
            present(endorsementController, animated: true, completion: nil)
        }
        else {
            waitingController.navigationItem.title = navigationTitle
            waitingController.homeController = self
            navigationController?.pushViewController(waitingController, animated: true)
        }
    }
    
    //Called from WaitingController
    func switchToEndorsementPage() {
        navigationController?.popViewController(animated: true)
        present(endorsementController, animated: true, completion: nil)
    }
    
    //Called from EndorsementController
    func switchToWaitingPage() {
        waitingController.navigationItem.title = "Endorsements"
        dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(waitingController, animated: true)
    }
    
    func showAdminPage(){
        let layout = UICollectionViewFlowLayout()
        let adminAccessController = AdminAccessController(collectionViewLayout: layout)
        adminAccessController.navigationItem.title = "Admin"
        navigationController?.pushViewController(adminAccessController, animated: true)
    }
    
    func scrollToSectionIndex(sectionIndex: Int){
        let indexPath = IndexPath(item: sectionIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        lowerMenuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lowerMenuBar.horizontalBarLeftAnchorConstrait?.constant = scrollView.contentOffset.x / 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        if indexPath.item == 0 {
            identifier = leftCellId
        }
        else if indexPath.item == 2 {
            identifier = rightCellId
        }
        else{
            identifier = centerCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
}

