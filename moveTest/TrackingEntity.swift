//
//  EntityThingy.swift
//  moveTest
//
//  Created by joltdev on 8/17/17.
//  Copyright © 2017 joltdev. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class TrackingEntity : GKEntity {
    var thingDoingTheMoving:SCNNode
    init(agentToTrack: GKAgent3D, thingDoingTheMoving: SCNNode) {
        self.thingDoingTheMoving = thingDoingTheMoving
        super.init()
        
        let componentThingy = ComponentThingy(thingyToMoveTo: agentToTrack, thingDoingTheMoving: thingDoingTheMoving)
        addComponent(componentThingy)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        for component in components {
            component.update(deltaTime: seconds)
        }
    }
    
    func turnOnTracker() {
        guard let componentThingy = component(ofType: ComponentThingy.self) else { return }
        
        componentThingy.turnOn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
