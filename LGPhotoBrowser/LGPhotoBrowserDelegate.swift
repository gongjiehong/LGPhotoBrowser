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
    
    /**
     Tells the delegate the browser will start to dismiss
     
     - Parameter index: the index of the current photo
     */
    @objc optional func willDismissAtPageIndex(_ index: Int)
    
    /**
     Tells the delegate that the browser will start showing the `UIActionSheet`
     
     - Parameter photoIndex: the index of the current photo
     */
    @objc optional func willShowActionSheet(_ photoIndex: Int)
    
    /**
     Tells the delegate that the browser has been dismissed
     
     - Parameter index: the index of the current photo
     */
    @objc optional func didDismissAtPageIndex(_ index: Int)
    
    /**
     Tells the delegate that the browser did dismiss the UIActionSheet
     
     - Parameter buttonIndex: the index of the pressed button
     - Parameter photoIndex: the index of the current photo
     */
    @objc optional func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int)
    
    /**
     Tells the delegate that the browser did scroll to index
     
     - Parameter index: the index of the photo where the user had scroll
     */
    @objc optional func didScrollToIndex(_ browser: LGPhotoBrowser, index: Int)
    
    /**
     Tells the delegate the user removed a photo, when implementing this call, be sure to call reload to finish the deletion process
     
     - Parameter browser: reference to the calling SKPhotoBrowser
     - Parameter index: the index of the removed photo
     - Parameter reload: function that needs to be called after finishing syncing up
     */
    @objc optional func removePhoto(_ browser: LGPhotoBrowser, index: Int, reload: @escaping (() -> Void))
    
    /**
     Asks the delegate for the view for a certain photo. Needed to detemine the animation when presenting/closing the browser.
     
     - Parameter browser: reference to the calling SKPhotoBrowser
     - Parameter index: the index of the removed photo
     
     - Returns: the view to animate to
     */
    @objc optional func viewForPhoto(_ browser: LGPhotoBrowser, index: Int) -> UIView?
    
    /**
     Tells the delegate that the controls view toggled visibility
     
     - Parameter browser: reference to the calling SKPhotoBrowser
     - Parameter hidden: the status of visibility control
     */
    @objc optional func controlsVisibilityToggled(_ browser: LGPhotoBrowser, hidden: Bool)
    
    /**
     Allows  the delegate to create its own caption view
     
     - Parameter index: the index of the photo
     */
//    @objc optional func captionViewForPhotoAtIndex(index: Int) -> SKCaptionView?
}

public protocol LGPhotoBrowserDatasource: NSObjectProtocol {
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: LGPhotoBrowser) -> Int
    func photoBrowser(_ photoBrowser: LGPhotoBrowser, photoAtIndex index: Int) -> LGPhotoProtocol
}

