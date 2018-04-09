//
//  ViewController.swift
//  CornersCutter
//
//  Created by Zoey Weng on 2018/1/11.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "切割圆角"
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("viewController", for: .normal)
        button1.backgroundColor = .orange
        button1.setTitleColor(.white, for: .normal)
        self.view.addSubview(button1)
        button1.sizeToFit()
        button1.widthAnchor.constraint(equalToConstant: button1.bounds.size.width).isActive = true
        button1.heightAnchor.constraint(equalToConstant: button1.bounds.size.height).isActive = true
        button1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        button1.addTarget(self, action: #selector(button1Click), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("TestTableViewController", for: .normal)
        button2.backgroundColor = .orange
        button2.setTitleColor(.white, for: .normal)
        self.view.addSubview(button2)
        button2.sizeToFit()
        button2.widthAnchor.constraint(equalToConstant: button2.bounds.size.width).isActive = true
        button2.heightAnchor.constraint(equalToConstant: button2.bounds.size.height).isActive = true
        button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 16.0).isActive = true
        button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        button2.addTarget(self, action: #selector(button2Click), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func button1Click() {
        let testViewController = TestViewController()
        self.navigationController?.pushViewController(testViewController, animated: true)
    }
    
    @objc func button2Click() {
        let testTableViewController = TestTableViewController()
        self.navigationController?.pushViewController(testTableViewController, animated: true)
    }
}
