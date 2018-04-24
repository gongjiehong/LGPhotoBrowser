//
//  LGPhotoBrowser.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

open class LGPhotoBrowser: UIViewController {
    open var currentPageIndex: Int = 0
    open var photos: [LGPhotoProtocol] = [LGPhotoProtocol]()
//    internal lazy var pagingScrollView: LGZoomingScrollView = LGZoomingScrollView(frame: self.view.frame, browser: self)
}
