//
//  Singleton.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/2.
//  Copyright © 2021 LX. All rights reserved.
//
//  Demo: https://refactoringguru.cn/design-patterns/singleton/swift/example#example-0


import Foundation

class Singleton {
    
    static var shared: Singleton = {
        let instance = Singleton()
        return instance
    }()
    
    init() {
        
    }
    
    func showLogic() -> String {
        return "Just Show!!!"
    }
}

/// Singletons should not be cloneable.
extension Singleton: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}




