//
//  ViewController.swift
//  CookieCollector
//
//  Created by Kyle Chadwick on 10/16/17.
//  Copyright © 2017 Kyle Chadwick. All rights reserved.
//

import UIKit
import ARKit
import Each
import SpriteKit

class ViewController: UIViewController {
    
    var timer = Each(1).seconds
    var countdown = 10
    var candyCount = 0
    var candyPositions = [1: (CGFloat(0.3), CGFloat(0.2)),
        2: (CGFloat(0.5), CGFloat(0.2)),
        3: (CGFloat(0.7), CGFloat(0.2)),
        4: (CGFloat(0.4), CGFloat(0.4)),
        5: (CGFloat(0.6), CGFloat(0.4)),
        6: (CGFloat(0.5), CGFloat(0.6))]
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var skView: SKView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //setup spritekit basket
        let basketScene = SKScene(size: skView.bounds.size)
        let basket = SKSpriteNode(imageNamed: "art.scnassets/bag.png")
        basketScene.backgroundColor = SKColor.clear
        basket.position = CGPoint(x: skView.bounds.width * 0.5, y: skView.bounds.height * 0.5)
        basketScene.addChild(basket)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.allowsTransparency = true
        basketScene.scaleMode = .resizeFill
        skView.presentScene(basketScene)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        // remove any existing nodes and restart timer (acting as a reset button)
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.restoreTimer()
        self.setTimer()
        // add candies to scene
        let blueCandyScene = SCNScene(named: "art.scnassets/candy_blue.scn")
        let blueCandyNode = blueCandyScene?.rootNode.childNode(withName: "candy_blue", recursively: false)
        self.sendCandy(node: blueCandyNode!)
        let orangeCandyScene = SCNScene(named: "art.scnassets/candy_orange.scn")
        let orangeCandyNode = orangeCandyScene?.rootNode.childNode(withName: "candy_orange", recursively: false)
        self.sendCandy(node: orangeCandyNode!)
        let yellowCandyScene = SCNScene(named: "art.scnassets/candy_yellow.scn")
        let yellowCandyNode = yellowCandyScene?.rootNode.childNode(withName: "candy_yellow", recursively: false)
        self.sendCandy(node: yellowCandyNode!)
    }
   
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! ARSCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            //print("didn't touch anything")
        } else {
            let result = hitTest.first!
            let nodeHit = result.node
            if let nodeName = result.node.geometry!.name {
                if nodeName == "candy_blue"{
                    self.restoreTimer()
                    candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                }
                if nodeName == "candy_orange" {
                    self.restoreTimer()
                    candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                }
                if nodeName == "candy_yellow" {
                    self.restoreTimer()
                    candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                }
            }
            else {
                return
            }
        }
    }
    
    func sendCandy(node: SCNNode) {
        // start candy at random position
        node.position = SCNVector3(randomNumbers(firstNum: -2, secondNum: 2),randomNumbers(firstNum: -1, secondNum: -2),randomNumbers(firstNum: -2, secondNum: 2))
        node.eulerAngles = SCNVector3(randomNumbers(firstNum: 0, secondNum: 2*CGFloat.pi), randomNumbers(firstNum: 0, secondNum: 2*CGFloat.pi), randomNumbers(firstNum: 0, secondNum: 2*CGFloat.pi))
        self.sceneView.scene.rootNode.addChildNode(node)
        // animate node
        let pulse = CABasicAnimation(keyPath: "scale")
        pulse.fromValue = node.scale
        pulse.toValue = SCNVector3((node.scale.x * 0.8), (node.scale.y * 0.8), (node.scale.z * 0.8))
        pulse.repeatCount = 10
        pulse.duration = 0.1
        pulse.autoreverses = true
        node.addAnimation(pulse, forKey: "scale")
    }
    
    // if candy is picked up, add corresponding 2d spritekit candy to basket
    func candyToBasket(nodeName: String) {
        //setup spritekit candy scene
        guard let skCandyScene = skView.scene else {return}
        //skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        skCandyScene.scaleMode = .resizeFill
        let candySize = CGSize(width: 40, height: 40)
        // iterate to get the position of the next piece of candy in the basket
        candyCount += 1
        print("candyCount = ", candyCount)
        if candyCount > 6 {
            timer.stop()
            timerLabel.text = "bag full, you win!"
            return
        }
        let (n,m) = candyPositions[candyCount]!
        let nextPosition = CGPoint(x: skView.bounds.width * n, y: skView.bounds.height * m)
        //add correct collored candy
        if nodeName == "candy_blue" {
            let candyBlue = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_blue.png")
            candyBlue.scale(to: candySize)
            candyBlue.position = nextPosition
            skCandyScene.addChild(candyBlue)
        }
        else if nodeName == "candy_orange" {
            let candyOrange = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_orange.png")
            candyOrange.scale(to: candySize)
            candyOrange.position = nextPosition
            skCandyScene.addChild(candyOrange)
        }
        else if nodeName == "candy_yellow" {
            let candyYellow = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_yellow.png")
            candyYellow.scale(to: candySize)
            candyYellow.position = nextPosition
            skCandyScene.addChild(candyYellow)
        }
        skView.presentScene(skCandyScene)
    }

    func setTimer() {
        self.timer.perform { () -> NextStep in
            self.countdown -= 1
            self.timerLabel.text = String(self.countdown)
            if self.countdown == 0 {
                self.timerLabel.text = "time is up, you lose"
                return .stop
            }
            return .continue
        }
    }
    
    func restoreTimer() {
        self.countdown = 10
        self.timerLabel.text = String(self.countdown)
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}

