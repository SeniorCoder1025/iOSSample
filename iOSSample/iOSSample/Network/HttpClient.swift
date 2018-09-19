//
//  HttpClient.swift
//  iOSSample
//
//  Created by apple on 9/19/18.
//  Copyright © 2018 ken. All rights reserved.
//

import Alamofire

class HttpClient {
    static let BASE_URL = "https://mock-api-mobile.dev.lalamove.com/"
    class func getDelivers(offset:Int, limit: Int, callback: @escaping (_ deliverList: [Deliver]) -> Void) {
        Alamofire.request("\(BASE_URL)deliveries?offset=\(offset)&limit=\(limit)")
            .responseJSON { (response) in
                var delivers = [Deliver]()
                let deliverTable = DeliverTable.shared
                switch response.result {
                case .success:
                    if let array = response.result.value as? [[String: Any]] {
                        for json in array {
                            let deliver = Deliver()
                            deliver.id = (json["id"] as? Int64)!
                            deliver.desc = (json["description"] as? String)!
                            deliver.imageUrl = (json["imageUrl"] as? String)!
                            let location = json["location"] as! [String: Any]
                            deliver.lng = (location["lng"] as? Double)!
                            deliver.lat = (location["lat"] as? Double)!
                            deliver.address = (location["address"] as? String)!
                            delivers.append(deliver)
                            deliverTable.insertDeliver(deliver: deliver)
                        }
                        callback(delivers)
                    }else{
                        print("Fail")
                        callback(deliverTable.getDelivers(offset: offset, limit: limit))
                    }
                case .failure(let e):
                    print(e)
                    callback(deliverTable.getDelivers(offset: offset, limit: limit))
                }
        }
    }
}
