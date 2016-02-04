//
//  UpdateSceneNorm.swift
//  SFMplistView
//
//  Created by D.K.Lan on 26/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Foundation
extension Scene{
    mutating func update(){
        let quadtree = QuadTree(region: Rect(origin:Vectors(x: 0, y: 0),size: Vectors(x: 15, y: 6)))
        
        for i in 0...agents.count-1{
            quadtree.insert(agents[i])
        }
        //Calculate force
        for i in 0...agents.count-1{
            var thisforces = Vectors()
            
            let (ex,ey)=self.allfloorfield[agents[i].walktype].moveInAllDirection(agents[i],qt: quadtree)
            let e = Vectors(x: ex, y: ey)
            for w in allwalls{
                thisforces = thisforces + agents[i].wallforce(w,e: e)
            }
            
            let neighbours = quadtree.pointsInRect(Rect(origin:agents[i].position-Vectors(x: 1, y: 1),size: Vectors(x: 2, y: 2)))
            
            for p in neighbours{
                thisforces = thisforces + agents[i].ppforce(p,e: e)
            }
            for c in circles{
                thisforces = thisforces + agents[i].circleforce(c, e: e)
            }
            
            thisforces = thisforces + agents[i].selfdrivenforce(e)
            self.agents[i].force = thisforces
        }
        //caculate time
        var f = 0.0
        for a in agents{
            if a.f>f{
                f=a.f
            }
        }
        
        var t = 0.1/sqrt(f)
        if t>0.01{
            t=0.01
        }
        time += t
        //update position
        for i in 0...agents.count-1{
            agents[i].move(t)
        }
        //delete out agent
        var i = agents.count - 1
        
        while i > -1 {
            if agents[i].x > 11{
                agents.removeAtIndex(i)
                times.append(time)
            }
            i = i - 1
        }
        
        //end
        
    }
}