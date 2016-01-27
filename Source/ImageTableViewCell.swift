//
//  ImageSearchTableViewCell.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveCocoa
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    
    weak var previewImageView: UIImageView!
    weak var titleLabel: UILabel!
    
    internal var viewModel: ImagesTableViewCellModeling? {
        didSet {
            if let viewModel = viewModel {
                titleLabel.text = viewModel.text
                previewImageView.sd_setImageWithURL(viewModel.previewImageURL)
            }
            else {
                previewImageView.image = nil
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        let previewImageView = UIImageView()
        
        self.contentView.addSubview(previewImageView)
        
        previewImageView.snp_makeConstraints { (make) -> Void in
            make.leading.top.bottom.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.previewImageView = previewImageView
        
        let titleLabel = UILabel()
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(previewImageView.snp_trailing).offset(15)
            make.centerY.equalTo(previewImageView)
            make.trailing.equalTo(-15)
        }
        
        self.titleLabel = titleLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
