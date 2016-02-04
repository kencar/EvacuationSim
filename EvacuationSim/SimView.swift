//
//  SimView.swift
//  SFMplistView
//
//  Created by D.K.Lan on 26/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Cocoa

@objc protocol SimViewDelegate{
    func draw()
}
class SimView: NSView {

    weak var delegate:SimViewDelegate?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        delegate?.draw()
    }
    
}
