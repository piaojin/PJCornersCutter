//
//  TestViewController.swift
//  CornersCutter
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let frameButton = UIButton(frame: CGRect(x: 50.0, y: 100.0, width: 200.0, height: 200.0))
        frameButton.setTitle("testFrame", for: .normal)
        frameButton.backgroundColor = .blue
        self.view.addSubview(frameButton)
        
        let autolayoutButton = UIButton()
        autolayoutButton.setTitle("testAutoLayout", for: .normal)
        autolayoutButton.backgroundColor = .orange
        self.view.addSubview(autolayoutButton)
        
        autolayoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(frameButton.snp.bottom).offset(30.0)
            make.size.equalTo(frameButton.frame.size)
            make.left.equalTo(frameButton)
        }
        
        frameButton.pj_addCorner(radius: 50.0, direction: .allCorners)
        autolayoutButton.pj_addCorner()
        
        frameButton.addTarget(self, action: #selector(click1), for: .touchUpInside)
        autolayoutButton.addTarget(self, action: #selector(click2), for: .touchUpInside)
        
        let frameImageView = UIImageView(frame: CGRect(x: 50.0, y: 560.0, width: 100.0, height: 100.0))
        frameImageView.backgroundColor = .orange
        self.view.addSubview(frameImageView)
        
        frameImageView.pj_drawCornerImageView()
        
        DispatchQueue.main.async {
            frameImageView.image = UIImage(named: "test3")
        }
        
        let autoLayoutImageView = UIImageView()
        autoLayoutImageView.translatesAutoresizingMaskIntoConstraints = false
        autoLayoutImageView.backgroundColor = .orange
        autoLayoutImageView.image = UIImage(named: "test")
        self.view.addSubview(autoLayoutImageView)
        
        autoLayoutImageView.snp.makeConstraints { (make) in
            make.left.equalTo(frameImageView.snp.right).offset(15.0)
            make.size.equalTo(CGSize(width: 100.0, height: 100.0))
            make.top.equalTo(frameImageView)
            //            make.left.equalTo(self.view).offset(50.0)
            //            make.right.equalTo(self.view).offset(-50.0)
            //            make.height.equalTo(100.0)
        }
        
        //        autoLayoutImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15.0).isActive = true
        //        autoLayoutImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        //        autoLayoutImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        //        autoLayoutImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80.0).isActive = true
        
        autoLayoutImageView.pj_drawCornerImageView()
        
        DispatchQueue.main.async {
            autoLayoutImageView.image = UIImage(named: "test3")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func click1() {
        print("frameButton")
    }
    
    @objc func click2() {
        print("autolayoutButton")
    }
}
