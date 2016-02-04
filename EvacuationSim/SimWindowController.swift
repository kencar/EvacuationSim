//
//  SimWindowController.swift
//  SFMplistView
//
//  Created by D.K.Lan on 25/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Cocoa

class SimWindowController: NSWindowController {

    @IBOutlet weak var simview:SimView?
    @IBOutlet weak var textField:NSTextField?
    var scene:Scene!
    var go = false
    @IBAction func input(event:NSButton){
        guard let path = textField?.stringValue else {return}
        guard path.containsString(".plist") else {return}
        guard let lst =  NSDictionary(contentsOfFile: path) else {return}
        scene = Scene(lst: lst)
        go = true
        simview?.needsDisplay = true
    }
    @IBAction func runPeriodic(event:NSButton){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            for _ in 0...9{
                var t = 0
                while self.scene.time < 1000{
                    self.scene.updatePeriodic()
                    if Int(self.scene.time*10) == t{
                        t = t+1
                        dispatch_sync(dispatch_get_main_queue(), {self.simview?.needsDisplay = true})
                    }
                }
//                var v = 0.0
//                for x in self.scene.allvx{
//                    v+=x
//                }
//                print(v/Double(self.scene.allvx.count))
                guard let path = self.textField?.stringValue else {return}
                guard path.containsString(".plist") else {return}
                guard let lst =  NSDictionary(contentsOfFile: path) else {return}
                self.scene = Scene(lst: lst)
                self.go = true
                
            }
        })
        
    }
    @IBAction func runNorm(event:NSButton){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            for _ in 0...9{
                var t = 0
                while self.scene.agents.count > 0{
                    self.scene.update()
                    if Int(self.scene.time) == t{
                        t = t+1
                        dispatch_sync(dispatch_get_main_queue(), {self.simview?.needsDisplay = true})
                    }
                }
                print(self.scene.times.last!-self.scene.times[0])
                guard let path = self.textField?.stringValue else {return}
                guard path.containsString(".plist") else {return}
                guard let lst =  NSDictionary(contentsOfFile: path) else {return}
                self.scene = Scene(lst: lst)
                self.go = true
            }
        })
    }
    override func windowDidLoad() {
        super.windowDidLoad()

        simview?.delegate = self
        
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    convenience init() {
        self.init(windowNibName:"SimWindowController")
        self.window?.titleVisibility = .Hidden
        self.window?.titlebarAppearsTransparent = true
    }
    
    
}

extension SimWindowController:SimViewDelegate{
    func draw(){
        if go{
            scene.draw()
        }
    }
    
}