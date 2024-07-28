//
//  ArticleViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    enum URLError: Error {
        case invalidURL
    }
    
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
}

extension ArticleViewController {
    private func loadURL() throws {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            throw URLError.invalidURL
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension ArticleViewController: WKUIDelegate, WKNavigationDelegate {
    
}
