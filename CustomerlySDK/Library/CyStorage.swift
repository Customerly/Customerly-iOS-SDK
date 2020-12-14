//
//  CyStorage.swift
//  Customerly

import ObjectMapper

class CyStorage: NSObject {
    
    //MARK: CyDataModel Storage
    static func storeCyDataModel(cyData : CyDataModel?){
        
        //if user is already logged (standard user, not lead, not anonymous), store user data, else user_id = nil and email = nil
        let alteredData = cyData
        if alteredData?.token?.userTypeFromToken() != CyUserType.user{
            alteredData?.user?.user_id = nil
            alteredData?.user?.email = nil
            alteredData?.user?.name = nil
        }
        
        if alteredData != nil{
            UserDefaults.standard.set(alteredData!.toJSON(), forKey: "cyDataModel")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func deleteCyDataModel(){
        UserDefaults.standard.set(nil, forKey: "cyDataModel")
        UserDefaults.standard.synchronize()
    }
    
    static func getCyDataModel() -> CyDataModel?{
        if let dataJSONModel = UserDefaults.standard.object(forKey: "cyDataModel") as? [String: AnyObject]{
            let data = Mapper<CyDataModel>().map(JSON: dataJSONModel)
            return data
        }
        return nil
    }
    
    static func storeCySingleParameters(user: CyUserModel? = nil, token: String? = nil, lead_hash: String? = nil){
        
        if let data = getCyDataModel(){
            //if user is already logged (standard user, not lead, not anonymous), store user data, else user_id = nil and email = nil
            let alteredData = data
            alteredData.user = user ?? data.user
            alteredData.token = token ?? data.token
            alteredData.lead_hash = lead_hash ?? data.lead_hash
            if alteredData.token?.userTypeFromToken() != CyUserType.user{
                alteredData.user?.user_id = nil
                alteredData.user?.email = nil
                alteredData.user?.name = nil
            }
            storeCyDataModel(cyData: alteredData)
        }
    }
    
}
