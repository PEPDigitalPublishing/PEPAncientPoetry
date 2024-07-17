//
//	PRPoetryInfoAnnotation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoAnnotation : NSObject, NSCoding{

	var option : String!
	var place : [Int]!
	var content : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		option = json["option"].stringValue
		place = [Int]()
		let placeArray = json["place"].arrayValue
		for placeJson in placeArray{
			place.append(placeJson.intValue)
		}
		content = json["content"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if option != nil{
			dictionary["option"] = option
		}
		if place != nil{
			dictionary["place"] = place
		}
		if content != nil{
			dictionary["content"] = content
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         option = aDecoder.decodeObject(forKey: "option") as? String
         place = aDecoder.decodeObject(forKey: "place") as? [Int]
         content = aDecoder.decodeObject(forKey: "content") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if option != nil{
			aCoder.encode(option, forKey: "option")
		}
		if place != nil{
			aCoder.encode(place, forKey: "place")
		}
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}

	}

}
