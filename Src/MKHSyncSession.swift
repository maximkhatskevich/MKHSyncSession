//
//  MKHSyncSession.swift
//  MKHSyncSession
//
//  Created by Maxim Khatskevich on 3/22/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//
//  Inspired by http://ericasadun.com/2015/11/12/more-bad-things-synchronous-nsurlsessions/
//  See also: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/

//===

public typealias DataTaskResult =
    (data: NSData?, response: NSURLResponse?, error: NSError?)

//===

public extension NSURLSession
{
    /// Return data from synchronous URL request
    public func requestSyncData(request: NSURLRequest) -> DataTaskResult
    {
        // dataTaskWithRequest(
        //      request: NSURLRequest,
        //      completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) 
        // -> NSURLSessionDataTask
        
        //===
        
        var result: DataTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.dataTaskWithRequest(
            request,
            completionHandler: { (data, response, error) in
        
                result = (data, response, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
}
