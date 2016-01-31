//
//  ImageSearchTableViewCell.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveCocoa
import SDWebImage

class LanguageTableViewCell: UITableViewCell {
    
    weak var flagImageView: UIImageView!
    weak var nameLabel: UILabel!
    
    internal var viewModel: LanguageDetailViewModeling? {
        didSet {
            if let viewModel = viewModel {
                nameLabel.rac_text <~ viewModel.name
                
                viewModel.flagURL.producer.startWithNext({[weak self] url in
                    self?.flagImageView.sd_setImageWithURL(url)
                })
            }
            else {
                flagImageView.image = nil
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        let flagImageView = UIImageView()
        
        self.contentView.addSubview(flagImageView)
        
        flagImageView.snp_makeConstraints { (make) -> Void in
            make.leading.top.bottom.equalTo(flagImageView.superview!).inset(12)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        self.flagImageView = flagImageView
        
        let nameLabel = UILabel()
        
        self.contentView.addSubview(nameLabel)
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(flagImageView.snp_trailing).offset(12)
            make.centerY.equalTo(flagImageView)
            make.trailing.equalTo(-15)
        }
        
        self.nameLabel = nameLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
