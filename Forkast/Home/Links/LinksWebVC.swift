//
//  LinksWebVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/12/21.
//

import UIKit
import WebKit

class LinksWebVC: UIViewController,WKNavigationDelegate{
    var webLinkUrlString = String()
    var navBarTitleString = String()
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var navBarTextLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        navBarTextLbl.text = navBarTitleString
        // Do any additional setup after loading the view.
        if let url = URL(string: webLinkUrlString) {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //------------------------------------------------------
              
    //MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
//        webView.scrollView.isScrollEnabled=false;
//        webViewHeightConstraint.constant = webView.scrollView.contentSize.height
//        webView.scrollView.minimumZoomScale = 0.1;
//        webView.scrollView.maximumZoomScale = 0.9;
//        webView.scrollView.setZoomScale(0.39, animated: true)
        
    
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(scriptContent, completionHandler: nil)
    }
 

}
