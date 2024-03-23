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
    
    func saveImageToDocument(image: UIImage, fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        do {
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func loadImageToDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print(error)
            }
        } else {
            print("file not exist, remove error")
        }
    }
    
    func showDestructiveAlert(title: String, message: String, hadler: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive, handler: hadler)
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        return alert
    }
}
