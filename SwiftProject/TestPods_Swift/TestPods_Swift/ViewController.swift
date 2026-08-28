//
//  ViewController.swift
//  TestPods_Swift
//
//  Created by 启业云03 on 2021/3/23.
//

import UIKit

import OnlyOCDemo

import OnlySwiftDemo

import OCAddSwiftDemo

import SwiftAddOCDemo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 纯OC组件
        FunctionA.printSomethingA("你大爷！")
        FunctionB.printSomethingB("我二爷！")
        
        // 纯Swift组件
        OnlySwiftDemo.SwiftLibC().show()
        
        
        // OC组件包含Swift
        // OC组件中的OC方法
        FunctionD_OC.printSomething("123")
        FunctionD_OC.useSwiftPod()
        FunctionD_OC.useSwiftSource()
        
        // OC组件中Swift源码
        SwiftLibD().show("456")
        SwiftLibD().show_SwiftPod("789")
        SwiftLibD().show_OC_Source("10")
        
        
        // Swift组件包含OC
        FunctionF_OC.printSomethingF("777")
        
        SwiftLibE().show("1")
        SwiftLibE().show_OC_Source("2")
        SwiftLibE().show_OC_Source("3")
    }

}

