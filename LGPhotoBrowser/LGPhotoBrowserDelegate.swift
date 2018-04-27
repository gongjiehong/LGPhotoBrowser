//
//  LGPhotoBrowserDelegate.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

@objc public protocol LGPhotoBrowserDelegate: NSObjectProtocol {
    @objc optional
    func didShowPhotoAtIndex(_ browser: LGPhotoBrowser, index: Int)

    @objc optional func willDismissAtPageIndex(_ index: Int)
    
    @objc optional func willShowActionSheet(_ photoIndex: Int)

    @objc optional func didDismissAtPageIndex(_ index: Int)
    
    @objc optional func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int)
    
    @objc optional func didScrollToIndex(_ browser: LGPhotoBrowser, index: Int)
    
    @objc optional func removePhoto(_ browser: LGPhotoBrowser, index: Int, reload: @escaping (() -> Void))
    
    @objc optional func viewForPhoto(_ browser: LGPhotoBrowser, index: Int) -> UIView?
    
    @objc optional func controlsVisibilityToggled(_ browser: LGPhotoBrowser, hidden: Bool)
}

public protocol LGPhotoBrowserDatasource: NSObjectProtocol {
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: LGPhotoBrowser) -> Int
    func photoBrowser(_ photoBrowser: LGPhotoBrowser, photoAtIndex index: Int) -> LGPhotoProtocol
}

