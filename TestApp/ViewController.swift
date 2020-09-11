//
//  ViewController.swift
//  TestApp
//
//  Created by Константин Киски on 08.04.2020.
//  Copyright © 2020 Константин Киски. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DefaultTableViewCell
        
        if let url = URL(string: "https://placehold.it/375x150?text=\(indexPath.row+1)") {
            downloadImage(imageUrl: url, cell: cell)
        }
        
        return cell
    }
    
    
    func downloadImage(imageUrl: URL, cell: DefaultTableViewCell) {
        
        cell.indexImage?.image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            cell.indexImage?.image = imageFromCache
            return
        }
        
        
        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    cell.indexImage?.image = imageToCache
                    self.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
                }
            })
        }).resume()
    }
}


