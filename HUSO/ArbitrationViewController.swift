//
//  ArbitrationViewController.swift
//  HUSO
//
//  Created by Asher Noel on 8/4/19.
//  Copyright © 2019 Asher Noel. All rights reserved.
//

import UIKit
import WebKit

class ArbitrationViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let pdfFilePath = Bundle.main.url(forResource: "arbitration", withExtension: "pdf")
        let urlRequest = URLRequest.init(url: pdfFilePath!)
        let webView = WKWebView(frame: self.view.frame)
        webView.load(urlRequest)
        self.view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
}
