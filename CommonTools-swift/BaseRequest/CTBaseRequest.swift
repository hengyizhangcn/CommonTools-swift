//
//  CTBaseRequest.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

import Foundation


public class CTBaseRequest: NSObject {
    public var fields: NSMutableDictionary?
    public var httpType: NSString?
    public var apiUrl: NSString?
    
    public var success: successBlock?
    public var fail: failBlock?
    public var uploadProgress: CTUploadProgress?
    public var downloadProgress: CTDownloadProgress?
    
    public var files: NSArray?
    public var filesData: NSData?
    public var fileUploadKey: NSString?
    public var savedFilePath: NSString?
    public var requestType: NSNumber?
    
    public var timeoutInterval: NSTimeInterval?
    
    public var requestModel: NSString?
    
    private var operation: NSOperation?
    
    public override init() {
        fields = NSMutableDictionary()
        requestType = 0

        super.init()
    }
    
    public func sendRequest() -> Void {
        if operation != nil && operation!.executing {
            return
        }
        httpType = ((httpType != nil) ? httpType : getHttpType())
        CTNetworkEngine.instance.timeoutInterval = timeoutInterval
        
        apiUrl = (apiUrl != nil) ? apiUrl : getApiUrl()
        if apiUrl == nil || (apiUrl?.isKindOfClass(NSNull))! {
            NSLog("api needed to request")
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        operation = CTNetworkEngine.instance.httpRequest(httpType, URLString: apiUrl, parameters: fields, files: files, filesData:filesData, fileUploadKey: fileUploadKey, savedFilePath: savedFilePath, requestType: requestType, success: { (returnObject: AnyObject?) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if (!(returnObject is NSDictionary || returnObject is NSArray)) {
                self.fail?(returnObject)
                return
            }
            
            let tmpDic = returnObject as? NSDictionary
            
            self.success?(tmpDic)
            
            }, fail: { (error:AnyObject?) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.fail?(error)
            }, uploadProgress: { (totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
                self.uploadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
            }, downloadProgress: { (totalBytesRead: Int64, totalBytesExpectedToRead: Int64) in
                self.downloadProgress?(totalBytesRead, totalBytesExpectedToRead)
        })
    }
    
    public func getHttpType() -> NSString {
        return "POST"
    }
    public func getApiUrl() -> NSString {
        return ""
    }
    public func cancel() -> Void {
        if operation != nil {
            operation?.cancel()
        }
    }
}
