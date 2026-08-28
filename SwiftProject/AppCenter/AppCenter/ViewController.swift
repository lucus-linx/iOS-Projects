//
//  ViewController.swift
//  AppCenter
//
//  Created by linxiang on 2023/5/13.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    @IBAction func btnClick(_ sender: Any) {
        let a = AppCenterVC()
        self.navigationController?.pushViewController(a, animated: true)
    }
}
