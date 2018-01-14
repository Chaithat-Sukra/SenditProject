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
    
    private let urlString: String!
    private var sessionManager = Alamofire.SessionManager()

    init() {
        let fileName = Bundle.main.infoDictionary?["URL"] as! String
        self.urlString = fileName
    }
    
    func requestGET(_ aEndPoint: String, aCompletion: @escaping(ObjectEvent) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)

        self.sessionManager.request(
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
                
                if let value = response.result.value as? [[String: Any]] {
                    event.isSuccessful = true
                    event.result = value
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                aCompletion(event)
        }
    }
}
