//
//  AgentInFloorField.swift
//  TheProtocol
//
//  Created by SunDance on 10/30/15.
//  Copyright © 2015 SunDance. All rights reserved.
//

import Foundation

//2nd part find neibours and direction
let celln = 0.8
let cellm = 0.3
let cellrr = cellr*2
let cellr = 0.25
extension FloorField{
    
    private func agentToFF(a:Agent)->(Int,Int){
        
        return (Int(a.x/cellsize),Int(a.y/cellsize))
    }
    // find direction in 3rd layer
    private func moveLeftToRight(a:Agent,qt:QuadTree)->(Double,Double){
        let(x,y) = agentToFF(a)
        let selfvalue = cells[x+y*column].ffvalue
        var total:Double = 0
        var nums = [Int]()
        var ps = [Double]()
        ps.reserveCapacity(8)
        nums.reserveCapacity(8)
        let positionx = a.x
        let positiony = a.y
//        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony+cellr),size: Vectors(x: cellrr, y: cellm))))//0
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//1
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//2
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//3
//        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony-cellr-cellm),size: Vectors(x: cellrr, y: cellm))))//4
        
        
        for i in [1,2,3]{
            let xx:Int = x+directions[i].0
            
            let yy:Int = y+directions[i].1
            
            if nums[i-1] > 0 || cells[xx+yy*column].ffvalue > 800 {
                ps+=[total]
            }else{
                
                total += exp((selfvalue-cells[xx+yy*column].ffvalue)/3)
                ps.append(total)

            }
        }
        if total>0{
            let thisp = total * drand48()
            var index:Int = 0
            for i in 0...2{
                if thisp < ps[i]{
                    index = i
                    break
                }
            }
            let xxx = Double(directions[index+1].0)
            let yyy = Double(directions[index+1].1)
            return (xxx/sqrt(xxx*xxx+yyy*yyy),yyy/sqrt(xxx*xxx+yyy*yyy))
        }else{
            return (0,0)
        }
    }
    private func moveRightToLeft(a:Agent,qt:QuadTree)->(Double,Double){
        let(x,y) = agentToFF(a)
        let selfvalue = cells[x+y*column].ffvalue
        var total:Double = 0
        var nums = [Int]()
        var ps = [Double]()
        ps.reserveCapacity(8)
        nums.reserveCapacity(8)
        let positionx = a.x
        let positiony = a.y
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony+cellr),size: Vectors(x: cellrr, y: cellm))))//0
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony-cellr-cellm),size: Vectors(x: cellrr, y: cellm))))//4
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//5
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//6
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//7
        
        for i in [0,4,5,6,7]{
            let xx:Int = x+directions[i].0
            
            let yy:Int = y+directions[i].1
            
            if nums[i]>0 || cells[xx+yy*column].ffvalue > 800{
                ps+=[total]
            }else{
                total += exp(1*(cells[xx+yy*column].ffvalue / selfvalue))
                ps.append(total)
            }
        }
        if total>0{
            let thisp = total * drand48()
            var index:Int = 0
            for i in 0...4{
                if thisp < ps[i]{
                    index = i
                    break
                }
            }
            let xxx = Double(directions[index].0)
            let yyy = Double(directions[index].1)
            return (xxx/sqrt(xxx*xxx+yyy*yyy),yyy/sqrt(xxx*xxx+yyy*yyy))
        }else{
            return (1,0)
        }
    }
    
    func moveDirection(a:Agent,qt:QuadTree)->(Double,Double){
        switch a.walktype{
        case 0:return moveLeftToRight(a, qt: qt)
        case 1:return moveRightToLeft(a, qt: qt)
        default:return(-1,0)
        }
    }
    
    
    
    
    
    func moveInAllDirection(a:Agent,qt:QuadTree)->(Double,Double){
        let(x,y) = agentToFF(a)
        let selfvalue = cells[x+y*column].ffvalue
        var total:Double = 0
        var nums = [Int]()
        let positionx = a.x
        let positiony = a.y
        var ps = [Double]()
        ps.reserveCapacity(8)
        nums.reserveCapacity(8)
        
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony+cellr),size: Vectors(x: cellrr, y: cellm))))//0
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//1
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//2
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//3
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony-cellr-cellm),size: Vectors(x: cellrr, y: cellm))))//4
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//5
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//6
        nums.append(qt.pointsNInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//7
        
        
        
        for i in 0...7{
            let xx:Int = x+directions[i].0
            
            let yy:Int = y+directions[i].1
            
            if nums[i]>0 || cells[xx+yy*column].ffvalue > 800 {
                ps+=[total]
            }else{
                
                total += exp(1*(selfvalue - cells[xx+yy*column].ffvalue))
                ps.append(total)
                
                
            }
        }
        if total>0.1{
            let thisp = total * drand48()
            var index:Int = 0
            for i in 0...7{
                if thisp < ps[i]{
                    index = i
                    break
                }
            }
            let xxx = Double(directions[index].0)
            let yyy = Double(directions[index].1)
            return (xxx/sqrt(xxx*xxx+yyy*yyy),yyy/sqrt(xxx*xxx+yyy*yyy))
        }else{
            return (0,0)
        }
    }
    
    
    
    
    
    func moveInViewField(a:Agent,qt:QuadTree)->(Double,Double){
        let(x,y) = agentToFF(a)
        let selfvalue = cells[x+y*column].ffvalue
        var total:Double = 0
        let positionx = a.x
        let positiony = a.y
        var nums = [Vectors]()
        var ps = [Double]()
        ps.reserveCapacity(8)
        nums.reserveCapacity(8)
        
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony+cellr),size: Vectors(x: cellrr, y: cellm))))//0
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//1
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//2
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx+cellr, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//3
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx-cellr, y: positiony-cellr-cellm),size: Vectors(x: cellrr, y: cellm))))//4
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr-cellm),size: Vectors(x: celln, y: cellm))))//5
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony-cellr),size: Vectors(x: celln, y: cellrr))))//6
        nums.append(qt.pRatioOfZetoInRect(Rect(origin:Vectors(x: positionx-cellr-celln, y: positiony+cellr),size: Vectors(x: celln, y: cellm))))//7
        
        
        for i in 0...7{
            let xx:Int = x+directions[i].0
            
            let yy:Int = y+directions[i].1
            
            if cells[xx+yy*column].ffvalue > 800 {
                ps+=[total]
            }else{
                if a.walktype == 0{
                    total += exp((selfvalue - cells[xx+yy*column].ffvalue) / 3) * (nums[i].x+1) / (nums[i].y+1)
                    ps.append(total)
                }else{
                    total += exp((selfvalue - cells[xx+yy*column].ffvalue) / 3) * (nums[i].y+1) / (nums[i].x+1)
                    ps.append(total)
                }
                
                
                
            }
        }
        if total>0.1{
            let thisp = total * drand48()
            var index:Int = 0
            for i in 0...7{
                if thisp < ps[i]{
                    index = i
                    break
                }
            }
            let xxx = Double(directions[index].0)
            let yyy = Double(directions[index].1)
            return (xxx/sqrt(xxx*xxx+yyy*yyy),yyy/sqrt(xxx*xxx+yyy*yyy))
        }else{
            return (0,0)
        }
    }
}