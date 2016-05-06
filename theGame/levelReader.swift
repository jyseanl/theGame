//
//  levelReader.swift
//  theGame
//
//  Created by Lyt on 4/28/16.
//  Copyright © 2016 Lyt. All rights reserved.
//

//  This class contains functionality of read one level from JSON

import Foundation

class levelReader {
    
    var levelData: NSDictionary!
    
    init(level:Int) {
        let path = NSBundle.mainBundle().pathForResource("level_" + String(level), ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:.AllowFragments)
            levelData = jsonResult as! NSDictionary
            //print(levelData)
        }catch {
            print(error)
        }
    }
    // MARK:
    func getMazeSize() -> Int {
        return levelData.objectForKey("size") as! Int
    }
    
    func getElementTypeInPosition(x:Int, y:Int) -> Int {
        let matrix = levelData.objectForKey("matrix") as! NSArray
        let row = matrix[y] as! NSArray
        let type = row[x] as! Int
        return type
    }
    
}