//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
@objcMembers
class PRPoetryModelData : NSObject, NSCoding{

    var audioPath : String!
    var bookId : String!
    var chapterId : String!
    var dynastyName : String!
    var firstSentence : String!
    var genre : Int = 0
    var genreName : String!
    var id : String!
    var duration: Int = 0
    var img_url : String!
    var pad_img_url : String!
    var indexPath : String!
    var title : String!
    var writer : String!
    
    //课程内新增
    var start_page: Int = 0
    var end_page: Int = 0
//    var gscID:String!//在oc中使用
    
    var book_chapter_id : String!

    override init() {
        
    }
    class func handleData(dic: NSDictionary) -> PRPoetryModelData{
        
        let model = PRPoetryModelData()
        if let id = dic["id"] as? String{
            model.id = id
        }
        if let bookId = dic["book_id"] as? String{
            model.bookId = bookId
        }
        if let chapter_id = dic["chapter_id"] as? String{
            model.chapterId = chapter_id
        }
        if let title = dic["title"] as? String{
            model.title = title
        }
        if let firstSentence = dic["first_sentence"] as? String{
            model.firstSentence = firstSentence
        }
        if let dynastyName = dic["dynasty_name"] as? String{
            model.dynastyName = dynastyName
        }
        if let genre = dic["genre"] as? Int{
            model.genre = genre
        }
        if let genreName = dic["genre_name"] as? String{
            model.genreName = genreName
        }
        if let indexPath = dic["index_path"] as? String{
            model.indexPath = indexPath
        }
        if let audioPath = dic["audio_path"] as? String{
            model.audioPath = audioPath
        }
        if let img_url = dic["img_url"] as? String{
            model.img_url = img_url
        }
        if let pad_img_url = dic["pad_img_url"] as? String{
            model.pad_img_url = pad_img_url
        }
        if let duration = dic["duration"] as? Int{
            model.duration = duration
        }
        if let book_chapter_id = dic["book_chapter_id"] as? String{
            model.book_chapter_id = book_chapter_id
        }
        if let start_page = dic["start_page"] as? Int{
            model.start_page = start_page
        }
        if let end_page = dic["end_page"] as? Int{
            model.end_page = end_page
        }
        return model
       
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
     init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        start_page = json["start_page"].intValue
        end_page = json["end_page"].intValue
        indexPath = json["index_path"].stringValue
        audioPath = json["audio_path"].stringValue
        title = json["title"].stringValue
        bookId = json["book_id"].stringValue
        chapterId = json["chapter_id"].stringValue
        genreName = json["genre_name"].stringValue
        
        img_url = json["img_url"].stringValue
        pad_img_url = json["pad_img_url"].stringValue
        dynastyName = json["dynasty_name"].stringValue
        firstSentence = json["first_sentence"].stringValue
        duration = json["duration"].intValue
        genre = json["genre"].intValue
        //book_chapter_id
        book_chapter_id = json["book_chapter_id"].stringValue
        writer = json["writer"].stringValue
    }
    
//新加一个 model转 dic
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if audioPath != nil{
            dictionary["audio_path"] = audioPath
        }
        if bookId != nil{
            dictionary["book_id"] = bookId
        }
        if chapterId != nil{
            dictionary["chapter_id"] = chapterId
        }
        if dynastyName != nil{
            dictionary["dynasty_name"] = dynastyName
        }
        if firstSentence != nil{
            dictionary["first_sentence"] = firstSentence
        }
        
        dictionary["genre"] = genre
        
        if genreName != nil{
            dictionary["genre_name"] = genreName
        }
        if id != nil{
            dictionary["id"] = id
        }
        dictionary["duration"] = duration
        if img_url != nil{
            dictionary["img_url"] = img_url
        }
        if pad_img_url != nil{
            dictionary["pad_img_url"] = pad_img_url
        }
        if indexPath != nil{
            dictionary["index_path"] = indexPath
        }
        if title != nil{
            dictionary["title"] = title
        }
        if writer != nil{
            dictionary["writer"] = writer
        }
        
        dictionary["end_page"] = end_page
        
        
        dictionary["start_page"] = start_page
        
        if book_chapter_id != nil{
            dictionary["book_chapter_id"] = book_chapter_id
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         audioPath = aDecoder.decodeObject(forKey: "audio_path") as? String
         bookId = aDecoder.decodeObject(forKey: "book_id") as? String
         chapterId = aDecoder.decodeObject(forKey: "chapter_id") as? String
         dynastyName = aDecoder.decodeObject(forKey: "dynasty_name") as? String
         firstSentence = aDecoder.decodeObject(forKey: "first_sentence") as? String
         genre = aDecoder.decodeObject(forKey: "genre") as! Int
         genreName = aDecoder.decodeObject(forKey: "genre_name") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         
         indexPath = aDecoder.decodeObject(forKey: "index_path") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String
         writer = aDecoder.decodeObject(forKey: "writer") as? String
        start_page = aDecoder.decodeObject(forKey: "start_page") as! Int
        end_page = aDecoder.decodeObject(forKey: "end_page") as! Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if audioPath != nil{
            aCoder.encode(audioPath, forKey: "audio_path")
        }
        if bookId != nil{
            aCoder.encode(bookId, forKey: "book_id")
        }
        if chapterId != nil{
            aCoder.encode(chapterId, forKey: "chapter_id")
        }
        if dynastyName != nil{
            aCoder.encode(dynastyName, forKey: "dynasty_name")
        }
        if firstSentence != nil{
            aCoder.encode(firstSentence, forKey: "first_sentence")
        }
        
            aCoder.encode(genre, forKey: "genre")
        
        if genreName != nil{
            aCoder.encode(genreName, forKey: "genre_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
       
        if indexPath != nil{
            aCoder.encode(indexPath, forKey: "index_path")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if writer != nil{
            aCoder.encode(writer, forKey: "writer")
        }
        
            aCoder.encode(start_page, forKey: "start_page")
        
        
        
            aCoder.encode(end_page, forKey: "end_page")
        

    }

}

class PRPoetryModelResult : NSObject, NSCoding{

    var data : [PRPoetryModelData]!
    var fascicule : String!
    var fasciculeName : String!
    var nj : Int!
    var njName : String!
    var isFold: Bool! = true
    var thumbnail: String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        data = [PRPoetryModelData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = PRPoetryModelData(fromJson: dataJson)
            data.append(value)
        }
        fascicule = json["fascicule"].stringValue
        fasciculeName = json["fascicule_name"].stringValue
        nj = json["nj"].intValue
        njName = json["nj_name"].stringValue
        thumbnail = json["thumbnail"].stringValue
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if fascicule != nil{
            dictionary["fascicule"] = fascicule
        }
        if fasciculeName != nil{
            dictionary["fascicule_name"] = fasciculeName
        }
        if nj != nil{
            dictionary["nj"] = nj
        }
        if njName != nil{
            dictionary["nj_name"] = njName
        }
        if thumbnail != nil{
            dictionary["thumbnail"] = thumbnail
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         data = aDecoder.decodeObject(forKey: "data") as? [PRPoetryModelData]
         fascicule = aDecoder.decodeObject(forKey: "fascicule") as? String
         fasciculeName = aDecoder.decodeObject(forKey: "fascicule_name") as? String
         nj = aDecoder.decodeObject(forKey: "nj") as? Int
         njName = aDecoder.decodeObject(forKey: "nj_name") as? String
         thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if fascicule != nil{
            aCoder.encode(fascicule, forKey: "fascicule")
        }
        if fasciculeName != nil{
            aCoder.encode(fasciculeName, forKey: "fascicule_name")
        }
        if nj != nil{
            aCoder.encode(nj, forKey: "nj")
        }
        if njName != nil{
            aCoder.encode(njName, forKey: "nj_name")
        }
        if thumbnail != nil{
            aCoder.encode(thumbnail, forKey: "thumbnail")
        }

    }

}



class PRPoetryModel : NSObject, NSCoding{

	var errcode : String!
	var errmsg : String!
//	var result : [PRPoetryModelResult]!

    var result : [PRPoetryModelData]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		errcode = json["errcode"].stringValue
		errmsg = json["errmsg"].stringValue
		result = [PRPoetryModelData]()
		let resultArray = json["result"].arrayValue
		for resultJson in resultArray{
			let value = PRPoetryModelData(fromJson: resultJson)
			result.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if errcode != nil{
			dictionary["errcode"] = errcode
		}
		if errmsg != nil{
			dictionary["errmsg"] = errmsg
		}
		if result != nil{
			var dictionaryElements = [[String:Any]]()
			for resultElement in result {
				dictionaryElements.append(resultElement.toDictionary())
			}
			dictionary["result"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         errcode = aDecoder.decodeObject(forKey: "errcode") as? String
         errmsg = aDecoder.decodeObject(forKey: "errmsg") as? String
         result = aDecoder.decodeObject(forKey: "result") as? [PRPoetryModelData]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if errcode != nil{
			aCoder.encode(errcode, forKey: "errcode")
		}
		if errmsg != nil{
			aCoder.encode(errmsg, forKey: "errmsg")
		}
		if result != nil{
			aCoder.encode(result, forKey: "result")
		}

	}

}


class PRPoetrySearchResultModel : NSObject, NSCoding{

    var errcode : String!
    var errmsg : String!
    var result : [PRPoetryModelData]!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        errcode = json["errcode"].stringValue
        errmsg = json["errmsg"].stringValue
        result = [PRPoetryModelData]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = PRPoetryModelData(fromJson: resultJson)
            result.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if errcode != nil{
            dictionary["errcode"] = errcode
        }
        if errmsg != nil{
            dictionary["errmsg"] = errmsg
        }
        if result != nil{
            var dictionaryElements = [[String:Any]]()
            for resultElement in result {
                dictionaryElements.append(resultElement.toDictionary())
            }
            dictionary["result"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         errcode = aDecoder.decodeObject(forKey: "errcode") as? String
         errmsg = aDecoder.decodeObject(forKey: "errmsg") as? String
         result = aDecoder.decodeObject(forKey: "result") as? [PRPoetryModelData]

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if errcode != nil{
            aCoder.encode(errcode, forKey: "errcode")
        }
        if errmsg != nil{
            aCoder.encode(errmsg, forKey: "errmsg")
        }
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }

    }

}
