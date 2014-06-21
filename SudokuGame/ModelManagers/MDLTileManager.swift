//
//  MDLTileManager.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

class MDLTileManager{
    struct TileModel{
        var ID = 0;
        var currentValue = 0;
        var solutionValue = 0;
        var isGiven = false;
        var isHighlighted = false;
        func isCorrect() -> Bool{
            return (solutionValue != 0) && (currentValue == solutionValue);
        }
    }
    
    var tiles = Array<TileModel>();
    
    init(){
        for ID in 0...80{
            tiles.append(TileModel(ID: ID+1, currentValue: 0, solutionValue: 2, isGiven: false, isHighlighted: false));
        }
    }
    
    func setValue(value: Int, ofTileAtIndexPath path:TileIndexPath) -> Bool{
        return self.setValue(value, ofTileAtIndex: path.toIndex());
    }
    
    func setValue(value: Int, ofTileAtIndex index:Int) -> Bool{
        if(!isValidIndex(index)) { return false; }
        tiles[index].currentValue = value;
        return tiles[index].isCorrect();
    }
    
    func setHighlighted(highlighted:Bool, tileAtIndexPath path:TileIndexPath){
        self.setHighlighted(highlighted, tileAtIndex: path.toIndex());
    }
    
    func setHighlighted(highlighted:Bool, tileAtIndex index:Int){
        tiles[index].isHighlighted = highlighted;
    }
    
    func isValidIndex(index: Int) -> Bool{
        if(index < 0 || index > tiles.count) { return false; }
        return true;
    }
    
    func tileAtIndexPath(path: TileIndexPath) -> TileModel?{
        return self.tileAtIndex(path.toIndex());
    }
    
    func tileAtIndex(index: Int) -> TileModel?{
        if(!self.isValidIndex(index)) { return nil; }
        return tiles[index];
    }
    
    func tileWithID(ID: Int) -> TileModel?{
        if(!self.isValidIndex(ID)) { return nil; }
        for tile in tiles{
            if(tile.ID == ID) { return tile; }
        }
        return nil;
    }

    func tilesAtIndexPaths(indexPaths: Array<TileIndexPath>) -> Array<TileModel>{
        var result = Array<TileModel>();
        
        for path in indexPaths{
            result.append(tiles[path.toIndex()]);
        }
        return result;
    }
}