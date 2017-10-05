//
//  PageHeaderCell.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/26/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class PageHeaderCell: BaseCell {

    var pageHeader: Page?{
        didSet{
            if let imageName = pageHeader?.headerImage {
                self.headerImage.image = UIImage(named: imageName)
            }
            self.headerLabel.text = pageHeader?.headerLabel
        }
    }
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        return image
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(headerImage)
        addSubview(headerLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerLabel)
        addConstraintsWithFormat(format: "V:|[v0(\(frame.height * 0.8))]-0-[v1(\(frame.height*0.2))]", views: headerImage, headerLabel)
    }
}

class PageBodyCell: BaseCell {
    
    var pageBody: Page? {
        didSet{
            self.descriptionTextView.text = pageBody?.descriptionText
            self.breakdownLabel.text = pageBody?.breakdownLabel
            self.breakdownTextView.text = pageBody?.breakdownText
            
            setupViews()
        }
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var breakdownHeader: UILabel = {
        let label = UILabel()
        label.text = "Breakdown"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.backgroundColor = UIColor.rgb(red: 200, green: 32, blue: 31)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let breakdownLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let breakdownView: BreakdownView = {
        let view = BreakdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        return view
    }()
    
    let descriptionTextView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = true
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        text.isEditable = false
        return text
    }()
    
    let breakdownTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = UIColor.rgb(red: 90, green: 90, blue: 90)
        return view
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.rgb(red: 70, green: 70, blue: 70)
        return line
    }()
    
    func handleBreakdown() {
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(dimView)
            window.addSubview(breakdownView)
  
            breakdownView.frame = CGRect(x: 30, y: window.frame.height, width: window.frame.width - 60, height: window.frame.height * 0.6)
            dimView.frame = window.frame
            dimView.alpha = 0
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.breakdownView.frame = CGRect(x: 30, y: window.frame.height * 0.2, width: window.frame.width - 60, height: window.frame.height * 0.6)
                self.dimView.alpha = 1
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        
        if let window = UIApplication.shared.keyWindow {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                
                self.breakdownView.frame =  CGRect(x: 30, y: window.frame.height, width: window.frame.width - 60, height: window.frame.height * 0.6)
                self.dimView.alpha = 0
            }, completion: nil)
        }
    }
    
    func checkDescriptionTextSize() -> CGFloat {
        
        if let descriptionText = descriptionTextView.text {
            
            let rect = NSString(string: descriptionText).boundingRect(with: CGSize(width: frame.width, height: 2000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)

            return rect.height + 100
        }
        
        return 500
    
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(descriptionTextView)
        addSubview(breakdownTextView)
        addSubview(descriptionLabel)
        addSubview(separatorLine)
        addSubview(breakdownLabel)
        addSubview(breakdownHeader)

        //Horizontal Constraints
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: breakdownTextView)
        addConstraintsWithFormat(format: "H:|-15-[v0]|", views: descriptionLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: breakdownHeader)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: breakdownLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        
        let descriptionTextSize = checkDescriptionTextSize()
        
        if descriptionTextSize >= 150 {
              addConstraintsWithFormat(format: "V:|-10-[v0(30)]-0-[v1(\(descriptionTextSize))]-0-[v2(1)]-0-[v3(50)]-5-[v4(30)]-0-[v5]-|", views: descriptionLabel, descriptionTextView, separatorLine,breakdownHeader, breakdownLabel, breakdownTextView)
        }
      
    }
}

class BreakdownView: UIView {
    
    let closeButton: UIView = {
        let button = UIView()
        button.backgroundColor = .yellow
//        button.setImage(UIImage(named: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        backgroundColor = .blue
        addSubview(closeButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: closeButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: closeButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

