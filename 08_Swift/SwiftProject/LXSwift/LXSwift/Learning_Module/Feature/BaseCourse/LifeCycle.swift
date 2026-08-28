//
//  LifeCycle.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/7/1.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class LifeCycleViewController: UIViewController {
    // override class func initialize() {}

    override func loadView() {
        print(#function)
    }

    override func viewDidLoad() {
        print(#function)
    }

    override func viewDidLayoutSubviews() {
        print(#function)
    }

    override func viewWillLayoutSubviews() {
        print(#function)
    }

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }

    override func viewDidAppear(_ animated: Bool) {
        print(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
    }

    override func viewLayoutMarginsDidChange() {
        print(#function)
    }
}
