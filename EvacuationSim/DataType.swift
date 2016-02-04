//
//  Line.swift
//  SFMplistView
//
//  Created by D.K.Lan on 24/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Foundation
import Cocoa

class WallType:NSObject {
    var type = "Wall"
    
    var x1:Double = 0
    var y1:Double = 0
    var x2:Double = 0
    var y2:Double = 0
    
    convenience init(thetype:String){
        self.init()
        type = thetype
    }
    convenience init(x1:Double,y1:Double,x2:Double,y2:Double,type:String){
        self.init()
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.type = type
    }
}

protocol DrawWall{
    func drawWall()
    func drawArea()
    func drawExit()
}

protocol ExportToDic{
    func export()->NSDictionary
}

extension WallType:DrawWall{
    func drawWall(){
        let l = NSBezierPath()
        NSColor.blackColor().setStroke()
        l.moveToPoint(NSPoint(x: x1*10, y: y1*10))
        l.lineToPoint(NSPoint(x: x2*10, y: y2*10))
        l.stroke()
    }
    
    func drawArea() {
        let l = NSBezierPath(rect: NSRect(x: x1*10, y: y1*10, width: x2*10, height: y2*10))
        NSColor.purpleColor().setFill()
        l.fill()
    }
    
    func drawExit() {
        let l = NSBezierPath()
        NSColor.greenColor().setStroke()
        l.moveToPoint(NSPoint(x: x1*10, y: y1*10))
        l.lineToPoint(NSPoint(x: x2*10, y: y2*10))
        l.stroke()
    }
}

extension WallType:ExportToDic{
    func export() -> NSDictionary {
        return NSDictionary(objects: [x1,y1,x2,y2], forKeys: ["x1","y1","x2","y2"])
    }
}