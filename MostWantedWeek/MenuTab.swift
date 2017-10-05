//
//  MenuTab.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/10/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

class MenuTab: NSObject {

    var tabLogoName: String
    var tabLabelName: String
    var tabImageName: String
    var tabLabelFont = UIFont.boldSystemFont(ofSize: 18)
    
    init(logoName: String, labelName: String, imageName: String) {
        self.tabLogoName = logoName
        self.tabLabelName = labelName
        self.tabImageName = imageName
    }
}
