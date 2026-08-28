//
//  ControllerLifeCycle.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/1/29.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class ControllerLifeCycle: UIViewController {
    
// MARK: - ========== LifeCycle ==========
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        Log("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Log("")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Log("")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log("")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Log("")
    }
    
    override func viewWillLayoutSubviews() {
        Log("")
    }
    
    override func viewDidLayoutSubviews() {
        Log("")
    }
    
    override func viewLayoutMarginsDidChange() {
        Log("")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        Log("")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        Log("")
    }
    
    override func updateViewConstraints() {
        Log("")
    }
    
    override func loadViewIfNeeded() {
        Log("")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        Log("")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        Log("")
    }
    
    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        Log("")
    }
    
    deinit {
        Log("")
    }
    
}
