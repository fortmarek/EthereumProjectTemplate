//
//  LanguageDetailTableViewController.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LanguageDetailViewController: BaseViewController {
    let viewModel: LanguageDetailViewModeling

    weak var titleLabel: UILabel!
    weak var imageView: UIImageView!
    weak var sentenceLabel: UILabel!
    weak var playButton: UIButton!
    weak var playIndicator: UIActivityIndicatorView!

    init(viewModel: LanguageDetailViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(iOS 9.0, *)
    lazy var previewActions: [UIPreviewActionItem] = { [unowned self] in
        let playAction: UIPreviewActionItem? = self.viewModel.playSentence.enabled.value ?
        UIPreviewAction(title: "Play sentence", style: .Default) { [unowned self] _, _ in
            self.viewModel.playSentence.apply(self).start()
        }: nil
        return [playAction].flatMap { $0 }
    }()

    override func loadView() {
        super.loadView()

        let titleLabel = Theme.label(size: 25)

        view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom).offset(100)
            make.centerX.equalTo(0)
        }
        self.titleLabel = titleLabel

        let imageView = UIImageView()
        view.addSubview(imageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(0)
            make.top.equalTo(titleLabel.snp_bottom).offset(15)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        self.imageView = imageView

        let sentenceLabel = Theme.label(size: 17)
        sentenceLabel.numberOfLines = 0
        sentenceLabel.textAlignment = .Center
        view.addSubview(sentenceLabel)

        sentenceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp_bottom).offset(15)
            make.leading.trailing.equalTo(0).inset(15)
        }

        self.sentenceLabel = sentenceLabel

        let playButton = UIButton()
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        playButton.titleLabel?.font = UIFont.FontStyle.Regular.font(withSize: 17)

        playButton.setTitle("► Play sentence", forState: .Normal)

        view.addSubview(playButton)
        playButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(sentenceLabel.snp_bottom).offset(50)
            make.centerX.equalTo(0)
        }

        self.playButton = playButton

        let playIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        playIndicator.hidesWhenStopped = true
        view.addSubview(playIndicator)
        playIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(playButton)
        }

        self.playIndicator = playIndicator
    }

//    var closure:(()->())?

    func setupBindings() {
        self.titleLabel.rac_text <~ viewModel.name

        viewModel.flagURL.producer.startWithNext({ [weak self] url in
            self?.imageView.sd_setImageWithURL(url)
        })

// Test leak check
//        self.closure = { _ in
//            let s = self
//            return
//        }

        self.sentenceLabel.rac_text <~ viewModel.sentence

        self.playButton.addTarget(self.viewModel.playSentence.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        self.playButton.rac_enabled <~ viewModel.playSentence.enabled
        self.playButton.rac_hidden <~ viewModel.isSpeaking
        self.playIndicator.rac_animating <~ viewModel.isSpeaking
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
