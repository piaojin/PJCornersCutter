//
//  TestCellTableViewCell.swift
//  CornersCutter
//
//  Created by Zoey Weng on 2018/1/14.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit
import Kingfisher

class TestCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var frameLabel: UILabel!
    
    @IBOutlet weak var autoLayoutImageView: UIImageView!
    
    var frameImageView: UIImageView!
    
    var testModel: TestModel? {
        didSet{
            if let testModel = testModel {
                autoLayoutImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: testModel.imageUrl)!), placeholder: Image(named: "test"), options: [.forceRefresh], progressBlock: nil, completionHandler: nil)
                frameImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: testModel.imageUrl)!), placeholder: Image(named: "test"), options: [.forceRefresh], progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        autoLayoutImageView.pj_addCorner(radius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        frameImageView = UIImageView()
        frameImageView.backgroundColor = .orange
        frameImageView.image = UIImage(named: "test")
        self.contentView.addSubview(frameImageView)
    }
    
    //刻意在布局时修改frame
    override func layoutSubviews() {
        super.layoutSubviews()
        frameImageView.frame = CGRect(x: frameLabel.frame.maxX + 15.0, y: self.autoLayoutImageView.frame.origin.y, width: self.autoLayoutImageView.frame.size.width, height: self.autoLayoutImageView.frame.size.height)
        frameImageView.pj_addCorner(radius: self.autoLayoutImageView.frame.size.height / 2.0)
    }
}
