//
//  Networking.swift
//  PEPRead
//
//  Created by 李沛倬 on 2020/2/12.
//  Copyright © 2020 PEP. All rights reserved.
//

import Foundation



class Networking {
    //+ (void)postWithPath:(NSString *)path arrayBody:(NSArray *)arrayBody success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
    class func postArr(with url: String!, params: Array<Any>, success: ((Any) -> Void)?, fail: ((Error) -> Void)?){
        PRHttpUtil.post(withPath: url, arrayBody: params, success: {(JSON) in
            if let succ = success {
                succ(JSON!)
            }
        }, failure: {(error) in
            if let failed = fail {
                failed(error!)
            }
        })
    }
    class func postDic(with url: String!, params: Dictionary<String,Any>, success: ((Any) -> Void)?, fail: ((Error) -> Void)?){
        PRHttpUtil.post(withPath: url, dicBody: params, success: {(JSON) in
            if let succ = success {
                succ(JSON!)
            }
        }, failure: {(error) in
            if let failed = fail {
                failed(error!)
            }
        })
    }
    class func post(with url: String!, params: [String: Any]?, success: ((Any) -> Void)?, fail: ((Error) -> Void)?) {
        PEPHttpRequestAgent.post(withUrl: url, params: params, refreshRequest: false, useCache: false, progressBlock: { (current, total) in
            
        }, successBlock: { (responese: Any?) in
            if let succ = success {
                succ(responese!)
            }
        }) { (error) in
            if let failed = fail {
                failed(error!)
            }
        }
    }
    class func postWithHttpResponse(with url: String!, params: [String: Any]?, success: ((Any) -> Void)?, fail: ((Error) -> Void)?) {
//        PEPHttpRequestAgent.postHTTPResponder(withUrl: url, params: params, progressBlock: nil) { (responese: Any?) in
//            if let succ = success {
//                succ(responese!)
//            }
//        } fail: { (error) in
//            if let failed = fail {
//                failed(error!)
//            }
//        }
        PRHttpUtil.post(withPath: url, params: params) { json in
            if let succ = success {
                succ(json!)
            }
        } failure: { (error) in
            if let failed = fail {
                failed(error!)
            }
        }


//        PEPHttpRequestAgent.post(withUrl: url, params: params, refreshRequest: false, useCache: false, progressBlock: { (current, total) in
//            
//        }, successBlock: { (responese: Any?) in
//            if let succ = success {
//                succ(responese!)
//            }
//        }) { (error) in
//            if let failed = fail {
//                failed(error!)
//            }
//        }
    }
    
    class func get<T: Collection>(succ: @escaping (T) -> Void) {
        
    }
    
    class func get(with url: String!, params: [String: Any]?, success: ((Any) -> Void)?, fail: ((Error) -> Void)?) {
        PEPHttpRequestAgent.getWithUrl(url, params: params, refreshRequest: false, useCache: false, progressBlock: { (current, total) in
            
        }, successBlock: { (responese: Any?) in
            if let succ = success {
                succ(responese!)
            }
        }) { (error) in
            if let failed = fail {
                failed(error!)
            }
        }
        
    }
    
    
}
