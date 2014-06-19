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
        var currentValue = 0;
        var solutionValue = 0;
        var isGiven = false;
        func isCorrect() -> Bool{
            return (solutionValue != 0) && (currentValue == solutionValue);
        }
    }
    
    var tiles = Array<TileModel>();
    
    init(){
        for _ in 0...80{
            tiles.append(TileModel(currentValue: 1, solutionValue: 2, isGiven: false));
        }
    }
    
    func setValue(value: Int, ofTileWithIndex index:TileIndex) -> Bool{
        tiles[index.toID()].currentValue = value;
        return self.isCorrect_tileIndex(index);
    }
    
    func valueforTileIndex(index: TileIndex) -> Int{
        return self.valueForTileID(index.toID());
    }
    
    func valueForTileID(ID: Int) -> Int{
        return tiles[ID].currentValue;
    }
    
    func isCorrect_tileIndex(index:TileIndex) -> Bool{
        return self.isCorrect_tileID(index.toID());
    }
    
    func isCorrect_tileID(ID: Int) -> Bool{
        return (ID > tiles.count) ? false : tiles[ID].isCorrect();
    }
    
}