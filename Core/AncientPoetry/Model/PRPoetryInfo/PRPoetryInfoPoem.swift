//
//	PRPoetryInfoPoem.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoPoem : NSObject, NSCoding{

	var content : [PRPoetryInfoContent]!
	var poet : PRPoetryInfoPoet!
	var title : PRPoetryInfoTitle!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		content = [PRPoetryInfoContent]()
		let contentArray = json["content"].arrayValue
		for contentJson in contentArray{
			let value = PRPoetryInfoContent(fromJson: contentJson)
			content.append(value)
		}
		let poetJson = json["poet"]
		if !poetJson.isEmpty{
			poet = PRPoetryInfoPoet(fromJson: poetJson)
		}
		let titleJson = json["title"]
		if !titleJson.isEmpty{
			title = PRPoetryInfoTitle(fromJson: titleJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if content != nil{
			var dictionaryElements = [[String:Any]]()
			for contentElement in content {
				dictionaryElements.append(contentElement.toDictionary())
			}
			dictionary["content"] = dictionaryElements
		}
		if poet != nil{
			dictionary["poet"] = poet.toDictionary()
		}
		if title != nil{
			dictionary["title"] = title.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? [PRPoetryInfoContent]
         poet = aDecoder.decodeObject(forKey: "poet") as? PRPoetryInfoPoet
         title = aDecoder.decodeObject(forKey: "title") as? PRPoetryInfoTitle

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
		if poet != nil{
			aCoder.encode(poet, forKey: "poet")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}
