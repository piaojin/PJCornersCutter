//
//  PJCornersCutter.swift
//  CornersCutter
//
//  Created by Zoey Weng on 2018/1/11.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

public extension UIView {
    
    /** --->设置UIView、UIButton和UILabel圆角，UIImageView的圆角设置请使用***pj_drawCornerImageView()***
     * @param radius 圆角半径，默认切成圆
     */
    public func pj_addCorner(radius: CGFloat = 0.0) {
        self.pj_addCorner(radius: radius, direction: .allCorners)
    }
    
    /** --->设置UIView、UIButton和UILabel圆角，UIImageView的圆角设置请使用***pj_drawCornerImageView()***
     * @param radius 圆角半径，默认切成圆
     * @param direction 切割的方向
     */
    public func pj_addCorner(radius: CGFloat,
                             direction: UIRectCorner = .allCorners) {
        let backgroundColor = self.backgroundColor ?? .clear
        let borderColor = self.layer.borderColor ?? UIColor.clear.cgColor
        if self is UIImageView {
            let imageView = self as? UIImageView
            imageView?.pj_drawCornerImageView(radius: radius, direction: direction, borderWidth: self.layer.borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
        } else {
            let imageView = UIImageView(image: pj_drawRectWithRoundedCorner(radius: radius,
                                                                            direction: direction,
                                                                            borderWidth: self.layer.borderWidth,
                                                                            backgroundColor: backgroundColor,
                                                                            borderColor: borderColor))
            self.insertSubview(imageView, at: 0)
        }
    }
    
    /** --->这种方式不能设置backgroundColor,用setFillColor的方式替换backgroundColor<---,*支持 autoLayout或是第三方的自动布局库*,切割UIView、UIButton和UILabel圆角，UIImageView的圆角设置请使用***pj_drawCornerImageView()***
     * @param direction 切割的方向
     * @param radius 圆角半径
     * @param borderWidth 边框宽度
     * @param borderColor 边框颜色
     * @param backgroundColor 背景色
     */
    public func pj_drawRectWithRoundedCorner(radius: CGFloat,
                                             direction: UIRectCorner = .allCorners,
                                             borderWidth: CGFloat = 0.0,
                                             backgroundColor: UIColor = .clear,
                                             borderColor: CGColor) -> UIImage {
        var sizeToFit: CGSize = .zero
        if self.bounds.size != .zero {
            sizeToFit = self.bounds.size
        } else {
            // support autoLayout
            
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            
            if let widthConstraint = self.pj_widthConstraint {
                width = widthConstraint.constant
            }
            
            if let heightConstraint = self.pj_heightConstraint {
                height = heightConstraint.constant
            }
            
            sizeToFit = CGSize(width: width, height: height)
        }
        
        var radius = radius
        
        if radius == 0 {
            radius = self.bounds.size.height / 2.0
        }
        
        if self.pjCorner == nil {
            self.pjCorner = PJCorner(radius: radius, direction: direction, view: self)
        }
        
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.clear.cgColor
        
        if sizeToFit.width == 0.0 || sizeToFit.height == 0.0 {
            print("⚠️PJCornersCutter warn: ***view size is zero***")
            return UIImage()
        }
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(borderWidth)
            //去除UIView的borderColor，用setStrokeColor的方式替换borderColor
            self.layer.borderColor = UIColor.clear.cgColor
            context.setStrokeColor(borderColor)
            context.setFillColor(backgroundColor.cgColor)
            //去除UIView的背景色，用setFillColor的方式替换backgroundColor
            self.backgroundColor = .clear
            
            var radius = radius
            if radius == 0.0 {
                radius = sizeToFit.height / 2.0
            }
            let width = sizeToFit.width, height = sizeToFit.height
            
            // 单切圆角
            if direction == .allCorners {
                context.move(to: CGPoint(x: width - borderWidth, y: radius + borderWidth))// 从右下开始
                context.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - radius - borderWidth, y: height - borderWidth), radius: radius)
                context.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth, y: height - radius - borderWidth), radius: radius)
                context.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: borderWidth), radius: radius)
                context.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y:  radius + borderWidth), radius: radius)
                
            } else {
                context.move(to: CGPoint(x: radius + borderWidth, y: borderWidth))// 从左上开始
                if direction.contains(.topLeft) {
                    context.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: borderWidth, y: radius + borderWidth), radius: radius)
                } else {
                    context.addLine(to: CGPoint(x: borderWidth, y: borderWidth))
                }
                if direction.contains(.bottomLeft) {
                    context.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth + radius, y: height - borderWidth), radius: radius)
                } else {
                    context.addLine(to: CGPoint(x: borderWidth, y: height - borderWidth))
                }
                if direction.contains(.bottomRight) {
                    context.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: height - borderWidth - radius), radius: radius)
                } else {
                    context.addLine(to: CGPoint(x: width - borderWidth, y: height - borderWidth))
                }
                if direction.contains(.topRight) {
                    context.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth - radius, y: borderWidth), radius: radius)
                } else {
                    context.addLine(to: CGPoint(x: width - borderWidth, y: borderWidth))
                }
                context.addLine(to: CGPoint(x: borderWidth + radius, y: borderWidth))
            }
            
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            self.pjCorner?.isCorneredDone = true
            return image
        } else {
            print("⚠️PJCornersCutter warn: ***get UIGraphicsGetCurrentContext() Failure***")
            return UIImage()
        }
    }
}

public extension UIImageView {
    
    /**
     * 设置圆形UIImageView，普通非UIImageView视图使用***pj_addCorner()***设置圆角
     */
    public func pj_drawCornerImageView() {
        let backgroundColor = self.backgroundColor ?? .clear
        let borderColor = self.layer.borderColor ?? UIColor.clear.cgColor
        self.pj_drawCornerImageView(radius: self.frame.size.height / 2.0, direction: .allCorners, borderWidth: self.layer.borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
    }
    
    /** 切割UIImageView圆角，普通非UIImageView视图使用***pj_addCorner()***设置圆角
     * @param direction 切割的方向
     * @param radius 圆角半径
     */
    public func pj_drawCornerImageView(radius: CGFloat = 0.0, direction: UIRectCorner = .allCorners) {
        let backgroundColor = self.backgroundColor ?? .clear
        let borderColor = self.layer.borderColor ?? UIColor.clear.cgColor
        self.pj_drawCornerImageView(radius: radius, direction: direction, borderWidth: self.layer.borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
    }
    
    /** 切割UIImageView圆角，普通非UIImageView视图使用***pj_addCorner()***设置圆角
     * @param direction 切割的方向
     * @param radius 圆角半径
     * @param borderWidth 边框宽度
     * @param borderColor 边框颜色
     * @param backgroundColor 背景色
     */
    public func pj_drawCornerImageView(radius: CGFloat = 0.0, direction: UIRectCorner = .allCorners, borderWidth: CGFloat = 0.0, borderColor: CGColor = UIColor.clear.cgColor, backgroundColor: UIColor = .clear)
    {
        
        var sizeToFit: CGSize = .zero
        if self.bounds.size != .zero {
            sizeToFit = self.bounds.size
        } else {
            // support autoLayout
            
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            
            if let widthConstraint = self.pj_widthConstraint {
                width = widthConstraint.constant
            }
            
            if let heightConstraint = self.pj_heightConstraint {
                height = heightConstraint.constant
            }
            
            sizeToFit = CGSize(width: width, height: height)
        }
        
        var radius = radius
        // 先截取UIImageView视图Layer生成的Image，然后再做渲染
        var image : UIImage?
        image = self.image
        
        if radius == 0 {
            radius = self.bounds.size.height / 2.0
        }
        
        if self.pjCorner == nil {
            self.pjCorner = PJCorner(radius: radius, direction: direction, imageView: self)
        }
        
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.clear.cgColor
        
        if sizeToFit.width == 0.0 || sizeToFit.height == 0.0 {
            print("⚠️PJCornersCutter warn: ***view size is zero***")
            return
        }
        
        if image == nil {
            return
        }
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizeToFit)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: direction, cornerRadii: CGSize(width: radius - borderWidth, height: radius - borderWidth))
            currentContext.addPath(path.cgPath)
            currentContext.setLineWidth(borderWidth)
            currentContext.clip()
            
            image?.draw(in: rect)
            UIColor(cgColor: borderColor).setStroke()// 画笔颜色
            UIColor.clear.setFill()// 填充颜色
            path.stroke()
            path.fill()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else {
            print("⚠️PJCornersCutter warn: ***get UIGraphicsGetCurrentContext() Failure***")
        }
        
        if let tempImage = image {
            self.pjCorner?.isNeedSendObserver = false
            self.image = tempImage
            self.pjCorner?.isCorneredDone = true
        }
    }
}

public extension UIView {
    
    struct AssociatedKey {
        static var kPJCornerKey: String = "kPJCornerKey"
    }
    
    public var pjCorner: PJCorner? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.kPJCornerKey) as? PJCorner
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.kPJCornerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func removePJCorner() {
        objc_removeAssociatedObjects(self)
    }
}

open class PJCorner: NSObject {
    private let kImageKey = "image"
    private let kBoundsKey = "bounds"
    var radius: CGFloat = 0.0
    var direction: UIRectCorner = .allCorners
    weak var view: UIView?
    var isNeedSendObserver: Bool = true
    var removeObserverWhenCorneredDone = false
    var isCorneredDone = false
    
    convenience init(radius: CGFloat = 0.0, direction: UIRectCorner = .allCorners, imageView: UIImageView) {
        self.init(radius: radius, direction: direction, view: imageView)
        self.view?.addSafeObserver(observer: self, forKeyPath: kImageKey, options: [.new, .old])
    }
    
    convenience init(radius: CGFloat = 0.0, direction: UIRectCorner = .allCorners, view: UIView) {
        self.init()
        self.radius = radius
        self.direction = direction
        self.view = view
        self.view?.addSafeObserver(observer: self, forKeyPath: kBoundsKey, options: [.new, .old])
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kImageKey {
            if isNeedSendObserver {
                if let tempView = view, let imageView =  tempView as? UIImageView {
                    imageView.pj_drawCornerImageView(radius: radius, direction: direction)
                }
            } else {
                self.isNeedSendObserver = true
            }
        } else if keyPath == kBoundsKey {
            if let tempView = view, let imageView =  tempView as? UIImageView {
                imageView.pj_drawCornerImageView(radius: radius, direction: direction)
            }
        }
        
        if self.isCorneredDone, self.removeObserverWhenCorneredDone {
            self.view?.removeSafeObserver(observer: self, forKeyPath: kImageKey)
            self.view?.removeSafeObserver(observer: self, forKeyPath: kBoundsKey)
        }
    }
    
    deinit {
        self.view?.removeSafeObserver(observer: self, forKeyPath: kImageKey)
        self.view?.removeSafeObserver(observer: self, forKeyPath: kBoundsKey)
    }
}

// MARK: 安全添加移除Observer
extension NSObject {
    private struct AssociatedKeys {
        static var safeObservers = "safeObservers"
    }
    
    private var safeObservers: [ObserverInfo] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.safeObservers) as? [ObserverInfo] ?? []
        }
        set (new) {
            objc_setAssociatedObject(self, &AssociatedKeys.safeObservers, new, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addSafeObserver(observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions) {
        let observerInfo = ObserverInfo(observer: observer, keypath: keyPath)
        if !self.safeObservers.contains(observerInfo) {
            self.safeObservers.append(ObserverInfo(observer: observer, keypath: keyPath))
            self.addObserver(observer, forKeyPath: keyPath, options: options, context: nil)
        }
    }
    
    func removeSafeObserver(observer: NSObject, forKeyPath keyPath: String) {
        let observerInfo = ObserverInfo(observer: observer, keypath: keyPath)
        if self.safeObservers.contains(observerInfo) {
            if let index = self.safeObservers.index(of: observerInfo) {
                self.safeObservers.remove(at: index)
                self.removeObserver(observer, forKeyPath: keyPath)
            }
        }
    }
}

private class ObserverInfo: Equatable {
    let observer: UnsafeMutableRawPointer
    let keypath: String
    
    init(observer: NSObject, keypath: String) {
        self.observer = Unmanaged.passUnretained(observer).toOpaque()
        self.keypath = keypath
    }
}

private func ==(lhs: ObserverInfo, rhs: ObserverInfo) -> Bool {
    return lhs.observer == rhs.observer && lhs.keypath == rhs.keypath
}

// MARK: 获取上下左右NSLayoutConstraint
public extension UIView {
    var pj_constraints: [NSLayoutConstraint]? {
        return self.superview?.constraints
    }
    
    var pj_leftConstraint: NSLayoutConstraint? {
        return self.pj_getConstraint(firstAttribute: .left, secondAttribute: .leading)
    }
    
    var pj_rightConstraint: NSLayoutConstraint? {
        return self.pj_getConstraint(firstAttribute: .right, secondAttribute: .trailing)
    }
    
    var pj_topConstraint: NSLayoutConstraint? {
        return self.pj_getConstraint(firstAttribute: .top, secondAttribute: .top)
    }
    
    var pj_bottomConstraint: NSLayoutConstraint? {
        return self.pj_getConstraint(firstAttribute: .bottom, secondAttribute: .bottom)
    }
    
    var pj_widthConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            if constraint.firstAttribute == .width {
                if let object = constraint.firstItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            } else if constraint.secondAttribute == .width {
                if let object = constraint.secondItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            }
            return false
        }).first
    }
    
    var pj_heightConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            if constraint.firstAttribute == .height {
                if let object = constraint.firstItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            } else if constraint.secondAttribute == .height {
                if let object = constraint.secondItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            }
            return false
        }).first
    }
    
    // .right .trailing
    func pj_getConstraint(firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        return self.pj_constraints?.filter({ (constraint) -> Bool in
            if constraint.firstAttribute == firstAttribute || constraint.firstAttribute == secondAttribute {
                if let object = constraint.firstItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            } else if constraint.secondAttribute == firstAttribute || constraint.secondAttribute == secondAttribute {
                if let object = constraint.secondItem, let objc = object as? NSObject, objc == self {
                    return true
                }
            }
            return false
        }).first
    }
}
