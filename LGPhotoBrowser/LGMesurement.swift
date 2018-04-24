//
//  UIDevice+LGPhotoBrowser.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

public struct LGMesurement {
    public static let lg_isPhone: Bool = {
        return UIDevice.current.userInterfaceIdiom == .phone
    }()
    
    public static let lg_isPad: Bool = {
        return UIDevice.current.userInterfaceIdiom == .pad
    }()

    public static let lg_statusBarHeight: CGFloat = {
        return UIApplication.shared.statusBarFrame.height
    }()
    
    public static let lg_screenWidth: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    public static let lg_screenHeight: CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    public static let lg_screenScale: CGFloat = {
        return UIScreen.main.scale
    }()
    
    public static let screenRatio: CGFloat = {
        return lg_screenWidth / lg_screenHeight
    }()
    
    public static let lg_isPhoneX: Bool = {
        return lg_isPhone && UIScreen.main.nativeBounds.height == 2436
    }()
}
