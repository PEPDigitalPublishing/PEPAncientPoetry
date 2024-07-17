//
//	PRPoetryInfoKnowledge.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoKnowledge : NSObject, NSCoding{

	var analysis : String!
	var answer : String!
	var correct : String!
	var headline : String!
	var img : String!
	var isanalysis : Bool!
	var option : [PRPoetryInfoOption]!
	var order : String!
	var sort : Int!
	var title : String!
	var type : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		analysis = json["analysis"].stringValue
		answer = json["answer"].stringValue
		correct = json["correct"].stringValue
		headline = json["headline"].stringValue
		img = json["img"].stringValue
		isanalysis = json["isanalysis"].boolValue
		option = [PRPoetryInfoOption]()
		let optionArray = json["option"].arrayValue
		for optionJson in optionArray{
			let value = PRPoetryInfoOption(fromJson: optionJson)
			option.append(value)
		}
		order = json["order"].stringValue
		sort = json["sort"].intValue
		title = json["title"].stringValue
		type = json["type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if analysis != nil{
			dictionary["analysis"] = analysis
		}
		if answer != nil{
			dictionary["answer"] = answer
		}
		if correct != nil{
			dictionary["correct"] = correct
		}
		if headline != nil{
			dictionary["headline"] = headline
		}
		if img != nil{
			dictionary["img"] = img
		}
		if isanalysis != nil{
			dictionary["isanalysis"] = isanalysis
		}
		if option != nil{
			var dictionaryElements = [[String:Any]]()
			for optionElement in option {
				dictionaryElements.append(optionElement.toDictionary())
			}
			dictionary["option"] = dictionaryElements
		}
		if order != nil{
			dictionary["order"] = order
		}
		if sort != nil{
			dictionary["sort"] = sort
		}
		if title != nil{
			dictionary["title"] = title
		}
		if type != nil{
			dictionary["type"] = type
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         analysis = aDecoder.decodeObject(forKey: "analysis") as? String
         answer = aDecoder.decodeObject(forKey: "answer") as? String
         correct = aDecoder.decodeObject(forKey: "correct") as? String
         headline = aDecoder.decodeObject(forKey: "headline") as? String
         img = aDecoder.decodeObject(forKey: "img") as? String
         isanalysis = aDecoder.decodeObject(forKey: "isanalysis") as? Bool
         option = aDecoder.decodeObject(forKey: "option") as? [PRPoetryInfoOption]
         order = aDecoder.decodeObject(forKey: "order") as? String
         sort = aDecoder.decodeObject(forKey: "sort") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if analysis != nil{
			aCoder.encode(analysis, forKey: "analysis")
		}
		if answer != nil{
			aCoder.encode(answer, forKey: "answer")
		}
		if correct != nil{
			aCoder.encode(correct, forKey: "correct")
		}
		if headline != nil{
			aCoder.encode(headline, forKey: "headline")
		}
		if img != nil{
			aCoder.encode(img, forKey: "img")
		}
		if isanalysis != nil{
			aCoder.encode(isanalysis, forKey: "isanalysis")
		}
		if option != nil{
			aCoder.encode(option, forKey: "option")
		}
		if order != nil{
			aCoder.encode(order, forKey: "order")
		}
		if sort != nil{
			aCoder.encode(sort, forKey: "sort")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}