//
//  CTBaseRequest.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

import Foundation


open class CTBaseRequest: NSObject {
    open var fields: NSMutableDictionary?
    open var httpType: String?
    open var apiUrl: String?
    
    open var success: successBlock?
    open var fail: failBlock?
    open var uploadProgress: CTUploadProgress?
    open var downloadProgress: CTDownloadProgress?
    
    open var files: NSArray?
    open var filesData: Data?
    open var fileUploadKey: NSString?
    open var savedFilePath: NSString?
    open var requestType: NSNumber?
    
    open var timeoutInterval: TimeInterval?
    
    open var requestModel: NSString?
    
    fileprivate var operation: Operation?
    
    public override init() {
        fields = NSMutableDictionary()
        requestType = 0

        super.init()
    }
    
    open func setHttpHeader(parameters: [String : String]) {
        var requestSerializer = CTNetworkEngine.instance.operationManager.requestSerializer
        for (key, value) in parameters {
            requestSerializer?.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    open func sendRequest() -> Void {
        if operation != nil && operation!.isExecuting {
            return
        }
        httpType = ((httpType != nil) ? httpType : getHttpType())
        CTNetworkEngine.instance.timeoutInterval = timeoutInterval
        
        apiUrl = (apiUrl != nil) ? apiUrl : getApiUrl()
        if apiUrl == nil || (apiUrl?.isKind(of: NSNull.self))! {
            NSLog("api needed to request")
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        operation = CTNetworkEngine.instance.httpRequest(httpType, URLString: apiUrl, parameters: fields, files: files, filesData:filesData, fileUploadKey: fileUploadKey, savedFilePath: savedFilePath, requestType: requestType, success: { (returnObject: Any?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if (!(returnObject is NSDictionary || returnObject is NSArray)) {
                self.fail?(returnObject)
                return
            }
            
            let tmpDic = returnObject as? NSDictionary
            
            self.success?(tmpDic)
            
            }, fail: { (error:Any?) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.fail?(error)
            }, uploadProgress: { (totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
                self.uploadProgress?(totalBytesWritten, totalBytesExpectedToWrite)
            }, downloadProgress: { (totalBytesRead: Int64, totalBytesExpectedToRead: Int64) in
                self.downloadProgress?(totalBytesRead, totalBytesExpectedToRead)
        })
    }
    
    open func getHttpType() -> String {
        return "POST"
    }
    open func getApiUrl() -> String {
        return ""
    }
    open func cancel() -> Void {
        if operation != nil && operation!.isExecuting {
            operation?.cancel()
        }
    }
    open func isExecuting() -> Bool {
        if operation == nil {
            return false
        }
        return operation!.isExecuting
    }
}
