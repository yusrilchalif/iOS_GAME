//
//  Credit.swift
//  Nyalip
//
//  Created by teknologi game on 11/07/18.
//  Copyright © 2018 PENS Game Studio. All rights reserved.
//

import Foundation
import SpriteKit

class MarketScene: SKScene{
    var hp: Int = 0
//    var gold: Int = 0
    
    
//    var txtGold: SKLabelNode?
    
    override func didMove(to view: SKView) {
        if let d = UserDefaults.standard.object(forKey: "gold") as? Int {
            gold = d
        }
        
        if let d = UserDefaults.standard.object(forKey: "hp") as? Int {
            hp = d
        }
        
        goldIcon = (childNode(withName: "yourGold") as? SKLabelNode)!
        goldIcon.text = String(gold)
    }
    
//    override func didMove(to view: SKView) {
//        goldIcon = childNode(withName: "goldIcon") as? SKLabelNode;
//        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "backMenu"{
                let menuScene = MenuGame(fileNamed: "MenuGame")!
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
            else if atPoint(touchLocation).name == "goldThree"{
                if(gold >= 3) {
                    print("Add 1 health")
                    gold -= 3
                    hp += 1
                    goldIcon.text = String(gold)
                    
                    UserDefaults.standard.set(gold, forKey: "gold")
                    UserDefaults.standard.set(hp, forKey: "hp")
                }
                
            }
            else if atPoint(touchLocation).name == "goldFive"{
                if(gold >= 5) {
                    print("Add 2 health")
                    gold -= 5
                    hp += 2
                    goldIcon.text = String(gold)
                    
                    UserDefaults.standard.set(gold, forKey: "gold")
                    UserDefaults.standard.set(hp, forKey: "hp")
                }
                
            }
        }
    }
}

