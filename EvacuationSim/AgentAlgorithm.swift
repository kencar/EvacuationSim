//
//  Agent.swift
//  QTtest
//
//  Created by SunDance on 11/26/15.
//  Copyright © 2015 SunDance. All rights reserved.
//
import Foundation

let A = 0.42
let B = 1.65
let lamda = 0.12
let tau = 0.5
let C_Young = 1500.0
let K = 3000.0
let v0 = 1.34

extension Agent{
    
    var x:Double{return position.x}
    var y:Double{return position.y}
    var vx:Double{return velocity.x}
    var vy:Double{return velocity.y}
    var v:Double{return velocity.abs()}
    var f:Double{return force.abs()}
    

    func selfdrivenforce(e:Vectors)->Vectors{
        return (e*v0-velocity)/tau
    }
    
    
    func ppforce(a:Agent,e:Vectors)->Vectors{
        guard a.position != position else {return Vectors()}
        let distanceVector = position - a.position
        let distance = distanceVector.abs()
        let distanceNorm = distanceVector.normalize()
        let rr = radius+a.radius
        
        let w = lamda + (1-lamda)/2*(1+e*distanceNorm)
        var thisforces = distanceNorm * A * exp((rr-distance)/B) * w
        if rr > distance{
            thisforces = thisforces + distanceNorm * C_Young * (rr-distance)
            thisforces = thisforces + Vectors(x: -distanceNorm.y, y: distanceNorm.x) * K * (rr-distance) * ((a.velocity-velocity)*Vectors(x: -distanceNorm.y, y: distanceNorm.x))
        }
        return thisforces
    }
    
    
    func wallforce(wall:Wall,e:Vectors)->Vectors{
        let (p,online) = wall.pointToLine(x, py: y)
        let distanceVector = position - p
        let distance = distanceVector.abs()
        let distanceNorm = distanceVector.normalize()
        let w = lamda + (1-lamda)/2*(1+e*distanceNorm)
        guard distance < 3 else {return Vectors()}
        var thisforces = distanceNorm * A * exp((radius-distance)/B) * w
        if radius > distance{
            thisforces = thisforces + distanceNorm * C_Young * (radius-distance) * 4
            thisforces = thisforces + Vectors(x: -distanceNorm.y, y: distanceNorm.x) * K * (radius-distance) * ((-velocity)*Vectors(x: -distanceNorm.y, y: distanceNorm.x))
        }
        if online{
            return thisforces
        }else{
            return thisforces * 0.5
        }
    }
    
    func circleforce(a:Circle,e:Vectors)->Vectors{
        
        let distanceVector = position - a.position
        let distance = distanceVector.abs()
        let distanceNorm = distanceVector.normalize()
        let rr = radius+a.r
        let w = lamda + (1-lamda)/2*(1+distanceNorm*e)
        var thisforces = distanceNorm * A * exp((rr-distance)/B) * w
        if rr > distance{
            thisforces = thisforces + distanceNorm * C_Young * (rr-distance)
            thisforces = thisforces + Vectors(x: -distanceNorm.y, y: distanceNorm.x) * K * (rr-distance) * ((-velocity)*Vectors(x: -distanceNorm.y, y: distanceNorm.x))
        }
        return thisforces
    }
    mutating func move(t:Double){
        
        velocity = velocity + force*t

        position = position + velocity*t
    }
}
struct Wall {
    let x1:Double
    let y1:Double
    let x2:Double
    let y2:Double
    var vectorX:Double{return x2-x1}
    var vectorY:Double{return y2-y1}
    init(a:Double,b:Double,c:Double,d:Double){
        x1 = a
        y1 = b
        x2 = c
        y2 = d
    }
    func pointToLine(px:Double,py:Double) ->(p:Vectors,online:Bool){
        var x,y,linelengthSQR,d:Double
        var online:Bool = true
        linelengthSQR=self.vectorX*self.vectorX+self.vectorY*self.vectorY
        d = ((px-self.x1)*self.vectorX+(py-self.y1)*self.vectorY)/linelengthSQR
        if d<=0.0{
            d=0.0
            online = false
        }
        if d>=1.0{
            d=1.0
            online = false
        }
        x=d*self.vectorX+self.x1
        y=d*self.vectorY+self.y1
        
        return (Vectors(x: x, y: y),online)
    }
}