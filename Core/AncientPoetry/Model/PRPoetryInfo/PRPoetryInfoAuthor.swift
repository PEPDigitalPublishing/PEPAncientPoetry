//
//	PRPoetryInfoAuthor.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoAuthor : NSObject, NSCoding{

	var img : String!
	var intro : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		img = json["img"].stringValue
		intro = json["intro"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if img != nil{
			dictionary["img"] = img
		}
		if intro != nil{
			dictionary["intro"] = intro
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         img = aDecoder.decodeObject(forKey: "img") as? String
         intro = aDecoder.decodeObject(forKey: "intro") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if img != nil{
			aCoder.encode(img, forKey: "img")
		}
		if intro != nil{
			aCoder.encode(intro, forKey: "intro")
		}

	}

}