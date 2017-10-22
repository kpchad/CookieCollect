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

class ViewController: UIViewController {
    
    var timer = Each(1).seconds
    var countdown = 10
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        self.setTimer()
        // load cookie
        let cookieScene = SCNScene(named: "art.scnassets/cookie.scn")
        let cookieNode = cookieScene?.rootNode.childNode(withName: "cookie", recursively: false)
        self.sendCandy(node: cookieNode!)
        // adding more cookies VV not working
        self.sendCandy(node: cookieNode!)
        self.sendCandy(node: cookieNode!)
        self.sendCandy(node: cookieNode!)
        self.sendCandy(node: cookieNode!)
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
            node.removeFromParentNode()
            self.sendCandy(node: node)
            self.restoreTimer()
        }
    }
    
    func sendCandy(node: SCNNode) {
        // start candy at random position
        node.position = SCNVector3(randomNumbers(firstNum: -10, secondNum: 10),randomNumbers(firstNum: 0, secondNum: -10),randomNumbers(firstNum: -10, secondNum: 10))
        self.sceneView.scene.rootNode.addChildNode(node)
        // animate node
        let pulse = CABasicAnimation(keyPath: "scale")
        pulse.fromValue = node.scale
        pulse.toValue = SCNVector3((node.scale.x * 0.8), (node.scale.y * 0.8), (node.scale.z * 0.8))
        pulse.repeatCount = 2
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

