//
//  ViewController.swift
//  CatSwift
//
//  Created by wangyongyue on 2019/3/13.
//  Copyright © 2019 wangyongyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        let button = RButton()
        button.setTitle("button", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.frame = CGRect.init(x: 100
            , y: 280, width: 80, height: 30)
        button.v_on {
            
           self.navigationController?.pushViewController(CatVC(), animated: true)
            
        }
    }


}

