//
//  LGPhotoBrowserDefines.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

/// 整个生命周期中使用到的通知定义
public struct LGPBNotifications {
    
    /// 进度条通知
    public static let progress: Notification.Name = {
        let name = Notification.Name(rawValue: "kLGPhotoBrowserProgressNotification")
        return name
    }()
    
    /// 图片下载完成通知
    public static let downloadCompleted: Notification.Name = {
        let name = Notification.Name(rawValue: "kLGPhotoBrowserDownloadCompletedNotification")
        return name
    }()
}


/// LGPhoto的状态定义
///
/// - unknown: 未知
/// - placeholder: 使用placeholder
/// - progress: 下载中
/// - finished: 下载完成
/// - failed: 下载失败
public enum LGPhotoLoadStatus {
    case unknown
    case placeholder
    case progress
    case finished
    case failed
}

/// LGPhotoBrowser的状态定义，此状态决定内容的显示状态
///
/// - browsing: 纯浏览图片
/// - rowsingAndEditing: 浏览和编辑，例如修改
public enum LGPhotoBrowserStatus {
    case browsing
    case browsingAndEditing
}

/// 浏览器设置项定义
public struct LGPhotoBrowserSettings {
    public static var backgroundColor: UIColor = .black
}


/// 浏览器选项定义
public struct LGPhotoBrowserOptions: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var current: LGPhotoBrowserOptions = .default
    
    public static let `default`: LGPhotoBrowserOptions = {
       return [.displayStatusbar,
               .displayCloseButton,
               .longPhotoWidthMatchScreen,
               .enableBounceAnimation]
    }()
    
    public static let displayStatusbar: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 0)
    }()
    
    public static let displayCloseButton: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 1)
    }()
    
    public static let displayDeleteButton: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 2)
    }()
    
    public static let longPhotoWidthMatchScreen: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 3)
    }()
    
    public static let enableBounceAnimation: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 4)
    }()
    
    public static let disableVerticalSwipe: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 5)
    }()
    
    public static let swapCloseAndDeleteButtons: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 6)
    }()
    
    public static let enableZoomBlackArea: LGPhotoBrowserOptions = {
        return LGPhotoBrowserOptions(rawValue: 1 << 7)
    }()
    
    

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
//    public static var longPhotoWidthMatchScreen: Bool = false
}

public struct LGButtonOptions {
    public static var closeButtonPadding: CGPoint = CGPoint(x: 5, y: 20)
    public static var deleteButtonPadding: CGPoint = CGPoint(x: 5, y: 20)
}
