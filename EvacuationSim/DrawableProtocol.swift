//
//  DrawableProtocol.swift
//  SFMplistView
//
//  Created by D.K.Lan on 26/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Foundation
import Cocoa

protocol Drawable{
    func draw()
}
extension Agent:Drawable{
    func draw() {
        let l = NSBezierPath(ovalInRect: NSRect(x: (x-radius)*30, y: (y-radius)*30, width: radius*60, height: radius*60))
        switch walktype{
        case 0:NSColor.redColor().setFill()
        case 1:NSColor.blueColor().setFill()
        default:NSColor.greenColor().setFill()
        }
        l.fill()
    }
}
extension Wall:Drawable{
    func draw() {
        let l = NSBezierPath()
        l.lineWidth = 3
        NSColor.blackColor().setStroke()
        l.moveToPoint(NSPoint(x: x1*30, y: y1*30))
        l.lineToPoint(NSPoint(x: x2*30, y: y2*30))
        l.stroke()
    }
}

extension Circle:Drawable{
    func draw() {
        let l = NSBezierPath(ovalInRect: NSRect(x: (x-r)*30, y: (y-r)*30, width: r*60, height: r*60))
        NSColor.blackColor().setFill()
        l.fill()
    }
}

extension FloorField:Drawable{
    func draw() {
        for c in cells{
            let y = Double(c.cellID / column) * 3
            let x = Double(c.cellID % column) * 3
            let l = NSBezierPath(rect: NSRect(x: x, y: y, width: 3, height: 3))
            let v = CGFloat(c.ffvalue / 200)
            NSColor(calibratedRed: v, green: v, blue: v, alpha: 1).setFill()
            l.fill()
        }
    }
}