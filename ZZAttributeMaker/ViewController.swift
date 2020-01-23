//
//  ViewController.swift
//  ZZAttributeMaker
//
//  Created by William on 2020/1/23.
//  Copyright © 2020 Wonders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        one.attributedText = "Hello world 567".styled.prepend(icon: UIImage(named: "icon_baby")!).make {
            $0.range().fontSize(12)
            // 查找Hello
            $0.find(.text("Hello"))?.color(.blue).font(UIFont.systemFont(ofSize: 14))
            // 查找数字
            $0.find(.number)?.color(.red)
        }

        let text = """
        I used to love correcting people’s grammar until \

        I realized what I loved more was having friends.
        -corfff
        """
        two.attributedText = text.styled.make {
            // 设置段间距、行间距
            $0.range().paragraphSpacing(10).lineSpacing(4)
            // 正则匹配文本
            $0.findAll(.regex("cor\\w*\\b"))?.color(.red)
        }
    }


}

