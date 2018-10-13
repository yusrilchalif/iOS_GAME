//
//  MenuGame.swift
//  Nyalip
//
//  Created by teknologi game on 09/07/18.
//  Copyright © 2018 PENS Game Studio. All rights reserved.
//

import Foundation
import SpriteKit

class MenuGame: SKScene{
    
    var gameStart = SKLabelNode()
    var bestScore = SKLabelNode()
    var buyHp = SKLabelNode()
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y:0.5)
        gameStart = self.childNode(withName: "gameStart") as! SKLabelNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        
        if let d = UserDefaults.standard.object(forKey: "gold") as? Int {
            
            bestScore.text = "Your Gold: \(d)"
        }
        else {
            bestScore.text = "Your Gold: 0"
        }
        

//        gold = UserDefaults.standard.integer(forKey: "gold")
        
        if UserDefaults.standard.object(forKey: "hp") == nil {
            UserDefaults.standard.set(1, forKey: "hp")
        }
        if UserDefaults.standard.object(forKey: "gold") == nil {
            UserDefaults.standard.set(0, forKey: "gold")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "gameStart"{
                let menuScene = GameScene(fileNamed: "GameScene")!
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
            
            if atPoint(touchLocation).name == "creditScene"{
                let menuScene = Credit(fileNamed: "Credit1")!
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
            
            if atPoint(touchLocation).name == "buyHp"{
                let menuScene = MarketScene(fileNamed: "MarketScene")!
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
            }
            
            if atPoint(touchLocation).name == "exit"{
                exit(0);
            }
        }
        
    }
}



