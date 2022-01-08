//
//  StatsViewController.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit
import WebKit

class StatsViewController: UIViewController {
    
    let webLink = "https://www.playerprofiler.com"
    let navTitle = "Player Profiler"
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var statsTabItem: UITabBarItem!
    
    // load playerprofiler.com
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let myURL = URL(string: webLink)!
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
        navigationItem.title = navTitle
    }

}
