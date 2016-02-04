//
//  SettingWindowController.swift
//  SFMplistView
//
//  Created by D.K.Lan on 24/1/2016.
//  Copyright © 2016 D.K.Lan. All rights reserved.
//

import Cocoa

class SettingWindowController: NSWindowController {

    @IBOutlet weak var settingpresentview:SettingPresentView?
    @IBOutlet weak var tableview:NSTableView?
    @IBOutlet weak var pathText:NSTextField?
    @IBOutlet weak var columnNum:NSTextField?
    @IBOutlet weak var rowNum:NSTextField?
    @IBAction func waysOfWalk(event:NSPopUpButton){
        let currentState = event.selectedItem!.tag
        amounts.removeAll()
        initArea.removeAll()
        exit.removeAll()
        for i in 0...currentState-1{
            amounts.append(WallType(thetype: "amountOfWaltype\(i)"))
            
            initArea.append(WallType(thetype: "areaOfWaltype\(i)"))

            exit.append(WallType(thetype: "exitOfWaltype\(i)"))
        }
        tableview?.reloadData()
        
    }
    @IBAction func add(event:NSButton){
        walls.append(WallType())
        tableview?.reloadData()
    }
    @IBAction func remove(event:NSButton){
        tableview?.abortEditing()
        guard let row = tableview?.selectedRow where row > -1 else {return}
        guard walldata[row].type == "Wall" else{return}
        tableview?.abortEditing()
        walls.removeAtIndex(row-initArea.count)
        tableview?.reloadData()
        settingpresentview?.needsDisplay = true
    }
    @IBAction func input(event:NSButton){
        guard let path = pathText?.stringValue else {return}
        guard path.containsString(".plist") else {return}
        guard let dic = NSDictionary(contentsOfFile: path) else {return}
        guard let numoftype = (dic.valueForKey("Types") as? NSNumber) else {return}
        guard let numofC = (dic.valueForKey("Column") as? NSNumber) else {return}
        guard let numofR = (dic.valueForKey("Row") as? NSNumber) else {return}
        guard let numofW = (dic.valueForKey("WallNum") as? NSNumber) else {return}
        let type = Int(numoftype)
        let column = Double(numofC)
        let row = Double(numofR)
        let wallnum = Int(numofW)
        amounts.removeAll()
        initArea.removeAll()
        walls.removeAll()
        exit.removeAll()
        if let c = dic.valueForKey("Circle") as? NSDictionary{
            let x = Double(c.valueForKey("x") as! NSNumber)
            let y = Double(c.valueForKey("y") as! NSNumber)
            let r = Double(c.valueForKey("r") as! NSNumber)
            circle = Circle()
            circle!.x = x
            circle!.y = y
            circle!.r = r
            
            
        }
        for i in 0...type-1{
            guard let amount = dic.valueForKey("amountOfWaltype\(i)") as? NSDictionary else {break}
            guard let exitarea = dic.valueForKey("exitOfWaltype\(i)") as? NSDictionary else {break}
            guard let area = dic.valueForKey("areaOfWaltype\(i)") as? NSDictionary else {break}
            
            let xx1 = Double(amount.valueForKey("x1") as! NSNumber)
            amounts.append(WallType(x1:xx1,y1:0,x2:0,y2:0,type:"amountOfWaltype\(i)"))
            
            let x1 = Double(area.valueForKey("x1") as! NSNumber)
            let y1 = Double(area.valueForKey("y1") as! NSNumber)
            let x2 = Double(area.valueForKey("x2") as! NSNumber)
            let y2 = Double(area.valueForKey("y2") as! NSNumber)
            initArea.append(WallType(x1:x1,y1:y1,x2:x2,y2:y2,type:"areaOfWaltype\(i)"))
            
            
            let exitx1 = Double(exitarea.valueForKey("x1") as! NSNumber)
            let exity1 = Double(exitarea.valueForKey("y1") as! NSNumber)
            let exitx2 = Double(exitarea.valueForKey("x2") as! NSNumber)
            let exity2 = Double(exitarea.valueForKey("y2") as! NSNumber)
            exit.append(WallType(x1:exitx1,y1:exity1,x2:exitx2,y2:exity2,type:"exitOfWaltype\(i)"))
        }
        for i in 0...wallnum-1{
            
            guard let area = dic.valueForKey("Wall\(i)") as? NSDictionary else {break}
            let x1 = Double(area.valueForKey("x1") as! NSNumber)
            let y1 = Double(area.valueForKey("y1") as! NSNumber)
            let x2 = Double(area.valueForKey("x2") as! NSNumber)
            let y2 = Double(area.valueForKey("y2") as! NSNumber)
            
            walls.append(WallType(x1:x1,y1:y1,x2:x2,y2:y2,type:"Wall"))
            
        }
        tableview?.reloadData()
        columnNum?.stringValue = "\(column)"
        rowNum?.stringValue = "\(row)"
        settingpresentview?.needsDisplay = true
    }
    @IBAction func output(event:NSButton){
        guard let path = pathText?.stringValue else {return}
        guard path.containsString(".plist") else {return}
        let p = NSMutableDictionary()
        for x in amounts{
            p.setObject(x.export(), forKey: x.type)
        }
        for x in initArea{
            p.setObject(x.export(), forKey: x.type)
        }
        for x in exit{
            p.setObject(x.export(), forKey: x.type)
        }
        for i in 0...walls.count-1{
            p.setObject(walls[i].export(), forKey: "Wall\(i)")
        }
        
        p.setObject(initArea.count, forKey: "Types")
        p.setObject(walls.count, forKey: "WallNum")
        guard let c = Double((columnNum?.stringValue)!) else{return}
        guard let r = Double((rowNum?.stringValue)!) else{return}
        p.setObject(c, forKey: "Column")
        p.setObject(r, forKey: "Row")
        p.writeToFile(path, atomically: true)
    }
    var initArea = [WallType]()
    var amounts = [WallType]()
    var walls = [WallType]()
    var exit = [WallType]()
    var circle: Circle?
    var walldata:[WallType]{return amounts + initArea + exit + walls}

    convenience init() {
        self.init(windowNibName:"SettingWindowController")
        self.window?.titleVisibility = .Hidden
        self.window?.titlebarAppearsTransparent = true
        settingpresentview?.delegate = self
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
    }
    
}

extension SettingWindowController: NSTableViewDataSource{
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return walldata.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        guard row < walldata.count && row > -1 else {return "error"}
        guard let identifier = tableColumn?.identifier else {return "error"}
        return walldata[row].valueForKey(identifier)
    }
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        //guard row < walldata.count else {return}
        guard let identifier = tableColumn?.identifier else {return}
        walldata[row].setValue(object, forKey: identifier)
        
        settingpresentview?.needsDisplay = true
    }
}

extension SettingWindowController:SettingPresentViewDelegate{
    func draw(){
        for x in initArea{
            x.drawArea()
        }
        for x in walls{
            x.drawWall()
        }
        for x in exit{
            x.drawExit()
        }
    }
}
