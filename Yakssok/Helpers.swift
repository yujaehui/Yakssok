//
//  Helpers.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

final class Helpers {
    static let shared = Helpers()
    private init() {}
    
    func replaceSpacesWithUnderscore(_ text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "_")
    }
    
    func changeSearchResultText(_ text: String, changeText: String) -> NSMutableAttributedString {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>|\\([^\\)]+\\)", options: [])
        let modifiedText = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count), withTemplate: "")
        let attributedText = NSMutableAttributedString(string: modifiedText)
        let range = (modifiedText as NSString).range(of: changeText, options: .caseInsensitive)
        attributedText.addAttribute(.foregroundColor, value: ColorStyle.point, range: range)
        return attributedText
    }
}
