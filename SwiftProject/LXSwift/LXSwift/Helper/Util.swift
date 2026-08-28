//
//  Util.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/5.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

func OpenURL(urlString: String) {
    if let url = URL(string:urlString),
       UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

func convertJSONStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
        } catch let error as NSError {
             print(error)
        }
    }
    return nil
}


// MARK: - ========== UI ==========



