//
//	PRPoetryInfoRootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoRootClass : NSObject, NSCoding{

	var appreciate : PRPoetryInfoAppreciate!
	var author : PRPoetryInfoAuthor!
	var background : String!
	var id : String!
	var isPhonetic : Bool!
	var isorder : Bool!
	var knowledge : [PRPoetryInfoKnowledge]!
	var mp4src : PRPoetryInfoMp4src!
	var poem : PRPoetryInfoPoem!
	var poemDuring : [Int]!
	var poetry : PRPoetryInfoAppreciate!
	var wholeMp3 : [PRPoetryInfoWholeMp3]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let appreciateJson = json["appreciate"]
		if !appreciateJson.isEmpty{
			appreciate = PRPoetryInfoAppreciate(fromJson: appreciateJson)
		}
		let authorJson = json["author"]
		if !authorJson.isEmpty{
			author = PRPoetryInfoAuthor(fromJson: authorJson)
		}
		background = json["background"].stringValue
		id = json["id"].stringValue
		isPhonetic = json["isPhonetic"].boolValue
		isorder = json["isorder"].boolValue
		knowledge = [PRPoetryInfoKnowledge]()
		let knowledgeArray = json["knowledge"].arrayValue
		for knowledgeJson in knowledgeArray{
			let value = PRPoetryInfoKnowledge(fromJson: knowledgeJson)
			knowledge.append(value)
		}
		let mp4srcJson = json["mp4src"]
		if !mp4srcJson.isEmpty{
			mp4src = PRPoetryInfoMp4src(fromJson: mp4srcJson)
		}
		let poemJson = json["poem"]
		if !poemJson.isEmpty{
			poem = PRPoetryInfoPoem(fromJson: poemJson)
		}
		poemDuring = [Int]()
		let poemDuringArray = json["poemDuring"].arrayValue
		for poemDuringJson in poemDuringArray{
			poemDuring.append(poemDuringJson.intValue)
		}
		let poetryJson = json["poetry"]
		if !poetryJson.isEmpty{
			poetry = PRPoetryInfoAppreciate(fromJson: poetryJson)
		}
		wholeMp3 = [PRPoetryInfoWholeMp3]()
		let wholeMp3Array = json["wholeMp3"].arrayValue
		for wholeMp3Json in wholeMp3Array{
			let value = PRPoetryInfoWholeMp3(fromJson: wholeMp3Json)
			wholeMp3.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if appreciate != nil{
			dictionary["appreciate"] = appreciate.toDictionary()
		}
		if author != nil{
			dictionary["author"] = author.toDictionary()
		}
		if background != nil{
			dictionary["background"] = background
		}
		if id != nil{
			dictionary["id"] = id
		}
		if isPhonetic != nil{
			dictionary["isPhonetic"] = isPhonetic
		}
		if isorder != nil{
			dictionary["isorder"] = isorder
		}
		if knowledge != nil{
			var dictionaryElements = [[String:Any]]()
			for knowledgeElement in knowledge {
				dictionaryElements.append(knowledgeElement.toDictionary())
			}
			dictionary["knowledge"] = dictionaryElements
		}
		if mp4src != nil{
			dictionary["mp4src"] = mp4src.toDictionary()
		}
		if poem != nil{
			dictionary["poem"] = poem.toDictionary()
		}
		if poemDuring != nil{
			dictionary["poemDuring"] = poemDuring
		}
		if poetry != nil{
			dictionary["poetry"] = poetry.toDictionary()
		}
		if wholeMp3 != nil{
			var dictionaryElements = [[String:Any]]()
			for wholeMp3Element in wholeMp3 {
				dictionaryElements.append(wholeMp3Element.toDictionary())
			}
			dictionary["wholeMp3"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         appreciate = aDecoder.decodeObject(forKey: "appreciate") as? PRPoetryInfoAppreciate
         author = aDecoder.decodeObject(forKey: "author") as? PRPoetryInfoAuthor
         background = aDecoder.decodeObject(forKey: "background") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         isPhonetic = aDecoder.decodeObject(forKey: "isPhonetic") as? Bool
         isorder = aDecoder.decodeObject(forKey: "isorder") as? Bool
         knowledge = aDecoder.decodeObject(forKey: "knowledge") as? [PRPoetryInfoKnowledge]
         mp4src = aDecoder.decodeObject(forKey: "mp4src") as? PRPoetryInfoMp4src
         poem = aDecoder.decodeObject(forKey: "poem") as? PRPoetryInfoPoem
         poemDuring = aDecoder.decodeObject(forKey: "poemDuring") as? [Int]
         poetry = aDecoder.decodeObject(forKey: "poetry") as? PRPoetryInfoAppreciate
         wholeMp3 = aDecoder.decodeObject(forKey: "wholeMp3") as? [PRPoetryInfoWholeMp3]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if appreciate != nil{
			aCoder.encode(appreciate, forKey: "appreciate")
		}
		if author != nil{
			aCoder.encode(author, forKey: "author")
		}
		if background != nil{
			aCoder.encode(background, forKey: "background")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isPhonetic != nil{
			aCoder.encode(isPhonetic, forKey: "isPhonetic")
		}
		if isorder != nil{
			aCoder.encode(isorder, forKey: "isorder")
		}
		if knowledge != nil{
			aCoder.encode(knowledge, forKey: "knowledge")
		}
		if mp4src != nil{
			aCoder.encode(mp4src, forKey: "mp4src")
		}
		if poem != nil{
			aCoder.encode(poem, forKey: "poem")
		}
		if poemDuring != nil{
			aCoder.encode(poemDuring, forKey: "poemDuring")
		}
		if poetry != nil{
			aCoder.encode(poetry, forKey: "poetry")
		}
		if wholeMp3 != nil{
			aCoder.encode(wholeMp3, forKey: "wholeMp3")
		}

	}

}