//
//  FloorField.swift
//  TheProtocol
//
//  Created by SunDance on 10/27/15.
//  Copyright © 2015 SunDance. All rights reserved.
//

import Foundation

struct Circle {
    var x:Double=0
    var y:Double=0
    var r:Double=0
    var position:Vectors {return Vectors(x: x, y: y)}
    
}

//cell size == 0.2m,find directions at 0.2m square(3rd layer) around agent.

struct Cell {
//    var a:Agent?
    
    var notbarrier:Bool = true
    var ffvalue:Double = 10001
    let cellID:Int
    init(ID:Int){
        cellID = ID
    }
}

struct FloorField {
    let directions:[(Int,Int)] = [(0,3),(3,3),(3,0),(3,-3),(0,-3),(-3,-3),(-3,0),(-3,3)]
    let cellsize = 0.1
    var row:Int
    var column:Int
    var cells=[Cell]()
    let walktype:Int
    
    init(row:Int,column:Int,walktype:Int){
        self.row = row
        self.column = column
        self.walktype = walktype
        for x in 0...row*column{
            let c = Cell(ID: x)
            cells.append(c)
        }
    }
}
// 1st part: floorfield value caculation
extension FloorField{
    // set circle barrier to floorfield
    private mutating func addCircles(circle:[Circle]){
        for c in circle{
            
            let len = (Int)(c.r*20)
            for i in 0...len{
                let x = (Int)(c.x/cellsize-c.r/cellsize)+i
                guard let t:Double = c.r*c.r-((Double)(x)*cellsize-c.x)*((Double)(x)*cellsize-c.x) where t>0 else {continue}
                
                let y = (Int)(sqrt(t)/cellsize+c.y/cellsize)
                let yy = (Int)(-sqrt(t)/cellsize+c.y/cellsize)
                for yyy in y-1...y+1{
                    cells[(yyy)*self.column+x].ffvalue = 10000
                    cells[(yyy)*self.column+x].notbarrier = false
                }
                for yyy in yy-1...yy+1{
                    cells[(yyy)*self.column+x].ffvalue = 10000
                    cells[(yyy)*self.column+x].notbarrier = false
                }
            }
            for i in 0...len{
                let y = (Int)(c.y/cellsize-c.r/cellsize)+i
                guard let t:Double = c.r*c.r-((Double)(y)*cellsize-c.y)*((Double)(y)*cellsize-c.y) where t>0 else {continue}
                
                let x = (Int)(sqrt(t)/cellsize+c.x/cellsize)
                let xx = (Int)(-sqrt(t)/cellsize+c.x/cellsize)
                for xxx in x-1...x+1{
                    cells[y*column+xxx].ffvalue = 10000
                    cells[y*column+xxx].notbarrier = false
                }
                for xxx in xx-1...xx+1{
                    cells[y*column+xxx].ffvalue = 10000
                    cells[y*column+xxx].notbarrier = false
                }
            }
        }
    }
    // set wall barrier to floorfield
    private mutating func addWalls(walls:[Wall]){
        for w in walls{
            if w.vectorX==0{
                let len = (Int)(w.vectorY/cellsize)
                for i in 0...len{
                    let x = (Int)(w.x1/cellsize)
                    let y = (Int)(w.y1/cellsize)+i
                    for xxx in x-1...x+1{
                        cells[y*column+xxx].notbarrier = false
                        cells[(y+1)*column+xxx].notbarrier = false
                        cells[(y-1)*column+xxx].notbarrier = false
                    }
                    
                    
                }
            }else{
                let k = w.vectorY/w.vectorX
                let len = (Int)(w.vectorX/cellsize)
                for i in 0...len{
                    
                    let x = (Int)(w.x1/cellsize)+i
                    let y = (Int)(w.y1/cellsize)
                    let yy = (Int)((Double)(i)*k)
                    for yyy in y-1...y+1{
                        cells[(yy+yyy)*column+x].notbarrier = false
                        cells[(yy+yyy)*column+x+1].notbarrier = false
                        cells[(yy+yyy)*column+x-1].notbarrier = false
                    }
                }
            }
        }
    }
    // set exits and return its position in cells
    private mutating func setExit(x1:Double,y1:Double,x2:Double,y2:Double)->[Int]{
        let vectorX = x2-x1
        let vectorY = y2-y1
        var ID = [Int]()
        if vectorX<0.1{
            let len = Int(vectorY/cellsize)
            for i in 0...len{
                let x = Int(x1/cellsize)
                let y = Int(y1/cellsize)+i
                cells[y*column+x-1].ffvalue = 0.0
                
                
                let a = y*column+x-1
                
                cells[y*column+x].ffvalue = 0.0
                
                
                let b = y*column+x
                
                cells[y*column+x+1].ffvalue = 0.0
                
                
                let c = y*column+x+1
                ID.append(a)
                ID.append(b)
                ID.append(c)
            }
        }else{
            let k = (Double)(vectorY)/(Double)(vectorX)
            let len = Int(vectorX/cellsize)+1
            for i in 0...len{
                
                let x = Int(x1/cellsize)+i
                let y = Int(y1/cellsize)
                let yy = i*(Int)(k)
                cells[(yy+y-1)*column+x].ffvalue = 0.0
                
                
                cells[yy+y*column+x].ffvalue = 0.0
                
                
                cells[(yy+y+1)*column+x].ffvalue = 0.0
                
                
                let a = (yy+y-1)*column+x
                let b = (yy+y)*column+x
                let c = (yy+y+1)*column+x
                ID.append(a)
                ID.append(b)
                ID.append(c)
            }
        }
        return ID
    }
    // find neighbour cell in 8 directions
    private mutating func findNeighbourID(value:Double,ID:Int)->[Int]{
        var neighbourID=[Int]()
        let roww:Int = Int(ID/column)
        let columnm:Int = ID%column
        for c in columnm-1...columnm+1{
            let a = (roww-1)*column+c
            if cells[a].ffvalue>value && cells[a].notbarrier{
                neighbourID.append(a)
                cells[a].ffvalue = value
            }
            let b = (roww+1)*column+c
            if cells[b].ffvalue>value && cells[b].notbarrier{
                neighbourID.append(b)
                cells[b].ffvalue = value
            }
        }
        let c = roww*column+columnm-1
        if cells[c].ffvalue>value && cells[c].notbarrier{
            neighbourID.append(c)
            cells[c].ffvalue = value
        }
        let d = roww*column+columnm+1
        if cells[d].ffvalue>value && cells[d].notbarrier{
            neighbourID.append(d)
            cells[d].ffvalue = value
        }
        
        return neighbourID
    }
    // find neighbour cell in 8 directions
    private mutating func findNeighbourIDFour(value:Double,ID:Int)->[Int]{
        var neighbourID=[Int]()
        let roww:Int = Int(ID/column)
        let columnm:Int = ID%column
        let a = (roww-1)*column+columnm
        if cells[a].ffvalue>value && cells[a].notbarrier{
            neighbourID.append(a)
            cells[a].ffvalue = value
        }
        let b = (roww+1)*column+columnm
        if cells[b].ffvalue>value && cells[b].notbarrier{
            neighbourID.append(b)
            cells[b].ffvalue = value
        }
        let c = roww*column+columnm-1
        if cells[c].ffvalue>value && cells[c].notbarrier{
            neighbourID.append(c)
            cells[c].ffvalue = value
        }
        let d = roww*column+columnm+1
        if cells[d].ffvalue>value && cells[d].notbarrier{
            neighbourID.append(d)
            cells[d].ffvalue = value
        }
        return neighbourID
    }
    // Floor Field Value in 8 directions
    private mutating func caculatesFFValue(allwalls:[Wall],circles:[Circle],allwalktype:[DataBasedOnWalkType]){
        var currentCellsID=[Int]()
        var nextCellsID=[Int]()
        var value = 0.0
        addWalls(allwalls)
        addCircles(circles)
        //add exitID to currentCellsID
        currentCellsID = setExit(allwalktype[walktype].exitXs, y1: allwalktype[walktype].exitYs, x2: allwalktype[walktype].exitXe, y2: allwalktype[walktype].exitYe)
        while currentCellsID.count>0{
            value+=1
            for ID in currentCellsID{
                let neighbourID=findNeighbourID(value, ID: ID)
                
                for x in neighbourID{
                    nextCellsID.append(x)
                }
            }
            currentCellsID.removeAll(keepCapacity: false)
            for x in nextCellsID{
                currentCellsID.append(x)
            }
            nextCellsID.removeAll(keepCapacity: false)
        }
    }
    // Floor Field Value in 4 directions
    private mutating func caculatesFFValueFour(allwalls:[Wall],circles:[Circle],allwalktype:[DataBasedOnWalkType]){
        var currentCellsID=[Int]()
        var nextCellsID=[Int]()
        var value = 0.0
        addWalls(allwalls)
        addCircles(circles)
        //add exitID to currentCellsID
        currentCellsID = setExit(allwalktype[walktype].exitXs, y1: allwalktype[walktype].exitYs, x2: allwalktype[walktype].exitXe, y2: allwalktype[walktype].exitYe)
        while currentCellsID.count>0{
            value+=1
            for ID in currentCellsID{
                let neighbourID=findNeighbourIDFour(value, ID: ID)
                
                for x in neighbourID{
                    nextCellsID.append(x)
                }
            }
            currentCellsID.removeAll(keepCapacity: false)
            for x in nextCellsID{
                currentCellsID.append(x)
            }
            nextCellsID.removeAll(keepCapacity: false)
            
        }
    }
    // get Guo's Floor Field
    mutating func get4and8FFValue(allwalls:[Wall],circles:[Circle],allwalktype:[DataBasedOnWalkType]){
        var c1 = FloorField(row: row, column: column, walktype:walktype)
        var c2 = FloorField(row: row, column: column, walktype: walktype)
        c1.caculatesFFValue(allwalls,circles:circles,allwalktype:allwalktype)
        c2.caculatesFFValueFour(allwalls,circles:circles,allwalktype:allwalktype)
        for i in 0...cells.count-1{
            cells[i].ffvalue = (c1.cells[i].ffvalue)*0.55+(c2.cells[i].ffvalue)*0.45
        }
    }
}