//
//  LGPhoto.swift
//  LGPhotoBrowser
//
//  Created by 龚杰洪 on 2018/4/24.
//  Copyright © 2018年 龚杰洪. All rights reserved.
//

import Foundation
import LGHTTPRequest
import LGWebImage

public protocol LGPhotoProtocol: NSObjectProtocol {
    var index: Int { get set }
    var underlyingImage: UIImage? { get }
    var caption: String? { get }
    var contentMode: UIViewContentMode { get set }
    var isVideo: Bool { get set}
    var isEmptyImage: Bool { get set}
    var photoStatus: LGPhotoLoadStatus {get}
    var photoURL: LGURLConvertible { get set }
    
    func loadUnderlyingImageAndNotify()
    func checkImage(_ completed: @escaping (Bool) -> Void)
}

open class LGPhoto: NSObject, LGPhotoProtocol {
    public var index: Int = 0
    
    public var underlyingImage: UIImage?
    
    public var caption: String?
    
    public var contentMode: UIViewContentMode = UIViewContentMode.scaleAspectFill
    
    public var isVideo: Bool = false
    
    public var isEmptyImage: Bool = false
    
    public var photoStatus: LGPhotoLoadStatus = LGPhotoLoadStatus.unknown
    
    public var photoURL: LGURLConvertible
    
    public var progress: Progress = Progress(totalUnitCount: 0)
    
    public init(photoURL: LGURLConvertible,
                isVideo: Bool = false,
                contentMode: UIViewContentMode = UIViewContentMode.scaleAspectFill,
                underlyingImage: UIImage? = nil,
                placeholderImage: UIImage? = nil)
    {
        self.photoURL = photoURL
        self.isVideo = isVideo
        self.contentMode = contentMode
        if underlyingImage != nil {
            self.underlyingImage = underlyingImage
            photoStatus = .finished
        } else {
            self.underlyingImage = placeholderImage
            photoStatus = .placeholder
        }
        
    }
    
    public func checkImage(_ completed: @escaping (Bool) -> Void) {
        if self.isVideo {
            return
        }
        if photoStatus == .finished {
            return
        }
        do {
            let imageURL = try self.photoURL.asURL()
            DispatchQueue.userInitiated.async {
                if imageURL.isFileURL {
                    do {
                        let data = try Data(contentsOf: imageURL)
                        if let image = LGImage.imageWith(data: data) {
                            DispatchQueue.main.async {
                                self.underlyingImage = image
                                completed(true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completed(false)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completed(false)
                        }
                    }
                } else {
                    let imageURLString = imageURL.absoluteString
                    if let image = LGImageCache.default.getImage(forKey: imageURLString) {
                        DispatchQueue.main.async {
                            self.underlyingImage = image
                            completed(true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completed(false)
                        }
                    }
                }
            }
        } catch {
            completed(false)
        }
    }
    
    public func loadUnderlyingImageAndNotify() {
        if self.isVideo {
            downloadVideo()
        } else {
            downloadImage()
        }
    }
    
    func downloadVideo() {
        
    }
    
    func downloadImage() {
        LGWebImageManager.default.downloadImageWith(url: self.photoURL,
                                                    options: LGWebImageOptions.default,
                                                    progress:
            {[weak self] (progress) in
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.progress = progress
                    NotificationCenter.default.post(name: LGPBNotifications.progress,
                                                    object: weakSelf.photoURL,
                                                    userInfo: nil)
                }
                
            }, transform: nil)
        { [weak self] (resultImage, _, _, imageStatus, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                if resultImage != nil && error == nil {
                    if imageStatus == .progress {
                        weakSelf.photoStatus = .progress
                    } else {
                        weakSelf.photoStatus = .finished
                    }
                    
                } else {
                    weakSelf.photoStatus = .failed
                }
                weakSelf.underlyingImage = resultImage
                NotificationCenter.default.post(name: LGPBNotifications.downloadCompleted,
                                                object: weakSelf.photoURL,
                                                userInfo: nil)
            }
        }
    }
}

