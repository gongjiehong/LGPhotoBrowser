//
//  LGActionView.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/25.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

class LGActionView: UIView {
    internal weak var browser: LGPhotoBrowser?
    internal var closeButton: LGCloseButton!
    internal var deleteButton: LGDeleteButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: LGPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        
        configureCloseButton()
        configureDeleteButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if closeButton.frame.contains(point) || deleteButton.frame.contains(point) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
        self.setNeedsDisplay()
    }
    
    func updateCloseButton(image: UIImage, size: CGSize? = nil) {
        configureCloseButton(image: image, size: size)
    }
    
    func updateDeleteButton(image: UIImage, size: CGSize? = nil) {
        configureDeleteButton(image: image, size: size)
    }
    
    func animate(hidden: Bool) {
        let closeFrame: CGRect = hidden ? closeButton.hideFrame : closeButton.showFrame
        let deleteFrame: CGRect = hidden ? deleteButton.hideFrame : deleteButton.showFrame
        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in
                        let alpha: CGFloat = hidden ? 0.0 : 1.0
                        
                        if LGPhotoBrowserOptions.current.contains(.displayCloseButton) {
                            self.closeButton.alpha = alpha
                            self.closeButton.frame = closeFrame
                        }
                        if LGPhotoBrowserOptions.current.contains(.displayDeleteButton) {
                            self.deleteButton.alpha = alpha
                            self.deleteButton.frame = deleteFrame
                        }
        }, completion: nil)
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        browser?.determineAndClose()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        guard let browser = self.browser else { return }
        
        browser.delegate?.removePhoto?(browser, index: browser.currentPageIndex) { [weak self] in
            self?.browser?.deleteImage()
        }
    }
}

extension LGActionView {
    func configureCloseButton(image: UIImage? = nil, size: CGSize? = nil) {
        if closeButton == nil {
            closeButton = LGCloseButton(frame: .zero)
            closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
            closeButton.isHidden = !LGPhotoBrowserOptions.current.contains(.displayCloseButton)
            addSubview(closeButton)
        }
        
        guard let size = size else { return }
        closeButton.setFrameSize(size)
        
        guard let image = image else { return }
        closeButton.setImage(image, for: UIControlState())
    }
    
    func configureDeleteButton(image: UIImage? = nil, size: CGSize? = nil) {
        if deleteButton == nil {
            deleteButton = LGDeleteButton(frame: .zero)
            deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            deleteButton.isHidden = LGPhotoBrowserOptions.current.contains(.displayDeleteButton)
            addSubview(deleteButton)
        }
        
        guard let size = size else { return }
        deleteButton.setFrameSize(size)
        
        guard let image = image else { return }
        deleteButton.setImage(image, for: UIControlState())
    }
}
