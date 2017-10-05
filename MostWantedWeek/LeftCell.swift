//
//  LeftCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/18/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit
import Firebase

class LeftCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var scoreObjs = [Score]()
    
    override func setupViews() {
        super.setupViews()
        
        observeScore()

        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    
        collectionView.register(ScoreCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func observeScore(){
        
        let ref = Database.database().reference().child("scoreboard")
        ref.observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: Any] {
                let score = Score()
                score.setValuesForKeys(dictionary)
                
                self.scoreObjs.append(score)
                self.scoreObjs.sort(by: { (s1, s2) -> Bool in
                    (s1.score?.intValue)! > (s2.score?.intValue)!
                })
                
                for i in 0 ..< self.scoreObjs.count {
                    self.scoreObjs[i].rank = i as NSNumber
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }, withCancel: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scoreObjs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScoreCell
        cell.score = scoreObjs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
