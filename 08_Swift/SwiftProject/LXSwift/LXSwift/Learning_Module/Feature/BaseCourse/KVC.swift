//
//  KVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/7/5.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class KVCTestClass: NSObject {
    @objc var name: String = "林"
    var age: Int = 99
}

class KVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let kvc = KVCTestClass()
        print("赋值前边:\(kvc.name)")
        kvc.name = "lionsom"
        print("赋值后:\(kvc.name)")
        
        print("赋值前边:\(kvc.name)")
        kvc.setValue("我很好", forKey: "name")
        print("赋值后:\(kvc.name)")
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
