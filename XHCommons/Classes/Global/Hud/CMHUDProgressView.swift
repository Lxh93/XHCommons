//
//  CMHUDProgressView.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//

import UIKit
import PKHUD
import QuartzCore

// 把PKHUDSquareBaseView代码拷过来 改一改样式
open class CMHUDProgressView: UIView, PKHUDAnimating {
    
    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 80))

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: CMHUDProgressView.defaultSquareBaseViewFrame)
        
        backgroundColor = UIColor(hexString: "#000000", alpha: 0.85)!
        self.imageView.image = image ?? UIImage(named:"ic_progress")
        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.85
//        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.black.withAlphaComponent(0.85)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    open override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = PKHUD.sharedHUD.leadingMargin + PKHUD.sharedHUD.trailingMargin
        let originX: CGFloat = margin > 0 ? margin : 0.0
        let viewWidth = bounds.size.width - 2 * margin
        let viewHeight = bounds.size.height

        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        let quarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0)))
        let threeQuarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0 * 3.0)))

        titleLabel.frame = CGRect(origin: CGPoint(x: originX, y: 0.0), size: CGSize(width: viewWidth, height: quarterHeight))
        imageView.frame = CGRect(origin: CGPoint(x: originX, y: quarterHeight), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x: originX, y: threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))

    }
    
    public func startAnimation() {
        let anima = PKHUDAnimation.discreteRotation
        if let anima = anima as? CAKeyframeAnimation {
            anima.isRemovedOnCompletion = false
            imageView.layer.add(anima, forKey: "progressAnimationCAKeyframeAnimation")
        }
    }

    public func stopAnimation() {
//        JKPrint("动画停止了")
    }
}

