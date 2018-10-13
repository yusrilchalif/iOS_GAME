//
//  GameScene.swift
//  Nyalip
//
//  Yusril Chalif A
//  4210171004
//  Mekanika Game 1
//  Created by teknologi game on 24/05/18.
//  Copyright © 2018 PENS Game Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

    public var gold = 0
    public var goldIcon = SKLabelNode()

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()
    
    var canMove = false
    var leftToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    var centrePoint : CGFloat!
    var score = 0
//    var gold = 0
    var hp = 1
    
    let audioSource = SKAction.playSoundFileNamed("bgm_2.mp3", waitForCompletion: false);
    
    let leftCarMinimunX :CGFloat = -280
    let leftCarMaximumX :CGFloat = -100
    
    let rightCarMinimunX :CGFloat = 100
    let rightCarMaximumX :CGFloat = 280
    
    var countDown = 1
    var stopEverything = true
    
    var scoreText = SKLabelNode()
    var hpIcon = SKLabelNode()
    
    var time = Timer()
    
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        if let d = UserDefaults.standard.object(forKey: "hp") as? Int {
            hp = d
        }
        if let d = UserDefaults.standard.object(forKey: "gold") as? Int {
            gold = d
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        createRoadStrip()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector
            (GameScene.createRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector
            (GameScene.startCountDown), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumber(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumber(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector
            (GameScene.removeItems), userInfo: nil, repeats: true)
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime) {
            self.time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector
                (GameScene.increaseScore), userInfo: nil, repeats: true)
        }
    }
    
    //update pergerakan player
    override func update(_ currentTime: TimeInterval){
        if canMove{
            move(leftSide: leftToMoveLeft)
            moveRightCar(rightSide: rightCarToMoveRight)
        }
        showRoadStrip()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        
        if gameSettings.highScore < gold {
            gameSettings.highScore = gold
        }
        hp -= 1;
        
        hpIcon.text = String(hp)
        
        if hp == 0{
            time.invalidate()
            
            if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar"{
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            }else{
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
            
            let menuScene = MenuGame(fileNamed: "MenuGame")!
            menuScene.scaleMode = .aspectFill
            view?.presentScene(menuScene, transition: SKTransition.doorsOpenVertical(withDuration: TimeInterval(2)))
            
            
        }

        //afterCollision()
    }
    
    //variabel untuk move player kiri / kanan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if touchLocation.x > centrePoint{
                print("RIGHT CAR CLICKED")
                if rightCarAtLeft{
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                }else{
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                }
            }else{
                print("LEFT CAR CLICKED")
                if leftCarAtRight{
                    leftCarAtRight = false
                    leftToMoveLeft = true
                }else{
                    leftCarAtRight = true
                    leftToMoveLeft = false
                }
            }
            canMove = true
        }
    }

    func setUp(){
        
        run(audioSource);
        
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        centrePoint = self.frame.size.width / self.frame.size.height
        
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1
        rightCar.physicsBody?.collisionBitMask = 0
        
        //create score
        let scoreBackground = SKShapeNode(rect: CGRect(x:-self.size.width/2 + 120, y:self.size.height/2 - 300, width: 180, height: 80), cornerRadius: 20)
        scoreBackground.zPosition = 4
        scoreBackground.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackground.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackground)
        
        scoreText.name = "Score"
        scoreText.fontName = "AvenitNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 280)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
        
        //convert score ke gold
        let goldBackground = SKShapeNode(rect: CGRect(x:-self.size.width/2 + 120, y:self.size.height/2 - 400, width: 180, height: 80), cornerRadius: 20)
        goldBackground.zPosition = 4
        goldBackground.fillColor = SKColor.black.withAlphaComponent(0.3)
        goldBackground.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(goldBackground)
        
        goldIcon.name = "Gold"
        goldIcon.fontName = "AvenitNext-Bold"
        goldIcon.text = String(gold)
        goldIcon.fontColor = SKColor.white
        goldIcon.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 380)
        goldIcon.fontSize = 50
        goldIcon.zPosition = 4
        
        addChild(goldIcon)
        
        //membeli HP
        let hpBackground = SKShapeNode(rect: CGRect(x:-self.size.width/2 + 480, y:self.size.height/2 - 300, width: 180, height: 80), cornerRadius: 20)
        hpBackground.zPosition = 4
        hpBackground.fillColor = SKColor.black.withAlphaComponent(0.3)
        hpBackground.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(hpBackground)
        
        hpIcon.name = "Hp"
        hpIcon.fontName = "AvenitNext-Bold"
        hpIcon.fontColor = SKColor.white
        hpIcon.position = CGPoint(x: -self.size.width/2 + 520, y: self.size.height/2 - 280)
        hpIcon.text = String(hp)
        hpIcon.fontSize = 50
        hpIcon.zPosition = 4
        
        addChild(hpIcon)
    }
    
    //membuat animasi paralax untuk jalan
    @objc func createRoadStrip(){
        let leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
    }
    
    //fungsi untuk menampilkan area RoadStrip
    func showRoadStrip(){
        
        enumerateChildNodes(withName: "leftRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "rightRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "car1", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 15
        })
        
        enumerateChildNodes(withName: "car2", using: { (rightCar, stop) in
            let car = rightCar as! SKSpriteNode
            car.position.y -= 15
        })
    }
    
    @objc func removeItems(){
        for child in children{
            if child.position.y < -self.size.height - 100{
                child.removeFromParent()
            }
        }
    }
    
    //fungsi untuk pergerakan player
    func move(leftSide:Bool){
        if !leftSide {
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarMaximumX{
                leftCar.position.x = leftCarMaximumX
            }
        }
        else {
            leftCar.position.x += 20
            if leftCar.position.x > leftCarMinimunX{
                leftCar.position.x = leftCarMinimunX
            }
            
        }
    }
    
    func moveRightCar(rightSide:Bool){
        if rightSide{
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaximumX{
                rightCar.position.x = rightCarMaximumX
            }
        }else{
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinimunX{
                rightCar.position.x = rightCarMinimunX
            }
    }
   }
    
    @objc func leftTraffic(){
        if !stopEverything{
        let leftTrafficItem : SKSpriteNode!
        let randonNumber = Helper().randomBetweenTwoNumber(firstNumber: 1, secondNumber: 8)
        switch Int(randonNumber) {
        case 1...4:
            leftTrafficItem = SKSpriteNode(imageNamed: "car1")
            leftTrafficItem.name = "car1"
                break
        case 5...8:
                leftTrafficItem = SKSpriteNode(imageNamed: "car2")
                leftTrafficItem.name = "car2"
               break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "car1")
            leftTrafficItem.name = "car1"
        }
        leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y:0.5)
        leftTrafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumber(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem.position.x = -280
            break
        case 5...10:
            leftTrafficItem.position.x = -100
        default:
            leftTrafficItem.position.x = -280
        }
        leftTrafficItem.position.y = 700
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.affectedByGravity = false
        addChild(leftTrafficItem)
        }
    }
    
    @objc func rightTraffic(){
        if !stopEverything{
        let rightTrafficItem : SKSpriteNode!
        let randonNumber = Helper().randomBetweenTwoNumber(firstNumber: 1, secondNumber: 8)
        switch Int(randonNumber) {
        case 1...4:
            rightTrafficItem = SKSpriteNode(imageNamed: "car1")
            rightTrafficItem.name = "car1"
            break
        case 5...8:
            rightTrafficItem = SKSpriteNode(imageNamed: "car2")
            rightTrafficItem.name = "car2"
            break
        default:
            rightTrafficItem = SKSpriteNode(imageNamed: "car1")
            rightTrafficItem.name = "car1"
        }
        rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y:0.5)
        rightTrafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumber(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            rightTrafficItem.position.x = 280
            break
        case 5...10:
            rightTrafficItem.position.x = 100
        default:
            rightTrafficItem.position.x = 280
        }
        rightTrafficItem.position.y = 700
        rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
        rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER_1
        rightTrafficItem.physicsBody?.affectedByGravity = false
        addChild(rightTrafficItem)
        }
    }
    
    func afterCollision(){
        if gameSettings.highScore < score {
            gameSettings.highScore = score
        }
        let menuScene = MenuGame(fileNamed: "MenuGame")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsOpenVertical(withDuration: TimeInterval(2)))
    }
    
    @objc func startCountDown(){
        if countDown > 0{
            if countDown < 4 {
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenitNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.zPosition = 300
                countDownLabel.name = "gameStart"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countDownLabel.removeFromParent()
                })
                }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
            
            }
        }
    

    @objc func increaseScore(){
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
            
            //mengubah tiap 5 score mendapat 1 gold
            if score % 5 == 0 {
                gold += 1
                goldIcon.text = "\(gold)"
                
                //jika hp bertambah maka gold berkurang
                //if hp / 3 == 0{
                //    gold -= 1
                //    goldIcon.text = "\(gold)"
                //}
                
                //menambah jumlah HP
                if gold % 3 == 0{
                    hp += 1
                    hpIcon.text = "\(hp)"
                }
            }
            
            UserDefaults.standard.set(gold, forKey: "gold")
        }
    }
}



