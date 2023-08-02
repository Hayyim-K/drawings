//
//  UITextField + Extesion.swift
//  drawings
//
//  Created by vitasiy on 01/08/2023.
//

import UIKit

extension UITextField {
    func set(_ isBold: Bool, _ isItalics: Bool, _ isUndeerline: Bool, _ font: String, _ textSize: CGFloat) {
        guard var textFont = UIFont(name: font, size: textSize) else { return }
        let fontDescriptor = textFont.fontDescriptor
        var traits = fontDescriptor.symbolicTraits.union([])
        if isBold && isItalics {
            traits = fontDescriptor.symbolicTraits.union([.traitBold, .traitItalic])
        } else if isBold && !isItalics {
            traits = fontDescriptor.symbolicTraits.union([.traitBold])
        } else if !isBold && isItalics {
            traits = fontDescriptor.symbolicTraits.union([.traitItalic])
        }
        textFont = UIFont(descriptor: fontDescriptor.withSymbolicTraits(traits)!, size: textSize)
        
        if let textUnwrapped = self.text {
            
            var underlineAttribute: [NSAttributedString.Key : Any] = [
                .font : textFont,
            ]
            
            if isUndeerline {
                underlineAttribute[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            
            let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: underlineAttribute)
            
            self.attributedText = underlineAttributedString
        }
    }
}
