//
//  LanguageDetailTableViewController.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveSwift
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
        let playAction: UIPreviewActionItem? = self.viewModel.playSentence.isEnabled.value ?
        UIPreviewAction(title: "Play sentence", style: .default) { [unowned self] _, _ in
            self.viewModel.playSentence.apply().start()
        }: nil
        return [playAction].flatMap { $0 }
    }()

    override func loadView() {
        super.loadView()

        let titleLabel = Theme.label(size: 25)

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        self.titleLabel = titleLabel

        let imageView = UIImageView()
        view.addSubview(imageView)

        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        self.imageView = imageView

        let sentenceLabel = Theme.label(size: 17)
        sentenceLabel.numberOfLines = 0
        sentenceLabel.textAlignment = .center
        view.addSubview(sentenceLabel)

        sentenceLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(0).inset(15)
        }

        self.sentenceLabel = sentenceLabel

        let playButton = UIButton()
        playButton.setTitleColor(UIColor.black, for: UIControlState())
        playButton.setTitleColor(UIColor.lightGray, for: .disabled)
        playButton.titleLabel?.font = UIFont.FontStyle.Regular.font(withSize: 17)

        playButton.setTitle("► Play sentence", for: UIControlState())

        view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sentenceLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        self.playButton = playButton

        let playIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        playIndicator.hidesWhenStopped = true
        view.addSubview(playIndicator)
        playIndicator.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(playButton)
        }

        self.playIndicator = playIndicator
    }

//    var closure:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playButton.on(.touchUpInside) { [weak self] sender in
            self?.viewModel.playSentence.apply().start()
        }
        
        self.setupBindings()
    }
    
    func setupBindings() {
        self.titleLabel.reactive.text <~ viewModel.name

        viewModel.flagURL.producer.startWithValues({ [weak self] url in
            self?.imageView.sd_setImage(with: url)
        })

// Test leak check
//        self.closure = { _ in
//            let s = self
//            return
//        }

        self.sentenceLabel.reactive.text <~ viewModel.sentence

        self.playButton.reactive.isEnabled <~ viewModel.playSentence.isEnabled
        self.playButton.reactive.isHidden <~ viewModel.isSpeaking
        self.playIndicator.reactive.isAnimating <~ viewModel.isSpeaking
    }

    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
