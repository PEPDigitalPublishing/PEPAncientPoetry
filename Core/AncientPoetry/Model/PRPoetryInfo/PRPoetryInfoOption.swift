//
//	PRPoetryInfoOption.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoOption : NSObject, NSCoding{

	var choice : String!
	var value : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		choice = json["choice"].stringValue
		value = json["value"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if choice != nil{
			dictionary["choice"] = choice
		}
		if value != nil{
			dictionary["value"] = value
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         choice = aDecoder.decodeObject(forKey: "choice") as? String
         value = aDecoder.decodeObject(forKey: "value") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if choice != nil{
			aCoder.encode(choice, forKey: "choice")
		}
		if value != nil{
			aCoder.encode(value, forKey: "value")
		}

	}

}