//
//  CyStorage.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyStorage: NSObject {

    
    //MARK: CyDataModel Storage
    static func storeCyDataModel(cyData : CyDataModel?){
        if cyData != nil{
            UserDefaults.standard.set(cyData!.toJSON(), forKey: "cyDataModel")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CyStoredData"), object: nil)
        }
    }
    
    static func deleteCyDataModel(){
        UserDefaults.standard.set(nil, forKey: "cyDataModel")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cyDataModel"), object: nil)
    }
    
    static func getCyDataModel() -> CyDataModel?{
        if let dataJSONModel = UserDefaults.standard.object(forKey: "cyDataModel") as? [String: AnyObject]{
            let data = Mapper<CyDataModel>().map(JSON: dataJSONModel)
            return data
        }
        return nil
    }
    
    static func storeCyUserModel(user: CyUserModel?){
        if user != nil{
            if let data = getCyDataModel(){
                data.user = user
                storeCyDataModel(cyData: data)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cyDataModel"), object: nil)
            }
        }
    }
    
}
