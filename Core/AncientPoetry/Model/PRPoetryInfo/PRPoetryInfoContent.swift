//
//	PRPoetryInfoContent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class PRPoetryInfoContent : NSObject, NSCoding{

    var annotation : [PRPoetryInfoAnnotation]!
	var cutoff : [Int]!
	var label : String!
	var lableTime : [PRPoetryInfoLableTime]!
	var line : Int!
	var mask : [String]!
	var mp3 : String!
	var noVoiceLabel : String!
	var polyphone : [String]!
	var termOptions : [String]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        annotation = [PRPoetryInfoAnnotation]()
        let annotationArray = json["annotation"].arrayValue
        for annotationJson in annotationArray{
            let value = PRPoetryInfoAnnotation(fromJson: annotationJson)
            annotation.append(value)
        }
		cutoff = [Int]()
		let cutoffArray = json["cutoff"].arrayValue
		for cutoffJson in cutoffArray{
			cutoff.append(cutoffJson.intValue)
		}
		label = json["label"].stringValue
		lableTime = [PRPoetryInfoLableTime]()
		let lableTimeArray = json["lableTime"].arrayValue
		for lableTimeJson in lableTimeArray{
			let value = PRPoetryInfoLableTime(fromJson: lableTimeJson)
			lableTime.append(value)
		}
		line = json["line"].intValue
		mask = [String]()
		let maskArray = json["mask"].arrayValue
		for maskJson in maskArray{
			mask.append(maskJson.stringValue)
		}
		mp3 = json["mp3"].stringValue
		noVoiceLabel = json["noVoiceLabel"].stringValue
		polyphone = [String]()
		let polyphoneArray = json["polyphone"].arrayValue
		for polyphoneJson in polyphoneArray{
			polyphone.append(polyphoneJson.stringValue)
		}
		termOptions = [String]()
		let termOptionsArray = json["termOptions"].arrayValue
		for termOptionsJson in termOptionsArray{
			termOptions.append(termOptionsJson.stringValue)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if annotation != nil{
            var dictionaryElements = [[String:Any]]()
            for annotationElement in annotation {
                dictionaryElements.append(annotationElement.toDictionary())
            }
            dictionary["annotation"] = dictionaryElements
        }
		if cutoff != nil{
			dictionary["cutoff"] = cutoff
		}
		if label != nil{
			dictionary["label"] = label
		}
		if lableTime != nil{
			var dictionaryElements = [[String:Any]]()
			for lableTimeElement in lableTime {
				dictionaryElements.append(lableTimeElement.toDictionary())
			}
			dictionary["lableTime"] = dictionaryElements
		}
		if line != nil{
			dictionary["line"] = line
		}
		if mask != nil{
			dictionary["mask"] = mask
		}
		if mp3 != nil{
			dictionary["mp3"] = mp3
		}
		if noVoiceLabel != nil{
			dictionary["noVoiceLabel"] = noVoiceLabel
		}
		if polyphone != nil{
			dictionary["polyphone"] = polyphone
		}
		if termOptions != nil{
			dictionary["termOptions"] = termOptions
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         annotation = aDecoder.decodeObject(forKey: "annotation") as? [PRPoetryInfoAnnotation]
         cutoff = aDecoder.decodeObject(forKey: "cutoff") as? [Int]
         label = aDecoder.decodeObject(forKey: "label") as? String
         lableTime = aDecoder.decodeObject(forKey: "lableTime") as? [PRPoetryInfoLableTime]
         line = aDecoder.decodeObject(forKey: "line") as? Int
         mask = aDecoder.decodeObject(forKey: "mask") as? [String]
         mp3 = aDecoder.decodeObject(forKey: "mp3") as? String
         noVoiceLabel = aDecoder.decodeObject(forKey: "noVoiceLabel") as? String
         polyphone = aDecoder.decodeObject(forKey: "polyphone") as? [String]
         termOptions = aDecoder.decodeObject(forKey: "termOptions") as? [String]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
        if annotation != nil{
            aCoder.encode(annotation, forKey: "annotation")
        }
		if cutoff != nil{
			aCoder.encode(cutoff, forKey: "cutoff")
		}
		if label != nil{
			aCoder.encode(label, forKey: "label")
		}
		if lableTime != nil{
			aCoder.encode(lableTime, forKey: "lableTime")
		}
		if line != nil{
			aCoder.encode(line, forKey: "line")
		}
		if mask != nil{
			aCoder.encode(mask, forKey: "mask")
		}
		if mp3 != nil{
			aCoder.encode(mp3, forKey: "mp3")
		}
		if noVoiceLabel != nil{
			aCoder.encode(noVoiceLabel, forKey: "noVoiceLabel")
		}
		if polyphone != nil{
			aCoder.encode(polyphone, forKey: "polyphone")
		}
		if termOptions != nil{
			aCoder.encode(termOptions, forKey: "termOptions")
		}

	}

}
