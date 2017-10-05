//
//  ApiService.swift
//  MostWantedWeek
//
//  Created by Christopher Villanueva on 7/23/17.
//  Copyright © 2017 Christopher Villanueva. All rights reserved.
//

import UIKit

let descriptionCache = NSCache<AnyObject, AnyObject>()

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchDescriptions(tabName: String, url: String, completion: @escaping ([Page]) -> ()){
        let url = URL(string: url)
        
        if let cachedJson = descriptionCache.object(forKey: url as AnyObject){
            let descriptionObjs = self.assignDescriptionsUsingJson(tabName: tabName, json: cachedJson)
            
            DispatchQueue.main.async(execute: {
                completion(descriptionObjs)
            })
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            do{
                let downloadedJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let descriptionObjs = self.assignDescriptionsUsingJson(tabName: tabName, json: downloadedJson)
                descriptionCache.setObject(downloadedJson as AnyObject, forKey: url as AnyObject)
                
                DispatchQueue.main.async(execute: {
                    completion(descriptionObjs)
                })
            } catch let jsonError{
                print(jsonError)
            }
            }.resume()
    }
    
    func assignDescriptionsUsingJson(tabName: String, json: Any) -> [Page]{
        var pageObjs = [Page]()
        
        for dictionary in json as! [[String: AnyObject]] {
            let name = tabName
            let subdictionary = dictionary[name]
            let pageobj = Page()
            pageobj.descriptionText = subdictionary?["description"] as? String
            pageobj.headerImage = subdictionary?["headerimage"] as? String
            pageobj.headerLabel = subdictionary?["headerlabel"] as? String
            pageobj.breakdownLabel = subdictionary?["breakdownlabel"] as? String
            pageobj.breakdownText = subdictionary?["breakdowntext"] as? String
            pageObjs.append(pageobj)
        }
        return pageObjs
    }
}
