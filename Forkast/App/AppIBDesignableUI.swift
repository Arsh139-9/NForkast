//
//  AppIBDesignableUI.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0



@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
extension UITextField{
    @IBInspectable var maxLength: Int {
                get {
                    if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                        return length
                    } else {
                        return Int.max
                    }
                }
                set {
                    objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
                    self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
                }
            }

    //The method is used to cancel the check when use Chinese Pinyin input method.
            //Becuase the alphabet also appears in the textfield when inputting, we should cancel the check.
            func isInputMethod() -> Bool {
                if let positionRange = self.markedTextRange {
                    if let _ = self.position(from: positionRange.start, offset: 0) {
                        return true
                    }
                }
                return false
            }


    @objc func checkMaxLength(textField: UITextField) {

                guard !self.isInputMethod(), let prospectiveText = self.text,
                    prospectiveText.count > maxLength
                    else {
                        return
                }

                let selection = selectedTextRange
                let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
                text = prospectiveText.substring(to: maxCharIndex)
                selectedTextRange = selection
            }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor : newValue!])
        }
    }
}

class PaddingTextField: UITextField {

@IBInspectable var paddingLeft: CGFloat = 0
@IBInspectable var paddingRight: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y,
                      width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height);
}

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
}}



extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
}
extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
@IBDesignable
class RoundableImageView: UIImageView {

    @IBInspectable var cornerRadiusImg : CGFloat = 0.0{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderColorImg : UIColor = UIColor.clear{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderWidthImg : Double = 0{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var circular : Bool = false{
        didSet{
            self.applyCornerRadius()
        }
    }

    func applyCornerRadius()
    {
        if(self.circular) {
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColorImg.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidthImg)
        }else {
            self.layer.cornerRadius = cornerRadiusImg
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColorImg.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidthImg)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyCornerRadius()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }

}
