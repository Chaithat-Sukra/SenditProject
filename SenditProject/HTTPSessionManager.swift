//
//  HTTPSessionManager.swift
//  COSC2471
//
//  Created by Chaithat Sukra on 30/07/2017.
//  Copyright © 2017 Chaithat Sukra. All rights reserved.
//

import Foundation
import Alamofire

class HTTPSessionManager {
    
    public let urlString: String!
    
    init() {
        self.urlString = "http://localhost:5000/"
    }
    
    func requestGET(_ aEndPoint: String, aCompletion: @escaping(ObjectEvent) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Alamofire.request(
            URL(string: self.urlString + aEndPoint)!,
            method: .get,
            parameters: nil)
            .validate()
            .responseJSON { (response) -> Void in
                
                let event: ObjectEvent = ObjectEvent()
                event.isSuccessful = false
                
                guard response.result.isSuccess else {
                    print("error fetching: \(String(describing: response.result.error))")
                    
                    event.resultMessage = response.result.error?.localizedDescription
                    aCompletion(event)
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    return
                }
                
                if let value = response.result.value as? [String: Any] {
                    let isStatusOK = value["status"] as? Bool
                    event.isSuccessful = isStatusOK!
                    event.result = value
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                aCompletion(event)
        }
    }
}
