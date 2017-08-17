//
//  GameViewController.swift
//  moveTest
//
//  Created by joltdev on 8/17/17.
//  Copyright © 2017 joltdev. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import GameplayKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var trackingEntity: TrackingEntity?
    var lastUpdateTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        

        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        scnView.isPlaying = true
        scnView.delegate = self
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        doRyanStuff()
        
        
    }
    
    func doRyanStuff() {
        let scnView = self.view as! SCNView
        let scene = scnView.scene!
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        let nodeThatWillChase = createNodeThatWillChase()
        
        scene.rootNode.addChildNode(nodeThatWillChase)
        
        let agentToTrack = GKAgent3D()
        agentToTrack.position = ship.simdWorldPosition
        
        trackingEntity = TrackingEntity(agentToTrack: agentToTrack, thingDoingTheMoving: nodeThatWillChase)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.trackingEntity!.turnOnTracker()
        })
    }
    
    func createNodeThatWillChase() -> SCNNode {
        let geometry = SCNSphere(radius: 10)
        
        let node = SCNNode(geometry: geometry)
        node.position = SCNVector3Make(500, 500, 500)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if trackingEntity == nil {
            return
        }
        
        let deltaTime = time - (lastUpdateTime ?? time)
        trackingEntity?.update(deltaTime: deltaTime)
        
        lastUpdateTime = time
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
