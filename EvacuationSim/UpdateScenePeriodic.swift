//
//  UpdateScene.swift
//  SFMplistView
//
//  Created by D.K.Lan on 26/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Foundation
extension Scene{
    mutating func updatePeriodic(){
        //Insert agent to quadtree
        let quadtree = QuadTree(region: Rect(origin:Vectors(x: 0, y: 0),size: Vectors(x: 24, y: 9)))
        
        for i in 0...agents.count-1{
            quadtree.insert(agents[i])
//            if time > 40 && agents[i].x > 10.8{
//                allvx += [agents[i].vx]
//            }
        }
        
        //Calculate force
        for i in 0...self.agents.count-1{
            var thisforces = Vectors()
            //let (ex,ey)=self.allfloorfield[self.agents[i].walktype].moveDirection(self.agents[i],qt: quadtree)
            let (ex,ey)=self.allfloorfield[self.agents[i].walktype].moveInViewField(self.agents[i],qt: quadtree)
            //let (ex,ey)=self.allfloorfield[self.agents[i].walktype].moveInAllDirection(self.agents[i],qt: quadtree)
            let e = Vectors(x: ex, y: ey)
            //helbing
//            let e:Vectors!
//            if agents[i].walktype == 0{
//                e = Vectors(x: 1, y: 0)
//            }else{
//                e = Vectors(x: -1, y: 0)
//            }
            for x in 0...5{
                thisforces = thisforces + self.agents[i].wallforce(self.allwalls[x],e: e)
            }
            let neighbours :[Agent]!
            if self.agents[i].x>15{
                let d = self.agents[i].x-15
                neighbours = quadtree.pointsInRect(Rect(origin:self.agents[i].position-Vectors(x: 1, y: 1),size: Vectors(x: 2, y: 2)))+quadtree.pointsInRect(Rect(origin:Vectors(x: 1, y: self.agents[i].y-1),size: Vectors(x: d, y: 2)))
            }else if self.agents[i].x<2{
                let d = 2-self.agents[i].x
                neighbours = quadtree.pointsInRect(Rect(origin:self.agents[i].position-Vectors(x: 1, y: 1),size: Vectors(x: 2, y: 2)))+quadtree.pointsInRect(Rect(origin:Vectors(x: 16-d, y: self.agents[i].y-1),size: Vectors(x: d, y: 2)))
            }else{
                neighbours = quadtree.pointsInRect(Rect(origin:self.agents[i].position-Vectors(x: 1, y: 1),size: Vectors(x: 2, y: 2)))
            }
            for p in neighbours{
                var n = p
                if self.agents[i].x > 15{
                    if n.x<2{
                        n.position.x = n.x+15
                    }
                }
                if self.agents[i].x < 2{
                    if n.x>15{
                        n.position.x = n.x-15
                    }
                }
                thisforces = thisforces + self.agents[i].ppforce(n,e: e)
            }
            thisforces = thisforces + self.agents[i].selfdrivenforce(e)
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
            if agents[i].x>16{
                agents[i].position.x = agents[i].x-15
                
            }
            if agents[i].x<1{
                agents[i].position.x = agents[i].x+15
            }
        }
        //end
    }
    
}