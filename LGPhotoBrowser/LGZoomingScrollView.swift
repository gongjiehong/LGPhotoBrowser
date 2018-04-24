//
//  LGZoomingScrollView.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

open class LGZoomingScrollView: UIScrollView {
    var photo: LGPhotoProtocol! {
        didSet {
            
        }
    }
    
    fileprivate weak var browser: LGPhotoBrowser?
    fileprivate(set) var imageView: LGTapDetectingImageView!
    fileprivate var tapView: LGTapDetectingView!
    fileprivate var progressView: LGCircleProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    convenience init(frame: CGRect, browser: LGPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        setupDefault()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefault()
    }
    
    func setupDefault() {
        // tap
        tapView = LGTapDetectingView(frame: self.bounds)
        tapView.detectingDelegate = self
        tapView.backgroundColor = .clear
        tapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tapView)
        
        // image
        imageView = LGTapDetectingImageView(frame: self.bounds)
        imageView.detectingDelegate = self
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        addSubview(imageView)
        
        progressView = LGCircleProgressView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        progressView.clockwise = true
        progressView.trackImage = UIImage(named: "progress")
        progressView.trackFillColor = UIColor.white
        addSubview(progressView)
        
        self.backgroundColor = .clear
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.autoresizingMask = [.flexibleWidth,
                                 .flexibleTopMargin,
                                 .flexibleBottomMargin,
                                 .flexibleRightMargin,
                                 .flexibleLeftMargin]
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.tapView.frame = self.bounds
        self.imageView.frame = self.bounds
        
        let boundsSize = bounds.size
        var frameToCenter = imageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !imageView.frame.equalTo(frameToCenter) {
            imageView.frame = frameToCenter
        }
    }
    
    open func setMaxMinZoomScalesForCurrentBounds() {
        self.maximumZoomScale = 1
        self.minimumZoomScale = 1
        self.zoomScale = 1
        
        guard let imageView = self.imageView else {
            return
        }
        
        let boundsSize = bounds.size
        let imageSize = imageView.frame.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        var minScale: CGFloat = min(xScale, yScale)
        var maxScale: CGFloat = 1.0
        
        let scale = max(UIScreen.main.scale, 2.0)
        // width in pixels. scale needs to remove if to use the old algorithm
        let deviceScreenWidth = UIScreen.main.bounds.width * scale
        // height in pixels. scale needs to remove if to use the old algorithm
        let deviceScreenHeight = UIScreen.main.bounds.height * scale
        
        if LGPhotoBrowserOptions.longPhotoWidthMatchScreen &&
            imageView.frame.height >= imageView.frame.width
        {
            minScale = 1.0
            maxScale = 2.0
        } else if imageView.frame.width < deviceScreenWidth {
            if UIApplication.shared.statusBarOrientation.isPortrait {
                maxScale = deviceScreenHeight / imageView.frame.width
            } else {
                maxScale = deviceScreenWidth / imageView.frame.width
            }
        } else if imageView.frame.width > deviceScreenWidth {
            maxScale = 1.0
        } else {
            maxScale = 2.0
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
        self.zoomScale = minScale
        
        // reset position
        self.imageView.frame.origin = CGPoint.zero
        setNeedsLayout()
    }
    
    open func prepareForReuse() {
        photo = nil
    }
    
    // MARK: - image
    open func displayImage(complete flag: Bool) {
        // reset scale
        self.maximumZoomScale = 1
        self.minimumZoomScale = 1
        self.zoomScale = 1
        progressView.center = self.center
        if !flag {
            if photo.underlyingImage == nil {
                progressView.isHidden = true
            }
            photo.loadUnderlyingImageAndNotify()
        } else {
            progressView.isHidden = false
        }
        
        if photo != nil, let image = photo.underlyingImage {
            // image
            imageView.image = image
            imageView.contentMode = photo.contentMode
            
            var imageViewFrame: CGRect = .zero
            imageViewFrame.origin = .zero
            // long photo
            if LGPhotoBrowserOptions.longPhotoWidthMatchScreen && image.size.height >= image.size.width {
                let imageHeight = LGMesurement.lg_screenWidth / image.size.width * image.size.height
                imageViewFrame.size = CGSize(width: LGMesurement.lg_screenWidth, height: imageHeight)
            } else {
                imageViewFrame.size = image.size
            }
            imageView.frame = imageViewFrame
            
            contentSize = imageViewFrame.size
            setMaxMinZoomScalesForCurrentBounds()
        } else {
            // change contentSize will reset contentOffset, so only set the contentsize zero when the image is nil
            contentSize = CGSize.zero
        }
        setNeedsLayout()
    }
    
    open func displayImageFailure() {
        progressView.isHidden = true
    }
    
    deinit {
        browser = nil
    }
}

extension LGZoomingScrollView: LGTapDetectingImageViewDelegate {
    public func singleTapDetected(_ touch: UITouch, targetView: UIImageView) {
        
    }
    
    public func doubleTapDetected(_ touch: UITouch, targetView: UIImageView) {
        
    }
    
    public func tripleTapDetected(_ touch: UITouch, targetView: UIImageView) {
        
    }
}

extension LGZoomingScrollView: LGTapDetectingViewDelegate {
    public func singleTapDetected(_ touch: UITouch, targetView: UIView) {
        
    }
    
    public func doubleTapDetected(_ touch: UITouch, targetView: UIView) {
        
    }
    
    public func tripleTapDetected(_ touch: UITouch, targetView: UIView) {
        
    }
}

extension LGZoomingScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        browser?.cancelControlHiding()
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
