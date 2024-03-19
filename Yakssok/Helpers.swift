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
    
    func changeSearchResultText(_ text: String, changeText: String) -> NSMutableAttributedString {
        let modifiedText = text.replacingOccurrences(of: "(전량수출용)", with: "")
        let attributedText = NSMutableAttributedString(string: modifiedText)
        let range = (text as NSString).range(of: changeText, options: .caseInsensitive)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: range)
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
}
