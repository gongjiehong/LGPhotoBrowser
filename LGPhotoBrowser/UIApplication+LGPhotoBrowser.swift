//
//  UIApplication+LGPhotoBrowser.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/25.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

internal func LGApplicationWindow() -> UIWindow? {
    return UIApplication.shared.lg_currentWindow
}

internal extension UIApplication {
    var lg_currentWindow: UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        } else if let window = UIApplication.shared.keyWindow {
            return window
        } else {
            return nil
        }
    }
}
