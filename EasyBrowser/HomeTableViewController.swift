//
//  HomeTableViewController.swift
//  EasyBrowser
//
//  Created by Levit Kanner on 29/04/2020.
//  Copyright © 2020 Levit Kanner. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var websites = ["apple.com" , "nikasemo.com" , "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Websites"
    }

    // MARK: - Table view data sourc

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let browser = storyboard?.instantiateViewController(withIdentifier: "browser") as? ViewController {
            browser.website = websites[indexPath.row]
            navigationController?.pushViewController(browser, animated: true)
        }
    }


}
