//
//  CyHTTPValidation.swift
//  Customerly
//
//  Created by Paolo Musolino on 14/10/16.
//
//
import Foundation

extension URLResponse{
    
    //Return error if the status code is not inside 200-299 range.
    func validate() -> Error?{
        let acceptableStatusCodes: Range<Int> = 200..<300
        
        let response = self as! HTTPURLResponse
    
        if !acceptableStatusCodes.contains(response.statusCode){
            
            let failureReason = "Response status code was unacceptable: \(response.statusCode)"
            
            let error = NSError(
                domain: cy_domain,
                code: response.statusCode,
                userInfo: [
                    NSLocalizedFailureReasonErrorKey: failureReason,
                    "StatusCode": response.statusCode
                ]
            )
            return error
        }
        
        return nil
    }
}

extension Data{
    
    func validate() -> CyErrorModel?{
        let acceptableStatusCodes: Range<Int> = 200..<300
        let jsonData = JSONParseDictionary(data: self)
        let errorModel = CyErrorModel(JSON: jsonData)
        if errorModel?.status_code != nil && !acceptableStatusCodes.contains(errorModel!.status_code!){
            return errorModel
        }
    
        return nil
    }
}
