//
//  CyMessageModel.swift
//  Customerly

import ObjectMapper

class CyMessageModel: Mappable {

    var conversation_message_id : Int?
    var conversation_id : Int?
    var user_id: Int?
    var account_id: Int?
    var content: String?
    var sent_date: Int?
    var seen_date: Int?
    var type: Int?
    var close_conversation: Int?
    var rich_mail: Bool = false
    var rich_mail_url: String?
    var attachments: [CyAttachmentModel]?
    var account: CyAccountModel?
    
    //Extra
    var showAvatar: Bool = true //indicate if the avatar need to be showed or not
    var attributedMessage: NSMutableAttributedString?
    var attachmentsImages: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_message_id <- map["conversation_message_id"]
        conversation_id <- map["conversation_id"]
        user_id <- map["user_id"]
        account_id <- map["account_id"]
        content <- map["content"]
        sent_date <- map["sent_date"]
        seen_date <- map["seen_date"]
        type <- map["type"]
        close_conversation <- map["close_conversation"]
        rich_mail <- map["rich_mail"]
        rich_mail_url <- map["rich_mail_link"]
        attachments <- map["attachments"]
        account <- map["account"]
        
        populateExtraFields()
    }
    
    func populateExtraFields(){
        attachmentsImages = getAttachmentsImages(message: self)
        if rich_mail == true{
            attributedMessage = getRichEmailMessage()
        }else{
            attributedMessage = content!.removeImageTagsFromHTML().attributedStringFromHTMLWithImages(font: UIFont(name: "Helvetica", size: 14.0)!, color: account_id != nil ? UIColor(hexString:"#1A1A1A") : UIColor.white, imageMaxWidth: abs(UIScreen.main.bounds.width/2))
        }
        
    }
    
    func getAttachmentsImages(message: CyMessageModel) -> [String]?{
        var images : [String] = []
        if message.attachments != nil{
            for attachment in message.attachments!{
                if attachment.path?.containOneSuffix(suffixes: [".jpg", ".JPEG", ".jpeg", ".png", ".PNG", ".tif", ".TIFF", ".gif"]) == true{
                    images.append(attachment.path!)
                }
            }
        }
        if let imagesFromHTML = message.content?.arrayOfImagesFromHTML(){
            images = images + imagesFromHTML
        }
        
        return images.count > 0 ? images : nil
    }
    
    func getRichEmailMessage() -> NSMutableAttributedString{
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "mail_icon", in: CyBundle.getBundle(), compatibleWith: nil)
        attachment.bounds.size = CGSize(width: 50, height: 39)
        
        let attributedAttachment = NSAttributedString(attachment: attachment)
        let attributedText = NSAttributedString(string: "\n\n\("chatViewRichMessageText".localized(comment: "Chat View"))\n", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexString:"#1A1A1A")])
        
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(attributedAttachment)
        attributedString.append(attributedText)
        
        attributedString.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: attributedString.length)) { (attribute, range, stop) -> Void in
            if (attribute as? NSTextAttachment) != nil {
                //center all attachments in attributed string
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
        return attributedString
    }
}
