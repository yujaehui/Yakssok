//
//  Helpers.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

class Helpers {
    static let shared = Helpers()
    private init() {}
    
    func replaceSpacesWithUnderscore(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "_")
    }
    
    func removeSubstring(originalString: String) -> String {
        let modifiedString = originalString.replacingOccurrences(of: "(전량수출용)", with: "")
        return modifiedString
    }
    
    func textColorChange(_ text: String, changeText: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: changeText, options: .caseInsensitive)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
        return attributedText
    }
}
