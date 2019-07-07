//
//  GameScene.swift
//  MindGarden
//
//  Created by Sunghee Lee on 30/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var groundTileMapNode:SKTileMapNode = SKTileMapNode()
    var objectTileMap:SKTileMapNode!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var objectsTileMap: SKTileMapNode!
    
    override func didMove(to view: SKView) {
        //--
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        //--
        
        
        setupObjects()
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func setupObjects() {
        let columns = 30
        let rows = 30
        let size = CGSize(width: 15, height: 15)
        
        guard let tileSet = SKTileSet(named: "Decoration Tile") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        objectTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: size)
        
        addChild(objectTileMap)
        
        let tileGroups = tileSet.tileGroups
        
        guard let decorationTile = tileGroups.first(where: {$0.name == "flower1"}) else {
            fatalError("No flower1 tile definintion found")
        }
        
        guard let flowerTile = tileGroups.first(where: {$0.name == "flower1"}) else {
            fatalError("No Flower2 tile definition found")
        }
        
        let numberOfObjects = 64
        
        for i in 1...numberOfObjects {

            let column = 30
            let row = 25

            let groundTile = groundTileMapNode.tileDefinition(atColumn: columns, row: rows)

            let tile = groundTile == nil ? flowerTile : decorationTile

            objectTileMap.setTileGroup(tile, forColumn: column, row: row)
        }
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }
        
        let recognizerLocation = recognizer.location(in: recognizer.view!)
        let location = self.convertPoint(fromView: recognizerLocation)
        
        
        let map = self.childNode(withName: "Tile Map Node") as! SKTileMapNode
//            else {
//            fatalError("Background node not loaded")
//        }
        
        let column = map.tileColumnIndex(fromPosition: location)
        let row = map.tileRowIndex(fromPosition: location)
        let tile = map.tileDefinition(atColumn: column, row: row)
        
        
        
        print("============")
        print(column)
        print(row)
        print(tile)
        print("============")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
