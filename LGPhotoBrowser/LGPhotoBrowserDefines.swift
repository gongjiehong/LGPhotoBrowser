//
//  LGPhotoBrowserDefines.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

public struct LGPBNotifications {
    public static let progress: Notification.Name = {
        let name = Notification.Name(rawValue: "kLGPhotoBrowserProgressNotification")
        return name
    }()
    
    public static let downloadCompleted: Notification.Name = {
        let name = Notification.Name(rawValue: "kLGPhotoBrowserDownloadCompletedNotification")
        return name
    }()
}


public enum LGPhotoLoadStatus {
    case unknown
    case placeholder
    case progress
    case finished
    case failed
}

public enum LGPhotoBrowserStatus {
    case browsing
    case rowsingAndEditing
}

public struct LGPhotoBrowserSettings {
    public static var backgroundColor: UIColor = .black
}


public struct LGPhotoBrowserOptions: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let displayStatusbar: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 0)
    }()
    
//    public static var displayStatusbar: Bool = false
//    public static var displayCloseButton: Bool = true
//    public static var displayDeleteButton: Bool = false
//    
//    public static var displayAction: Bool = true
//    public static var shareExtraCaption: String?
//    public static var actionButtonTitles: [String]?
//    
//    public static var displayCounterLabel: Bool = true
//    public static var displayBackAndForwardButton: Bool = true
//    
//    public static var displayHorizontalScrollIndicator: Bool = true
//    public static var displayVerticalScrollIndicator: Bool = true
//    public static var displayPagingHorizontalScrollIndicator: Bool = true
//    
//    public static var bounceAnimation: Bool = false
//    public static var enableZoomBlackArea: Bool = true
//    public static var enableSingleTapDismiss: Bool = false
//    
//    public static var backgroundColor: UIColor = .black
//    public static var indicatorColor: UIColor = .white
//    public static var indicatorStyle: UIActivityIndicatorViewStyle = .whiteLarge
//    
//    /// By default close button is on left side and delete button is on right.
//    ///
//    /// Set this property to **true** for swap they.
//    ///
//    /// Default: false
//    public static var swapCloseAndDeleteButtons: Bool = false
//    public static var disableVerticalSwipe: Bool = false
//    
//    /// if this value is true, the long photo width will match the screen,
//    /// and the minScale is 1.0, the maxScale is 2.5
//    /// Default: false
    public static var longPhotoWidthMatchScreen: Bool = false
}
