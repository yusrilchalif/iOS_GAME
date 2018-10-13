//
//  Credit.swift
//  Nyalip
//
//  Created by teknologi game on 11/07/18.
//  Copyright © 2018 PENS Game Studio. All rights reserved.
//

import Foundation
import SpriteKit

class Credit: SKScene{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "backMenu"{
                let menuScene = MenuGame(fileNamed: "MenuGame")!
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
        }
    }
    
}

