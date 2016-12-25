
//
//  CyString.swift
//  Customerly
//
//  Created by Paolo Musolino on 25/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

extension String {
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
            return resultArray
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
}

