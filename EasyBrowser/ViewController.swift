//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Levit Kanner on 28/04/2020.
//  Copyright © 2020 Levit Kanner. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com" , "nikasemo.com" , "hackingwithswift.com"]
    var website: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://" + website)!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)    ///Observes for change in web view progress
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //Items in the tool bar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let backward = UIBarButtonItem(title: "back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton , spacer , backward , spacer, forward ,spacer, refresh]
        navigationController?.isToolbarHidden = false
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    
    @objc func openTapped() {
        let controller = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        //Creates Actions in a loop
        for website in websites {
            controller.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        controller.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(controller, animated: true, completion: nil)
    }
    
    
    func openPage(_ handler: UIAlertAction) {
        let url = URL(string: "https://" + handler.title!)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        configureAlert()
        decisionHandler(.cancel)
    }
    
    
    func configureAlert() {
        let message = "Blocked"
        let title = "Unsecure site"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

