//
//  AlamofireUsage.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/3/12.
//  Copyright © 2021 LX. All rights reserved.
//

import Foundation
import Alamofire

func makeRequest() {
    // eg1: simplest
    AF.request("https://www.baidu.com/").response { response in
        Log(response)
        
        Log(response.request?.method)
    }
    
    // eg2: method
    let dataRequest = AF.request("https://www.baidu.com/", method: .get)
    Log(dataRequest.response)
    Log(dataRequest.request)
    Log(dataRequest.request?.method)
    
    // eg3: 创建请求时，可以使用RequestModifier闭包来修改从传递的值创建的URLRequest。
    AF.request("https://www.baidu.com/get", requestModifier: { $0.timeoutInterval = 5 }).response { response in
        //....
    }
    // eg3: RequestModifiers也可以使用尾随闭包语法。
    AF.request("https://www.baidu.com/get") { urlRequest in
        urlRequest.timeoutInterval = 5
        if #available(iOS 13.0, *) {
            urlRequest.allowsConstrainedNetworkAccess = false
        } else {
            // Fallback on earlier versions
        }
    }
    .response { response in
        //....
    }
    
    // eg4:
    struct User: Encodable {
        let username: String
        let password: String
    }
    let user = User(username: "linx", password: "123456")
    AF.request("https://www.baidu.com/get",
               method: .get,
               parameters: user,
               encoder: JSONParameterEncoder.default)
        .response { response in
            
        }

    let parameters = ["foo": "bar"]
    AF.request("https://httpbin.org/get", parameters: parameters) // encoding defaults to `URLEncoding.default`
        .response { response in
            Log(response.request?.url)
            Log(response.request?.httpBody)
        }
    AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
        .response { response in
            Log(response.request?.url)
        }
    AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .methodDependent))
        .response { response in
            Log(response.request?.url)
        }

    let parameters1: [String: [String]] = [
        "foo": ["bar"],
        "baz": ["a", "b"],
        "qux": ["x", "y", "z"]
    ]
    // All three of these calls are equivalent
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1)
        .response { response in
            Log(response.request?.url)
            Log(response.request?.httpBody)
        }
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1, encoder: URLEncodedFormParameterEncoder.default)
        .response { response in
            Log(response.request?.url)
            Log(response.request?.httpBody)
        }
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1, encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
        .response { response in
            Log(response.request?.url)
            Log(response.request?.httpBody)
            if let body = response.request?.httpBody {
                let string = String(data: body, encoding: String.Encoding.utf8)
                Log(string)
            }

        }
    // 参数编码顺序
    let myEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(alphabetizeKeyValuePairs: false))
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1, encoder: myEncoder).response { response in
        if let body = response.request?.httpBody {
            let string = String(data: body, encoding: String.Encoding.utf8)
            Log(string)
            // baz%5B%5D=a&baz%5B%5D=b&qux%5B%5D=x&qux%5B%5D=y&qux%5B%5D=z&foo%5B%5D=bar
        }
    }
    // 配置 Array 参数的编码
    let myEncoder1 = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1, encoder: myEncoder1).response { response in
        if let body = response.request?.httpBody {
            let string = String(data: body, encoding: String.Encoding.utf8)
            Log(string)
            // baz=a&baz=b&foo=bar&qux=x&qux=y&qux=z
        }
    }
    //
    let parameters2: [String: [Bool]] = [
        "BBBB": [true, false]
    ]
    
    let myEncoder2 = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .numeric))
    AF.request("https://httpbin.org/post", method: .post, parameters: parameters1, encoder: myEncoder2).response { response in
        if let body = response.request?.httpBody {
            let string = String(data: body, encoding: String.Encoding.utf8)
            Log(string)
            // baz=a&baz=b&foo=bar&qux=x&qux=y&qux=z
        }
    }
    
    // cURL 的命令输出
    AF.request("https://httpbin.org/get")
        .cURLDescription { description in
            print(description)
        }
        .responseJSON { response in
            debugPrint(response.metrics!)
        }
}






extension HTTPMethod {
    static let lx_custom = HTTPMethod(rawValue: "lx_custom")
}
