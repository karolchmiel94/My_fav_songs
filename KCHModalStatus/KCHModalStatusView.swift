//
//  KCHModalStatusView.swift
//  KCHModalStatus
//
//  Created by Karol Ch on 13/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

public class KCHModalStatusView: UIView {
    
    @IBOutlet private weak var statusImage: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var subheadLabel: UILabel!
    
    let TIME_INTERVAL = 2.0
    let ANIMATION_DURATION = 0.15
    
    let nibName = "KCHModalStatusView"
    var contentView: UIView!
    var timer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        headlineLabel.text = ""
        subheadLabel.text = ""
    }
    
    public override func layoutSubviews() {
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }
    
    public func set(image: UIImage) {
        self.statusImage.image = image
    }
    
    public func set(title: String) {
        self.headlineLabel.text = title
    }
    
    public func set(description: String) {
        self.subheadLabel.text = description
    }
    
    public override func didMoveToSuperview() {
        self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: self.ANIMATION_DURATION, animations: {
            self.contentView.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }) { _ in
            self.timer = Timer.scheduledTimer(
                timeInterval: TimeInterval(self.TIME_INTERVAL),
                target: self,
                selector: #selector(self.removeSelf),
                userInfo: nil,
                repeats: false)
        }
        
    }
    
    @objc private func removeSelf() {
        UIView.animate(
            withDuration: self.ANIMATION_DURATION,
            animations: {
                self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.contentView.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
