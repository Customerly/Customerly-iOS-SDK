
//
//  CyString.swift
//  Customerly
//
//  Created by Paolo Musolino on 25/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

extension String {
    
    func attributedStringFromHTML(font: UIFont, color: UIColor) -> NSMutableAttributedString?{
        do{
            let bodyHtml: String = "<style>p{margin:0;padding:0}</style><div style=\"font-family: \(font.fontDescriptor.postscriptName); font-size: \(Int(font.pointSize)); color:\(color.toHexString())\">\(self)</div>"
            let attributedMessage = try NSMutableAttributedString(data: ((bodyHtml).data(using: String.Encoding.unicode, allowLossyConversion: false)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            return attributedMessage
        }
        catch{
            
        }
        return nil
    }
    
    func attributedStringFromHTMLWithImages(font: UIFont, color: UIColor, imageMaxWidth: CGFloat) -> NSMutableAttributedString?{
        do{
            let bodyHtml: String = "<style>p{margin:0;padding:0} img{width:\(imageMaxWidth))px;display:block;}</style><div style=\"font-family: \(font.fontDescriptor.postscriptName); font-size: \(Int(font.pointSize)); color:\(color.toHexString())\">\(self)</div>"
            let attributedMessage = try NSMutableAttributedString(data: ((bodyHtml).data(using: String.Encoding.unicode, allowLossyConversion: false)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            return attributedMessage
        }
        catch{
            
        }
        return nil
    }
    
    func arrayOfImagesFromHTML() -> [String]?{
        let pattern =  "<img [^>]*src=\"([^\"]+)\"[^>]*>"
        
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, self.characters.count))
            let nsHtmlContent = (self as NSString)
            let matchesArray = matches.map { nsHtmlContent.substring(with: $0.range)}
            
            //Get src url
            var resultArray : [String] = []
            for matchedString in matchesArray{
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let match = detector.firstMatch(in: matchedString, options: [], range: NSMakeRange(0, matchedString.characters.count))
                let nsMatchedString = (matchedString as NSString)
                resultArray.append(nsMatchedString.substring(with: match!.range))
            }
            return resultArray.count > 0 ? resultArray : nil
        }
        catch{
        }
        
        return nil
    }
    
    func removeImageTagsFromHTML() -> String{
        let pattern =  "<img [^>]*src=\"([^\"]+)\"[^>]*>"
        
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let matches = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, self.characters.count))
            let nsHtmlContent = (self as NSString)
            
            let matchesArray = matches.map { nsHtmlContent.substring(with: $0.range)}
            
            var finalString = self
            for match in matchesArray{
                finalString = finalString.replacingOccurrences(of: match, with: "")
            }
            return finalString
        }
        catch{
        }
        
        return self
    }
    
    //Check if a string contains almost one suffix from suffixes array
    func containOneSuffix(suffixes: [String]) -> Bool{
        for suffix in suffixes{
            if self.hasSuffix(suffix){
                return true
            }
        }
        return false
    }
    
    
    
}

//MARK: Localizable Strings
extension String{
    func localized(comment: String = "") -> String{
        let frameworkBundle = Bundle(for: Customerly.self)
        
        var resourceBundle: Bundle?
        
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("CustomerlySDK.bundle"),
            let resourceBundleGenerated = Bundle(url: bundleURL) {
            
            // Installed using CocoaPods
            resourceBundle = resourceBundleGenerated
        } else {
            resourceBundle = frameworkBundle
        }
        
        if resourceBundle != nil{
            return NSLocalizedString(self, tableName: "Localizable", bundle: resourceBundle!, value: "", comment: comment)
        }
        
        return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: comment)
    }
    
}
