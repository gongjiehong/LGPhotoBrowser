//
//  LGAnimator.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/25.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

public protocol LGPhotoBrowserAnimatorProtocol {
    func willPresent(_ browser: LGPhotoBrowser)
    func willDismiss(_ browser: LGPhotoBrowser)
}

public class LGAnimator {
    fileprivate var targetWindow = LGApplicationWindow()
    fileprivate var resizableImageView: UIImageView?
    fileprivate var finalImageViewFrame: CGRect = CGRect.zero
    
    internal lazy var backgroundView: UIView = {
        guard let window = LGApplicationWindow() else {
            fatalError("The current Application does not have a valid window")
        }

        let backgroundView = UIView(frame: window.frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        return backgroundView
    }()
    internal var senderOriginImage: UIImage?
    internal var senderViewOriginalFrame: CGRect = CGRect.zero
    internal var senderViewForAnimation: UIView?
    
    fileprivate var animationDuration: TimeInterval {
        if LGPhotoBrowserOptions.current.contains(.enableBounceAnimation) {
            return 0.5
        }
        return 0.35
    }
    
    fileprivate var animationDamping: CGFloat {
        if LGPhotoBrowserOptions.current.contains(.enableBounceAnimation) {
            return 0.8
        }
        return 1.0
    }
    
    public init() {
        self.targetWindow?.addSubview(backgroundView)
    }
    
    deinit {
        self.backgroundView.removeFromSuperview()
    }
}

extension LGAnimator: LGPhotoBrowserAnimatorProtocol {
    public func willPresent(_ browser: LGPhotoBrowser) {
        guard let sender = browser.delegate?.viewForPhoto?(browser, index: browser.currentPageIndex) ?? senderViewForAnimation else {
            present(browser)
            return
        }
        
        let photo = browser.photoAtIndex(browser.currentPageIndex)
        let imageFromView = (senderOriginImage ?? browser.getImageFromView(sender))
        let imageRatio = imageFromView.size.width / imageFromView.size.height
        
        senderOriginImage = nil
        senderViewOriginalFrame = calcOriginFrame(sender)
        finalImageViewFrame = calcFinalFrame(imageRatio)
        resizableImageView = UIImageView(image: imageFromView)
        
        if let resizableImageView = resizableImageView {
            resizableImageView.frame = senderViewOriginalFrame
            resizableImageView.clipsToBounds = true
            resizableImageView.contentMode = photo.contentMode
            if sender.layer.cornerRadius != 0 {
                let duration = (animationDuration * Double(animationDamping))
                resizableImageView.layer.masksToBounds = true
                resizableImageView.addCornerRadiusAnimation(sender.layer.cornerRadius, to: 0, duration: duration)
            }
            targetWindow?.addSubview(resizableImageView)
        }
        
        present(browser)
    }
    
    public func willDismiss(_ browser: LGPhotoBrowser) {
        guard let sender = browser.delegate?.viewForPhoto?(browser, index: browser.currentPageIndex),
            let image = browser.photoAtIndex(browser.currentPageIndex).underlyingImage,
            let scrollView = browser.pageDisplayedAtIndex(browser.currentPageIndex) else {
                
                senderViewForAnimation?.isHidden = false
                browser.dismissPhotoBrowser(animated: false)
                return
        }
        
        senderViewForAnimation = sender
        browser.view.isHidden = true
        backgroundView.isHidden = false
        backgroundView.alpha = 1.0
        backgroundView.backgroundColor = .clear
        senderViewOriginalFrame = calcOriginFrame(sender)
        
        if let resizableImageView = resizableImageView {
            let photo = browser.photoAtIndex(browser.currentPageIndex)
            let contentOffset = scrollView.contentOffset
            let scrollFrame = scrollView.imageView.frame
            let offsetY = scrollView.center.y - (scrollView.bounds.height/2)
            let frame = CGRect(
                x: scrollFrame.origin.x - contentOffset.x,
                y: scrollFrame.origin.y + contentOffset.y + offsetY - scrollView.contentOffset.y,
                width: scrollFrame.width,
                height: scrollFrame.height)
            
            resizableImageView.image = image
            resizableImageView.frame = frame
            resizableImageView.alpha = 1.0
            resizableImageView.clipsToBounds = true
            resizableImageView.contentMode = photo.contentMode
            if let view = senderViewForAnimation, view.layer.cornerRadius != 0 {
                let duration = (animationDuration * Double(animationDamping))
                resizableImageView.layer.masksToBounds = true
                resizableImageView.addCornerRadiusAnimation(0, to: view.layer.cornerRadius, duration: duration)
            }
        }
        dismiss(browser)
    }
}

fileprivate extension LGAnimator {
    func calcOriginFrame(_ sender: UIView) -> CGRect {
        if let senderViewOriginalFrameTemp = sender.superview?.convert(sender.frame, to: nil) {
            return senderViewOriginalFrameTemp
        } else if let senderViewOriginalFrameTemp = sender.layer.superlayer?.convert(sender.frame, to: nil) {
            return senderViewOriginalFrameTemp
        } else {
            return .zero
        }
    }
    
    func calcFinalFrame(_ imageRatio: CGFloat) -> CGRect {
        guard !imageRatio.isNaN else { return .zero }
        
        if LGMesurement.screenRatio < imageRatio {
            let width = LGMesurement.screenWidth
            let height = width / imageRatio
            let yOffset = (LGMesurement.screenHeight - height) / 2
            return CGRect(x: 0, y: yOffset, width: width, height: height)
            
        } else if LGPhotoBrowserOptions.current.contains(.longPhotoWidthMatchScreen) && imageRatio <= 1.0 {
            let height = LGMesurement.screenWidth / imageRatio
            return CGRect(x: 0.0, y: 0, width: LGMesurement.screenWidth, height: height)
            
        } else {
            let height = LGMesurement.screenHeight
            let width = height * imageRatio
            let xOffset = (LGMesurement.screenWidth - width) / 2
            return CGRect(x: xOffset, y: 0, width: width, height: height)
        }
    }
}

fileprivate extension LGAnimator {
    func present(_ browser: LGPhotoBrowser, completion: (() -> Void)? = nil) {
        let finalFrame = self.finalImageViewFrame
        browser.view.isHidden = true
        browser.view.alpha = 0.0
        
        if #available(iOS 11.0, *) {
            backgroundView.accessibilityIgnoresInvertColors = true
            self.resizableImageView?.accessibilityIgnoresInvertColors = true
        }
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: animationDamping,
                       initialSpringVelocity: 0,
                       options: UIViewAnimationOptions(),
                       animations:
            {
                browser.showButtons()
                self.backgroundView.alpha = 1.0
                self.resizableImageView?.frame = finalFrame
        },
                       completion:
            { (_) -> Void in
                browser.view.alpha = 1.0
                browser.view.isHidden = false
                self.backgroundView.isHidden = true
                self.resizableImageView?.alpha = 0.0
        })
    }
    
    func dismiss(_ browser: LGPhotoBrowser, completion: (() -> Void)? = nil) {
        let finalFrame = self.senderViewOriginalFrame
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: animationDamping,
                       initialSpringVelocity: 0,
                       options: UIViewAnimationOptions(),
                       animations:
            {
                self.backgroundView.alpha = 0.0
                self.resizableImageView?.layer.frame = finalFrame
        },
                       completion:
            { (_) -> Void in
                browser.dismissPhotoBrowser(animated: true) {
                    self.resizableImageView?.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                }
        })
    }
}
