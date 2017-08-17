//
//  ComponentThingy.swift
//  moveTest
//
//  Created by joltdev on 8/17/17.
//  Copyright © 2017 joltdev. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class ComponentThingy : GKComponent, GKAgentDelegate {
    var agent:GKAgent3D
    var thingyToMoveTo:GKAgent3D
    var thingDoingTheMoving: SCNNode
    
    var isActive:Bool

    
    init( thingyToMoveTo: GKAgent3D, thingDoingTheMoving: SCNNode ) {
        self.thingyToMoveTo = thingyToMoveTo
        self.agent = GKAgent3D()
        self.isActive = true
        self.thingDoingTheMoving = thingDoingTheMoving
        super.init()
        self.agent.position = thingDoingTheMoving.simdPosition
        self.agent.behavior = MoveBehavior(targetSpeed: 1.0, seek: self.thingyToMoveTo, avoid: [])
        self.agent.maxSpeed = 50
        self.agent.maxAcceleration = 1
        self.agent.radius = 0.5
        self.agent.mass = 0.01
        self.agent.delegate = self
    }
    
    func turnOn() {
        self.isActive = true
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if !isActive {
            return
        }
        
        self.agent.position = thingDoingTheMoving.simdPosition

    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        if !isActive {
            return
        }
        
        thingDoingTheMoving.simdPosition = self.agent.position
        print("thingDoingTheMoving.simdPosition x \(thingDoingTheMoving.simdPosition.x) y \(thingDoingTheMoving.simdPosition.y) z \(thingDoingTheMoving.simdPosition.z)" )
        print("thingyToMoveTo.position x \(thingyToMoveTo.position.x) y \(thingyToMoveTo.position.y) z \(thingyToMoveTo.position.z)" )
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.agent.update(deltaTime: seconds)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        setWeight(0.5, for: GKGoal(toSeekAgent: seek))
    }
    
}

