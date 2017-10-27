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
        
        let basketScene = SKScene(size: skView.bounds.size)
        let basket = SKSpriteNode(imageNamed: "art.scnassets/bag.png")
        basketScene.backgroundColor = SKColor.clear
        basket.position = CGPoint(x: skView.bounds.width * 0.5, y: skView.bounds.height * 0.5)
        basketScene.addChild(basket)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
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
        let blueCandyNode = blueCandyScene?.rootNode.childNode(withName: "candyBlue", recursively: false)
        self.sendCandy(node: blueCandyNode!)
        let orangeCandyScene = SCNScene(named: "art.scnassets/candy_orange.scn")
        let orangeCandyNode = orangeCandyScene?.rootNode.childNode(withName: "candyOrange", recursively: false)
        self.sendCandy(node: orangeCandyNode!)
        let dotsCandyScene = SCNScene(named: "art.scnassets/candy_dots.scn")
        let dotsCandyNode = dotsCandyScene?.rootNode.childNode(withName: "candyDots", recursively: false)
        self.sendCandy(node: dotsCandyNode!)
    }
   
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! ARSCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let result = hitTest.first!
            let nodeHit = result.node
            if let nodeName = result.node.geometry!.name {
                if nodeName == "candyBlue"{
                    print("blue")
                    self.candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                    self.restoreTimer()
                }
                if nodeName == "candyOrange" {
                    print("orange")
                    self.candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                    self.restoreTimer()
                }
                if nodeName == "candyDots" {
                    print("Dots")
                    self.candyToBasket(nodeName: nodeName)
                    nodeHit.removeFromParentNode()
                    self.sendCandy(node: nodeHit)
                    self.restoreTimer()
                }
                //sceneView.overlaySKScene = overlayScene
            }
            else {
                return
            }
            //overlayScene.addChild(candy)
            
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
    
    func candyToBasket(nodeName: String) {
        print("function called")
    }

    func setTimer() {
        self.timer.perform { () -> NextStep in
            self.countdown -= 1
            self.timerLabel.text = String(self.countdown)
            if self.countdown == 0 {
                self.timerLabel.text = "you lose"
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

