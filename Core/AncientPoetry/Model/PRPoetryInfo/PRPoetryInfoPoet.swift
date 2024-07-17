//
//	PRPoetryInfoPoet.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoPoet : NSObject, NSCoding{

	var content : String!
	var mp3 : String!
	var name : String!
	var nametime : [PRPoetryInfoLableTime]!
	var place : [String]!
    var annotation : [String]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		content = json["content"].stringValue
		mp3 = json["mp3"].stringValue
		name = json["name"].stringValue
		nametime = [PRPoetryInfoLableTime]()
		let nametimeArray = json["nametime"].arrayValue
		for nametimeJson in nametimeArray{
			let value = PRPoetryInfoLableTime(fromJson: nametimeJson)
			nametime.append(value)
		}
		place = [String]()
		let placeArray = json["place"].arrayValue
		for placeJson in placeArray{
			place.append(placeJson.stringValue)
		}
        annotation = [String]()
        let annotationArray = json["annotation"].arrayValue
        for annotationJson in annotationArray{
            annotation.append(annotationJson.stringValue)
        }
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if content != nil{
			dictionary["content"] = content
		}
		if mp3 != nil{
			dictionary["mp3"] = mp3
		}
		if name != nil{
			dictionary["name"] = name
		}
		if nametime != nil{
			var dictionaryElements = [[String:Any]]()
			for nametimeElement in nametime {
				dictionaryElements.append(nametimeElement.toDictionary())
			}
			dictionary["nametime"] = dictionaryElements
		}
		if place != nil{
			dictionary["place"] = place
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         mp3 = aDecoder.decodeObject(forKey: "mp3") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         nametime = aDecoder.decodeObject(forKey: "nametime") as? [PRPoetryInfoLableTime]
         place = aDecoder.decodeObject(forKey: "place") as? [String]
        annotation = aDecoder.decodeObject(forKey: "annotation") as? [String]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if mp3 != nil{
			aCoder.encode(mp3, forKey: "mp3")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if nametime != nil{
			aCoder.encode(nametime, forKey: "nametime")
		}
		if place != nil{
			aCoder.encode(place, forKey: "place")
		}

	}

}
