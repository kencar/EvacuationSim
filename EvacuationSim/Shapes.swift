//
//  Shapes.swift
//  orcaTest
//
//  Created by SunDance on 12/10/15.
//  Copyright © 2015 SunDance. All rights reserved.
//

import Foundation

extension Vectors:Comparable{}
func < (a:Vectors,b:Vectors)->Bool{
    return a.x < b.x && a.y < b.y
}
func <= (a:Vectors,b:Vectors)->Bool{
    return a.x <= b.x && a.y <= b.y
}


struct Rect {
    var origin = Vectors()
    var size = Vectors()
    var middlePoint:Vectors {return size*0.5+origin}
}

extension Rect{
    func containsPoint(point:Vectors)->Bool{
        let x = point <= size + origin
        let y = origin < point
        return x && y
    }
    func interSectsRect(b:Rect)->Bool{
        return Rect(origin: origin-b.size*0.5, size: size+b.size).containsPoint(b.middlePoint)
    }
}



struct Line {
    var point = Vectors()
    var direction = Vectors()
}



struct Agent{
    var force = Vectors()
    var position = Vectors()
    var velocity = Vectors()
    var walktype = 0
    
//    var ID = 0
    let radius = 0.20//+0.02*drand48()
}
extension Agent:Equatable{}
func == (a:Agent,b:Agent)->Bool{
    return a.position == b.position
}