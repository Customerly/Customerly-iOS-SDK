
//
//  CyString.swift
//  Customerly

import UIKit

//MARK: HTML Utils
extension String {
    
    func attributedStringFromHTML(font: UIFont, color: UIColor) -> NSMutableAttributedString?{
        do{
            let bodyHtml: String = "<style>p{margin:0;padding:0}</style><div style=\"font-family: \(font.fontDescriptor.postscriptName); font-size: \(Int(font.pointSize)); color:\(color.toHexString())\">\(self)</div>"
            let attributedMessage = try NSMutableAttributedString(data: ((bodyHtml).data(using: String.Encoding.unicode, allowLossyConversion: false)!), options: [.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedMessage
        }
        catch{
            
        }
        return nil
    }
    
    func attributedStringFromHTMLWithImages(font: UIFont, color: UIColor, imageMaxWidth: CGFloat) -> NSMutableAttributedString?{
        do{
            let bodyHtml: String = "<style>p{margin:0;padding:0} img{width:\(imageMaxWidth))px;display:block;}</style><div style=\"font-family: \(font.fontDescriptor.postscriptName); font-size: \(Int(font.pointSize)); color:\(color.toHexString())\">\(self)</div>"
            let attributedMessage = try NSMutableAttributedString(data: ((bodyHtml).data(using: String.Encoding.unicode, allowLossyConversion: false)!), options: [.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
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
            let matches = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, self.count))
            let nsHtmlContent = (self as NSString)
            let matchesArray = matches.map { nsHtmlContent.substring(with: $0.range)}
            
            //Get src url
            var resultArray : [String] = []
            for matchedString in matchesArray{
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let match = detector.firstMatch(in: matchedString, options: [], range: NSMakeRange(0, matchedString.count))
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
            
            let matches = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSMakeRange(0, self.count))
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

//MARK: Operations on token string.
extension String{
    
    //Type of user ---- 1 = anonymous, 2 = lead, 4 = user
    func userTypeFromToken() -> CyUserType{
        if self.jsonDataInToken()?.user_type != nil{
            return CyUserType(rawValue: self.jsonDataInToken()!.user_type!) ?? CyUserType.anonymous
        }
        
        return CyUserType.anonymous
    }
    
    func jsonDataInToken() -> CyTokenModel?{
        let pattern = "([^.]+)\\.([^.]+)\\.([^.]+)"
        
        let capturedGroups = self.capturedGroups(withRegex: pattern)
        if capturedGroups.count >= 2{
            let match = capturedGroups[1]
            return CyTokenModel(JSONString: match.base64Decoded() ?? "")
        }
        
        return nil
    }
    
    func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }
}

//MARK: base64 encoding & decoding
extension String{
    
    func base64Decoded() -> String? {
        let rem = self.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64 = self.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions(rawValue: 0), range: nil) + ending
        
        guard let data = Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            cyPrint("Error during base64 decode")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func base64Encoded() -> String? {
        return Data(self.utf8).base64EncodedString()
    }
}

//MARK: - AttributedString
extension NSMutableAttributedString{
    func addAttributes(font: UIFont, color: UIColor){
        self.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color], range: NSRange(location:0, length:self.length))
    }
    
}
