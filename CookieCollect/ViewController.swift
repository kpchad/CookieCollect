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
    
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //create spriteKit overlay to count points
        let basket = SKSpriteNode(imageNamed: "art.scnassets/bag.png")
        let overlayScene = SKScene(size: CGSize(width: 300, height: 500))
        // set the position for base object
        basket.position = CGPoint(x: 220, y: 70)
        //basket.anchorPoint = CGPoint(x: 1,y: 0)
        basket.zPosition = -1
        // add base object to scene
        overlayScene.addChild(basket)
        // set scene to overlay
        sceneView.overlaySKScene = overlayScene
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
        let blueCandyNode = blueCandyScene?.rootNode.childNode(withName: "candy", recursively: false)
        self.sendCandy(node: blueCandyNode!)
        let orangeCandyScene = SCNScene(named: "art.scnassets/candy_orange.scn")
        let orangeCandyNode = orangeCandyScene?.rootNode.childNode(withName: "candy", recursively: false)
        self.sendCandy(node: orangeCandyNode!)
        let dotsCandyScene = SCNScene(named: "art.scnassets/candy_dots.scn")
        let dotsCandyNode = dotsCandyScene?.rootNode.childNode(withName: "candy", recursively: false)
        self.sendCandy(node: dotsCandyNode!)
    }
   
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let results = hitTest.first!
            let node = results.node
            // add: if cany was touched:
                // overlayScene.addChild(candy)
                node.removeFromParentNode()
                self.sendCandy(node: node)
                self.restoreTimer()
            
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

