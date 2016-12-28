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
        
        //if user is already logged (standard user, not lead), store user data, else user_id = nil and email = nil
        let alteredData = cyData
        if alteredData?.user?.is_user == 0{
            alteredData?.user?.user_id = nil
            alteredData?.user?.email = nil
            alteredData?.user?.name = nil
        }
        
        if alteredData != nil{
            UserDefaults.standard.set(alteredData!.toJSON(), forKey: "cyDataModel")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cyDataModel"), object: nil)
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
    
    static func storeCySingleParameters(user: CyUserModel? = nil, cookies: CyCookiesResponseModel? = nil){
        
        if let data = getCyDataModel(){
            //if user is already logged (standard user, not lead), store user data, else user_id = nil and email = nil
            let alteredData = data
            alteredData.user = user ?? alteredData.user
            alteredData.cookies = cookies ?? alteredData.cookies
            if alteredData.user?.is_user == 0{
                alteredData.user?.user_id = nil
                alteredData.user?.email = nil
                alteredData.user?.name = nil
            }
            data.user = alteredData.user
            data.cookies = alteredData.cookies
            storeCyDataModel(cyData: data)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cyDataModel"), object: nil)
        }
    }
    
}
