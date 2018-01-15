//
//  DetailViewController.swift
//  ChampProject
//
//  Created by Chaithat Sukra on 14/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

    public var selectedItem: ItemModel!
    
    @IBOutlet weak var vWeb: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vWeb.delegate = self
        self.vWeb.loadRequest(URLRequest(url: URL(string: selectedItem.url)!))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.vWeb.frame.size.height = 1
        self.vWeb.frame.size = webView.sizeThatFits(.zero)
    }
}
