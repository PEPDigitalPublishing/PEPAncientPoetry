//
//	PRPoetryInfoLableTime.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoLableTime : NSObject, NSCoding{

	var contentEndtime : Int!
	var contentStartime : Int!
	var eEndtimeBehind : Int!
	var eEndtimeHead : Int!
	var eStartimeBehind : Int!
	var eStartimeHead : Int!
	var word : String!
	var wordEndtime : Int!
	var wordStartime : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		contentEndtime = json["contentEndtime"].intValue
		contentStartime = json["contentStartime"].intValue
		eEndtimeBehind = json["eEndtimeBehind"].intValue
		eEndtimeHead = json["eEndtimeHead"].intValue
		eStartimeBehind = json["eStartimeBehind"].intValue
		eStartimeHead = json["eStartimeHead"].intValue
		word = json["word"].stringValue
		wordEndtime = json["wordEndtime"].intValue
		wordStartime = json["wordStartime"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if contentEndtime != nil{
			dictionary["contentEndtime"] = contentEndtime
		}
		if contentStartime != nil{
			dictionary["contentStartime"] = contentStartime
		}
		if eEndtimeBehind != nil{
			dictionary["eEndtimeBehind"] = eEndtimeBehind
		}
		if eEndtimeHead != nil{
			dictionary["eEndtimeHead"] = eEndtimeHead
		}
		if eStartimeBehind != nil{
			dictionary["eStartimeBehind"] = eStartimeBehind
		}
		if eStartimeHead != nil{
			dictionary["eStartimeHead"] = eStartimeHead
		}
		if word != nil{
			dictionary["word"] = word
		}
		if wordEndtime != nil{
			dictionary["wordEndtime"] = wordEndtime
		}
		if wordStartime != nil{
			dictionary["wordStartime"] = wordStartime
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         contentEndtime = aDecoder.decodeObject(forKey: "contentEndtime") as? Int
         contentStartime = aDecoder.decodeObject(forKey: "contentStartime") as? Int
         eEndtimeBehind = aDecoder.decodeObject(forKey: "eEndtimeBehind") as? Int
         eEndtimeHead = aDecoder.decodeObject(forKey: "eEndtimeHead") as? Int
         eStartimeBehind = aDecoder.decodeObject(forKey: "eStartimeBehind") as? Int
         eStartimeHead = aDecoder.decodeObject(forKey: "eStartimeHead") as? Int
         word = aDecoder.decodeObject(forKey: "word") as? String
         wordEndtime = aDecoder.decodeObject(forKey: "wordEndtime") as? Int
         wordStartime = aDecoder.decodeObject(forKey: "wordStartime") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if contentEndtime != nil{
			aCoder.encode(contentEndtime, forKey: "contentEndtime")
		}
		if contentStartime != nil{
			aCoder.encode(contentStartime, forKey: "contentStartime")
		}
		if eEndtimeBehind != nil{
			aCoder.encode(eEndtimeBehind, forKey: "eEndtimeBehind")
		}
		if eEndtimeHead != nil{
			aCoder.encode(eEndtimeHead, forKey: "eEndtimeHead")
		}
		if eStartimeBehind != nil{
			aCoder.encode(eStartimeBehind, forKey: "eStartimeBehind")
		}
		if eStartimeHead != nil{
			aCoder.encode(eStartimeHead, forKey: "eStartimeHead")
		}
		if word != nil{
			aCoder.encode(word, forKey: "word")
		}
		if wordEndtime != nil{
			aCoder.encode(wordEndtime, forKey: "wordEndtime")
		}
		if wordStartime != nil{
			aCoder.encode(wordStartime, forKey: "wordStartime")
		}

	}

}