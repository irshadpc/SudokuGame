//
//  SudokuSequence.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/20/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation
typealias TileModel = MDLTileManager.TileModel

class SudokuSequence{
    
    class func isWinningSequence(tiles: Array<TileModel>) -> Bool{
        if(tiles.count != 9) { return false; }
        
        var result = NSMutableIndexSet();
        for tile in tiles{
            if(tile.currentValue > 0){
                result.addIndex(tile.currentValue); }
        }
        return (result.count == 9);
    }
}