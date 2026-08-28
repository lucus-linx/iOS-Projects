//
//  MarkDownTestVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/7/27.
//  Copyright © 2021 LX. All rights reserved.
//

import MarkdownView
import SafariServices
import UIKit

class MarkDownTestVC: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .green
        title = "MarkDown"

        let mdView = MarkdownView()
        mdView.backgroundColor = .blue
        view.addSubview(mdView)
        mdView.snp.makeConstraints { make in
            make.top.right.left.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.4)
        }

        let path = Bundle.main.path(forResource: "sample", ofType: "md")!

        let url = URL(fileURLWithPath: path)
        let markdown = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        mdView.load(markdown: markdown, enableImage: true)
        
        
        
        //
        netMarkDown()
    }

    func netMarkDown() {
        let mdView = MarkdownView()
        mdView.backgroundColor = .blue
        view.addSubview(mdView)
        mdView.snp.makeConstraints { make in
            make.right.bottom.left.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.55)
        }

        mdView.isScrollEnabled = true

        mdView.onRendered = { height in
            print(height)
        }

        mdView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }

            if url.scheme == "file" {
                return true
            } else if url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            } else {
                return false
            }
        }

        let session = URLSession(configuration: .default)
        let url = URL(string: "https://raw.githubusercontent.com/matteocrippa/awesome-swift/master/README.md")!
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            let str = String(data: data!, encoding: String.Encoding.utf8)
            DispatchQueue.main.async {
                mdView.load(markdown: str)
            }
        }
        task.resume()
    }
}
