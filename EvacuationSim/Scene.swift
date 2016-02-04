//
//  Scene.swift
//  TheProtocol
//
//  Created by SunDance on 10/28/15.
//  Copyright © 2015 SunDance. All rights reserved.
//

import Foundation

struct Scene {
    let cellsize = 0.1
    var agents = [Agent]()
    var allwalktype = [DataBasedOnWalkType]()
    var allwalls = [Wall]()
    var circles = [Circle]()
    
    var allfloorfield = [FloorField]()
    var theRow = 0
    var theColumn = 0
    var allvx = [Double]()
    
    var lasttime = 0
    var time:Double = 0
    var times = [Double]()
    
    init(lst:NSDictionary){
        dataFromLst(lst)
        addAgents()
    }
    // init agents position and floorfields
    private mutating func addAgents(){
        agents.removeAll(keepCapacity: false)

        for w in allwalktype{
            var crowd=[Agent]()
            var s = true
            
            while crowd.count<w.amount{
                var a =  Agent()
                
                a.walktype = w.walkType
                
                a.position.x = w.startX+w.startW*drand48()
                a.position.y = w.startY+w.startH*drand48()
                a.velocity.x = 0
                a.velocity.y = 0
                
                for c in crowd{
                    let d = (a.position - c.position)*(a.position - c.position)
                    let sqrr = 4*0.2*0.2
                    if d<sqrr{
                        s=false
                        break
                    }
                }
                if s {
                    
                    crowd+=[a]
                }
                s=true
            }
            for a in crowd{
                
                agents+=[a]
            }
            
        }

        for w in allwalktype{
            var c = FloorField(row: theRow, column: theColumn, walktype: w.walkType)
            c.get4and8FFValue(allwalls,circles: circles,allwalktype:allwalktype)
            allfloorfield.append(c)
        }
    }
    private mutating func dataFromLst(lst:NSDictionary){
        allwalls.removeAll(keepCapacity: false)
        circles.removeAll(keepCapacity: false)
        allwalktype.removeAll(keepCapacity: false)
        allfloorfield.removeAll(keepCapacity: false)
        theRow = (Int)((Double)(lst.valueForKey("Row") as! NSNumber)/cellsize)
        theColumn = (Int)((Double)(lst.valueForKey("Column") as! NSNumber)/cellsize)
        
        guard let numoftype = (lst.valueForKey("Types") as? NSNumber) else {return}
        guard let numofC = (lst.valueForKey("Column") as? NSNumber) else {return}
        guard let numofR = (lst.valueForKey("Row") as? NSNumber) else {return}
        guard let numofW = (lst.valueForKey("WallNum") as? NSNumber) else {return}
        let type = Int(numoftype)
        let column = Double(numofC)
        let row = Double(numofR)
        let wallnum = Int(numofW)

        allwalktype.removeAll()
        allwalls.removeAll()
        if let c = lst.valueForKey("Circle") as? NSDictionary{
            let x = Double(c.valueForKey("x") as! NSNumber)
            let y = Double(c.valueForKey("y") as! NSNumber)
            let r = Double(c.valueForKey("r") as! NSNumber)
            var circle = Circle()
            circle.x = x
            circle.y = y
            circle.r = r
            circles.append(circle)
        }
        
        for i in 0...type-1{
            guard let amount = lst.valueForKey("amountOfWaltype\(i)") as? NSDictionary else {break}
            guard let area = lst.valueForKey("areaOfWaltype\(i)") as? NSDictionary else {break}
            guard let exitarea = lst.valueForKey("exitOfWaltype\(i)") as? NSDictionary else {break}
            let xx1 = Int(amount.valueForKey("x1") as! NSNumber)
            
            let x1 = Double(area.valueForKey("x1") as! NSNumber)
            let y1 = Double(area.valueForKey("y1") as! NSNumber)
            let x2 = Double(area.valueForKey("x2") as! NSNumber)
            let y2 = Double(area.valueForKey("y2") as! NSNumber)
            
            let exitx1 = Double(exitarea.valueForKey("x1") as! NSNumber)
            let exity1 = Double(exitarea.valueForKey("y1") as! NSNumber)
            let exitx2 = Double(exitarea.valueForKey("x2") as! NSNumber)
            let exity2 = Double(exitarea.valueForKey("y2") as! NSNumber)

            allwalktype.append(DataBasedOnWalkType(WalkType: i, StartX: x1, StartY: y1, StartW: x2, StartH: y2, ExitXs: exitx1, ExitYs: exity1, ExitXe: exitx2, ExitYe: exity2, Amount: xx1))
        }
        for i in 0...wallnum-1{
            
            guard let area = lst.valueForKey("Wall\(i)") as? NSDictionary else {break}
            let x1 = Double(area.valueForKey("x1") as! NSNumber)
            let y1 = Double(area.valueForKey("y1") as! NSNumber)
            let x2 = Double(area.valueForKey("x2") as! NSNumber)
            let y2 = Double(area.valueForKey("y2") as! NSNumber)
            
            allwalls.append(Wall(a: x1, b: y1, c: x2, d: y2))
            
        }
        theColumn = Int(column / cellsize)
        theRow = Int(row / cellsize)
        
    }
    
    func draw(){
        for x in allwalls{
            x.draw()
        }
        for x in agents{
            x.draw()
        }
        for x in circles{
            x.draw()
        }
//        allfloorfield[0].draw()
    }
}