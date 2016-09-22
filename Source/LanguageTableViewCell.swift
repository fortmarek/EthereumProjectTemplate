//
//  LanguageTableViewCell.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/22/15.
//  Copyright © 2015 Ackee s. r. o. All rights reserved.
//

import ReactiveCocoa
import SDWebImage


class LanguageTableViewCell: UITableViewCell {

    weak var flagImageView: UIImageView!
    weak var nameLabel: UILabel!

    let viewModel = MutableProperty<LanguageDetailViewModeling?>(nil)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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
        
        setupBindings()
    }
    
    func setupBindings() {
        let vm = viewModel.producer.ignoreNil()
        
        nameLabel.rac_text <~ vm.flatMap(.Latest) { $0.name.producer } 
        
        vm.flatMap(.Latest) { $0.flagURL.producer }
            .startWithNext({[weak self] url in
            self?.flagImageView.sd_setImageWithURL(url)
            })
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
