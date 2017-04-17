//
//  BasicModel.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/17.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

class BasicModel: NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
