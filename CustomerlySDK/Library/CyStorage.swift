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
        if let userJSONModel = UserDefaults.standard.object(forKey: "cyDataModel") as? [String: AnyObject]{
            let user = Mapper<CyDataModel>().map(JSON: userJSONModel)
            return user
        }
        return nil
    }
    
    //MARK: User Storage. For the moment this part is UNUSED
    func storeUserData(user: CyStorageModel?){
        if user != nil{
            UserDefaults.standard.set(user!.toJSON(), forKey: "userDataCustomerly")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDataCustomerly"), object: nil)
        }
    }
    
    func deleteUserData(){
        UserDefaults.standard.set(nil, forKey: "userDataCustomerly")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDataCustomerly"), object: nil)
    }
    
    func getUserData() -> CyStorageModel?{
        if let userJSONModel = UserDefaults.standard.object(forKey: "userDataCustomerly") as? [String: AnyObject]{
            let user = Mapper<CyStorageModel>().map(JSON: userJSONModel)
            return user
        }
        return nil
    }
}
