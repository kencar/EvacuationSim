//
//  DataOnWalktype.swift
//  TheProtocol
//
//  Created by SunDance on 10/28/15.
//  Copyright © 2015 SunDance. All rights reserved.
//

import Foundation
struct DataBasedOnWalkType {
    let exitXs,exitYs,exitXe,exitYe,startX,startY,startW,startH:Double!
    let amount:Int!
    let walkType:Int!
    init(WalkType:Int,StartX:Double,StartY:Double,StartW:Double,StartH:Double,ExitXs:Double,ExitYs:Double,ExitXe:Double,ExitYe:Double,Amount:Int){
        self.walkType = WalkType
        self.startX = StartX
        self.startY = StartY
        self.startW = StartW
        self.startH = StartH
        self.exitXs = ExitXs
        self.exitYs = ExitYs
        self.exitXe = ExitXe
        self.exitYe = ExitYe
        self.amount = Amount
    }
    
}