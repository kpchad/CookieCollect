//
//  GameScene.swift
//  CookieCollect
//
//  Created by Kyle Chadwick on 10/25/17.
//  Copyright © 2017 Kyle Chadwick. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let basket = SKSpriteNode(imageNamed: "art.scnassets/bag.png")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.clear
        basket.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(basket)
    }
    
    func candyToBasket () {
        //let overlayScene = SKScene(size: CGSize(width: 300, height: 500))
        let candyBlue = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_blue.png")
        //let candyOrange = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_orange.png")
        //let candyYellow = SKSpriteNode(imageNamed: "art.scnassets/wrappedsolid_yellow.png")
        candyBlue.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        //candyOrange.position = CGPoint(x: 225, y: 70)
        //candyYellow.position = CGPoint(x: 230, y: 70)
        addChild(candyBlue)
    }
}
