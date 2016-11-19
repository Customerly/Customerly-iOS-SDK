//
//  CyStorage.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyStorage: NSObject {

    func storeDataLocaly(user: CyStorageModel?){
        if user != nil{
            UserDefaults.standard.set(user!.toJSON(), forKey: "basicDataCustomerly")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CyStoredData"), object: nil)
        }
    }
    
    func deleteLocalData(){
        UserDefaults.standard.set(nil, forKey: "basicDataCustomerly")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CyStoredData"), object: nil)
    }
    
    func getLocalData() -> CyStorageModel?{
        if let userJSONModel = UserDefaults.standard.object(forKey: "basicDataCustomerly") as? [String: AnyObject]{
            let user = Mapper<CyStorageModel>().map(JSON: userJSONModel)
            return user
        }
        return nil
    }
}
