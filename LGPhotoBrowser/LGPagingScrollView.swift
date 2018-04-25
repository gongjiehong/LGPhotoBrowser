//
//  LGPagingScrollView.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/25.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

/// tag 偏移量，避免跟默认tag重复
fileprivate let PageIndexTagOffset: Int = 1000

/// 滑动和重用视图
open class LGPagingScrollView: UIScrollView {
    fileprivate let sideMargin: CGFloat = 10
    fileprivate var visiblePages: [LGZoomingScrollView] = []
    fileprivate var recycledPages: [LGZoomingScrollView] = []
    fileprivate weak var browser: LGPhotoBrowser?
    
    var numberOfPhotos: Int {
        return browser?.photos.count ?? 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect, browser: LGPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        self.updateFrame(bounds, currentPageIndex: browser.currentPageIndex)
    }
    
    func reload() {
        self.visiblePages.forEach({ $0.removeFromSuperview() })
        self.visiblePages.removeAll()
        self.recycledPages.removeAll()
    }
    
    func loadAdjacentPhotosIfNecessary(_ photo: LGPhotoProtocol, currentPageIndex: Int) {
        guard let browser = browser, let page = pageDisplayingAtPhoto(photo) else {
            return
        }
        let pageIndex = (page.tag - PageIndexTagOffset)
        if currentPageIndex == pageIndex {
            // Previous
            if pageIndex > 0 {
                let previousPhoto = browser.photos[pageIndex - 1]
                if previousPhoto.underlyingImage == nil {
                    previousPhoto.loadUnderlyingImageAndNotify()
                }
            }
            // Next
            if pageIndex < numberOfPhotos - 1 {
                let nextPhoto = browser.photos[pageIndex + 1]
                if nextPhoto.underlyingImage == nil {
                    nextPhoto.loadUnderlyingImageAndNotify()
                }
            }
        }
    }
    
    func deleteImage() {
        // index equals 0 because when we slide between photos delete button is hidden and user cannot to touch on delete button. And visible pages number equals 0
        if numberOfPhotos > 0 {
//            visiblePages[0].captionView?.removeFromSuperview()
        }
    }
    
    func jumpToPageAtIndex(_ frame: CGRect) {
        let point = CGPoint(x: frame.origin.x - sideMargin, y: 0)
        setContentOffset(point, animated: true)
    }
    
    func updateFrame(_ bounds: CGRect, currentPageIndex: Int) {
        var frame = bounds
        frame.origin.x -= sideMargin
        frame.size.width += (2 * sideMargin)
        
        self.frame = frame
        
        if visiblePages.count > 0 {
            for page in visiblePages {
                let pageIndex = page.tag - PageIndexTagOffset
                page.frame = frameForPageAtIndex(pageIndex)
                page.setMaxMinZoomScalesForCurrentBounds()
            }
        }
        
        updateContentSize()
        updateContentOffset(currentPageIndex)
    }
    
    func updateContentSize() {
        contentSize = CGSize(width: bounds.size.width * CGFloat(numberOfPhotos), height: bounds.size.height)
    }
    
    func updateContentOffset(_ index: Int) {
        let pageWidth = bounds.size.width
        let newOffset = CGFloat(index) * pageWidth
        contentOffset = CGPoint(x: newOffset, y: 0)
    }
    
    func tilePages() {
        guard let browser = browser else { return }
        
        let firstIndex: Int = getFirstIndex()
        let lastIndex: Int = getLastIndex()
        
        visiblePages
            .filter({ $0.tag - PageIndexTagOffset < firstIndex })
            .filter({ $0.tag - PageIndexTagOffset > lastIndex })
            .forEach { page in
                recycledPages.append(page)
                page.prepareForReuse()
                page.removeFromSuperview()
        }
        
        let visibleSet: Set<LGZoomingScrollView> = Set(visiblePages)
        let visibleSetWithoutRecycled: Set<LGZoomingScrollView> = visibleSet.subtracting(recycledPages)
        visiblePages = Array(visibleSetWithoutRecycled)
        
        while recycledPages.count > 2 {
            recycledPages.removeFirst()
        }
        
        for index: Int in firstIndex...lastIndex {
            if visiblePages.filter({ $0.tag - PageIndexTagOffset == index }).count > 0 {
                continue
            }
            
            let page: LGZoomingScrollView = LGZoomingScrollView(frame: frame, browser: browser)
            page.frame = frameForPageAtIndex(index)
            page.tag = index + PageIndexTagOffset
            page.photo = browser.photos[index]
            
            visiblePages.append(page)
            addSubview(page)
        }
    }
    
    
    func pageDisplayedAtIndex(_ index: Int) -> LGZoomingScrollView? {
        for page in visiblePages where page.tag - PageIndexTagOffset == index {
            return page
        }
        return nil
    }
    
    func pageDisplayingAtPhoto(_ photo: LGPhotoProtocol) -> LGZoomingScrollView? {
        for page in visiblePages {
            if page.photo === photo {
                return page
            }
        }
        return nil
    }
}

fileprivate extension LGPagingScrollView {
    func frameForPageAtIndex(_ index: Int) -> CGRect {
        var pageFrame = bounds
        pageFrame.size.width -= (2 * sideMargin)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + sideMargin
        return pageFrame
    }
    
    func getFirstIndex() -> Int {
        let firstIndex = Int(floor((bounds.minX + sideMargin * 2) / bounds.width))
        if firstIndex < 0 {
            return 0
        }
        if firstIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return firstIndex
    }
    
    func getLastIndex() -> Int {
        let lastIndex  = Int(floor((bounds.maxX - sideMargin * 2 - 1) / bounds.width))
        if lastIndex < 0 {
            return 0
        }
        if lastIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return lastIndex
    }
}
