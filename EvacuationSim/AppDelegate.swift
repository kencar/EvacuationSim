//
//  AppDelegate.swift
//  EvacuationSim
//
//  Created by D.K.Lan on 4/2/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func newSettingWindow(event:NSMenuItem){
        cureentWindowController.close()
        cureentWindowController = SettingWindowController()
        cureentWindowController.showWindow(nil)
        
    }
    @IBAction func newSimWindow(event:NSMenuItem){
        cureentWindowController.close()
        cureentWindowController = SimWindowController()
        cureentWindowController.showWindow(nil)
    }
    var cureentWindowController = NSWindowController()
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
}
