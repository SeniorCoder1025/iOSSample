//
//  Deliver.swift
//  iOSSample
//
//  Created by apple on 9/19/18.
//  Copyright © 2018 ken. All rights reserved.
//

import UIKit

class Deliver: NSObject {
    var id: Int64 = 0
    var desc: String = ""
    var imageUrl: String = ""
    var lng: Double = 0
    var lat: Double = 0
    var address: String = ""
    override init() {
        super.init()
    }
}
