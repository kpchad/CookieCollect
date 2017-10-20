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
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        //self.setTimer()
        self.sendCookie() // repeat function until game is over[
        // count how much time has passed and start sendPumpkin after a certain amount of time has passed
        //self.sendPumpkin() // repeat function until game is over
        
    }
   
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            //let results = hitTest.first!
            //let node = results.node
        }
    }
    
    // restructure to send any 3d object, and animate it (pumpkin or cookie)
    func sendCookie() {
        // load cookie object
        let cookieScene = SCNScene(named: "art.scnassets/cookie.scn")
        let cookieNode = cookieScene?.rootNode.childNode(withName: "cookie", recursively: false)
        // start cookie at random position
        cookieNode?.position = SCNVector3(0,0,-3) // change to random start position
 //       cookieNode?.scale = SCNVector3(0.5, 0.5, 0.2)
        self.sceneView.scene.rootNode.addChildNode(cookieNode!)
        // animate cookie
        let slide = CABasicAnimation(keyPath: "position")
        slide.fromValue = cookieNode?.position
        slide.toValue = SCNVector3((cookieNode?.position.x)! + 10,(cookieNode?.position.y)!,
                                   (cookieNode?.position.z)!) // change to random direction
        slide.duration = 1
        //SCNTransaction.begin()
        cookieNode?.addAnimation(slide, forKey: "position")
        //SCNTransaction.completionBlock = {
        //  cookieNode?.removeFromParentNode()
        //}
        // remove object after animation
    }
}
