//
//  ViewController.swift
//  001-CustomFont
//
//  Created by 启业云03 on 2022/8/15.
//

import UIKit

// 屏幕宽度
let SCWidth = UIScreen.main.bounds.width
// 屏幕高度
let SCHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    static let identifier = "FontCell"

    var fontNames = ["MFTongXin_Noncommercial-Regular",
                     "MFJinHei_Noncommercial-Regular",
                     "MFZhiHei_Noncommercial-Regular",
                     "Zapfino",
                     "Gaspar Regular"]

    var fontRowIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor.green

        self.view.addSubview(self.fontTableView)
        self.fontTableView.frame = CGRect(x: 0, y: 80, width: SCWidth, height: SCHeight / 2)

        //
        func printAllSupportedFontNames() {
            let familyNames = UIFont.familyNames
            for familyName in familyNames {
                print("++++++ \(familyName)")
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                for fontName in fontNames {
                    print("----- \(fontName)")
                }
            }
        }
        printAllSupportedFontNames()
    }

    lazy var fontTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.identifier)
        return tableview
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        func changeFontDidTouch() {
            fontRowIndex = (fontRowIndex + 1) % 5
            print(fontNames[fontRowIndex])
            self.fontTableView.reloadData()
        }

        changeFontDidTouch()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ViewController.identifier)
        }
        cell!.textLabel?.text = "\(indexPath.row). asdf"
        cell!.textLabel?.font = UIFont(name: self.fontNames[fontRowIndex], size: 18)

        return cell!
    }
}
