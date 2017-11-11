//
//  OrderFormatter.swift
//  DaVinci
//
//  Created by Avik Roy on 10/8/16.
//  Copyright © 2016 Enchanter. All rights reserved.
//

import UIKit

class AddressFormatter: NSObject {
    class func splitAddressToAddresslines(_ string : String)->NSArray?{
        let addressLine = string.components(separatedBy: "||")
        if(addressLine.count > 0){
            return addressLine[0].components(separatedBy: ",") as NSArray
        }else{
            return nil
        }

    }
    
    class func splitAddressToCity(_ string : String)->String?{
        let addressLine = string.components(separatedBy: "||")
        if(addressLine.count >= 1){
            return addressLine[1]
        }else{
            return ""
        }
        
    }
    
    class func splitAddressToState(_ string : String)->String?{
        let addressLine = string.components(separatedBy: "||")
        if(addressLine.count >= 2){
            return addressLine[2]
        }else{
            return ""
        }
        
    }
    
    class func splitAddressToZip(_ string : String)->String?{
        let addressLine = string.components(separatedBy: "||")
        if(addressLine.count >= 3){
            return addressLine[3]
        }else{
            return ""
        }
        
    }
    
    class func getAddressFromAddresLine(_ addressline1:String, addressline2:String, addressline3:String, city:String, state:String, zip:String)->String{
        let finalAddress:String = "\(addressline1),\(addressline2),\(addressline3)||\(city)||\(state)||\(zip)"
        return finalAddress
    }
}
