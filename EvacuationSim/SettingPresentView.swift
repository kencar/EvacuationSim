//
//  SettingPresentView.swift
//  SFMplistView
//
//  Created by D.K.Lan on 24/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Cocoa

class SettingPresentView: NSView {
    weak var delegate:SettingPresentViewDelegate?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        delegate?.draw()
    }
    
}

@objc protocol SettingPresentViewDelegate{
    func draw()
}