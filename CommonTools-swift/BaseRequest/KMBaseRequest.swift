//
//  KMBaseRequest.swift
//  Kotmi
//
//  Created by zhy on 7/21/16.
//  Copyright © 2016 HangZhou WeiQun IT Co., Ltd. All rights reserved.
//

import Foundation


public class KMBaseRequest: NSObject {
    public var fields: NSMutableDictionary?
    public var httpType: NSString?
    public var apiUrl: NSString?
    
    public var success: successBlock?
    public var fail: failBlock?
    public var uploadProgress: fbUploadProgress?
    public var downloadProgress: fbDownloadProgress?
    
    public var files: NSArray?
    public var filesData: NSData?
    public var fileUploadKey: NSString?
    public var savedFilePath: NSString?
    public var requestType: NSNumber?
    
    public var timeoutInterval: NSTimeInterval?
    
    public var requestModel: NSString?
    
    private var operation: NSOperation?
    
    
    public var HOST: String
    public override init() {
        fields = NSMutableDictionary()
        requestType = 0
        
        
        HOST = "http://t.kotmi.com:9898/"
//        #if DEBUG
//           HOST = "http://t.kotmi.com:9898/"
//           HOST = "http://192.168.1.122:9898/"
//        HOST = "http://192.168.1.114:9898/"//selwyn server dbg
//        #else
//            HOST =  "http://m.kotmi.com/"
//        #endif
        super.init()
    }
    
    public func sendRequest() -> Void {
        if operation != nil && operation!.executing {
            return
        }
        httpType = ((httpType != nil) ? httpType : getHttpType())
        KMNetworkEngine.instance.timeoutInterval = timeoutInterval
        
        apiUrl = (apiUrl != nil) ? apiUrl : getApiUrl()
        if apiUrl == nil || (apiUrl?.isKindOfClass(NSNull))! {
            NSLog("api needed to request")
            return
        }
        
        if !(apiUrl!.hasPrefix("http://") || apiUrl!.hasPrefix("https://"))
        {
            apiUrl = NSString.init(format: "%@%@", HOST, apiUrl!)
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        operation = KMNetworkEngine.instance.httpRequest(httpType, URLString: apiUrl, parameters: fields, files: files, filesData:filesData, fileUploadKey: fileUploadKey, savedFilePath: savedFilePath, requestType: requestType, success: { (returnObject: AnyObject?) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if returnObject is NSDictionary {
                var errString : NSString?
                errString = returnObject?.objectForKey("error") as? NSString
                if ((errString != nil) && (errString!.isEqualToString("auth faild!") || errString!.isEqualToString("expired_token") ||
                    errString!.isEqualToString("invalid_access_token"))) {
                    NSNotificationCenter.defaultCenter().postNotificationName("NeedToReLogin", object: nil)
                    return
                }
            }
            if (!(returnObject is NSDictionary || returnObject is NSArray)) {
                self.fail?(returnObject)
                return
            }
            
            let tmpDic = returnObject as? NSDictionary
            
            if (self.apiUrl!.hasPrefix("https://api.weibo.com") || self.apiUrl!.hasPrefix("https://api.weixin.qq.com")) {
                self.success?(tmpDic)
                return
            }
            if tmpDic?.objectForKey("errorCode")?.intValue == -1 {
                
                if tmpDic?.objectForKey("isPaging")?.intValue == 0 {
                    let dataDict = tmpDic?.objectForKey("data")
                    if dataDict != nil {
                        if (self.requestModel != nil && (dataDict?.isKindOfClass(NSDictionary))!) {
                            self.success?(KMUtility.convertDictionaryToModel(dataDict! as! [NSObject : AnyObject], className: self.requestModel! as String))
                        } else if ((dataDict?.isKindOfClass(NSNull))!) {
                            self.fail?(returnObject)
                        } else {
                            self.success?(tmpDic)
                        }
                    }
                }
                else {
                    if (self.requestModel != nil) {
                        self.success?(KMUtility.convertDictionaryToModel(tmpDic! as [NSObject : AnyObject], className: self.requestModel! as String))
                    } else {
                        self.success?(tmpDic)
                    }
                }
                return
                
            } else {
                if tmpDic?.objectForKey("errorCode") != nil {
                    self.fail?(returnObject)
                    KMErrorCodeService.showErrorMessage(tmpDic?.objectForKey("errorCode"))
                } else {
                    self.fail?(returnObject)
                }
            }
            
            }, fail: { (error:AnyObject?) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.fail?(error)
                if error?.code == -1009 {
                    KMUtility.makeToast("网络无连接，请检查网络")
                } else {
                    KMErrorCodeService.showErrorMessage(error?.code)
                }
            }, uploadProgress: { (totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
                self.uploadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
            }, downloadProgress: { (totalBytesRead: Int64, totalBytesExpectedToRead: Int64) in
                self.downloadProgress?(totalBytesRead, totalBytesExpectedToRead)
        })
    }
    
    func getHttpType() -> NSString {
        return "POST"
    }
    func getApiUrl() -> NSString {
        return ""
    }
    func cancel() -> Void {
        if operation != nil {
            operation?.cancel()
        }
    }
}
