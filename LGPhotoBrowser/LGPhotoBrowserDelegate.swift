//
//  LGPhotoBrowserDelegate.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation

@objc public protocol LGPhotoBrowserDelegate {
    @objc optional
    func didShowPhotoAtIndex(_ browser: LGPhotoBrowser, index: Int)
}

public protocol LGPhotoBrowserDatasource {
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: LGPhotoBrowser) -> Int
    func photoBrowser(_ photoBrowser: LGPhotoBrowser, photoAtIndex index: Int) -> LGPhoto
}

