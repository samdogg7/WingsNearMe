//
//  WebviewTest.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit
import WebKit

class WebviewTest: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var switchURL: UIButton!
    
    var poc: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://cam-poc.surge.sh/")
        webView.load(URLRequest(url: url!))
        switchURL.addTarget(self, action: #selector(switchUrl), for: .touchUpInside)
    }
    
    @objc func switchUrl() {
        poc = !poc
        if poc {
            let url = URL(string: "https://cam-poc.surge.sh/")
            webView.load(URLRequest(url: url!))
        } else {
            let url = URL(string: "https://pasteboard.co/")
            webView.load(URLRequest(url: url!))
        }
    }
}
