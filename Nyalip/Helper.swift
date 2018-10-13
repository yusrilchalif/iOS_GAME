//
//  Helper.swift
//  Nyalip
//
//  Created by teknologi game on 07/06/18.
//  Copyright © 2018 PENS Game Studio. All rights reserved.
//

import Foundation
import UIKit

struct ColliderType {
    static let CAR_COLLIDER : UInt32 = 0
    static let ITEM_COLLIDER : UInt32 = 1
    static let ITEM_COLLIDER_1 : UInt32 = 2
}

class Helper : NSObject{
    
    func randomBetweenTwoNumber(firstNumber : CGFloat, secondNumber : CGFloat) -> CGFloat{
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}

class Settings{
    static let sharedInstance = Settings()
    
    private init(){
        
    }
        var highScore = 0
    }

