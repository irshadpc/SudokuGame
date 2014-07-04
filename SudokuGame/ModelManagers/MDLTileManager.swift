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
        let ID: Int;
        var isGiven: Bool{
            didSet{
                if(isGiven == true){ possibleValues.removeAll() }
            }
        }
        var possibleValues = Int[]();
    
        var row:Int
        var column:Int
        var currentValue = 0;
        var solutionValue = 0;
        var isHighlighted = false;
        func isCorrect() -> Bool{
            return (solutionValue != 0) && (currentValue == solutionValue);
        }
        
        init(ID: Int, row: Int, column: Int, currentValue current: Int, solutionValue solution: Int, isGiven given:Bool, isHighlighted highlighted:Bool){
            self.ID = ID;
            self.row = row;
            self.column = column;
            self.currentValue = current;
            self.solutionValue = solution;
            self.isGiven = given;
            self.isHighlighted = highlighted;
            
            if(!given){
                for possibleValue in 1...9{
                    possibleValues.append(possibleValue);
                }
            }
        }
    }
    
    var tiles = TileModel[][](count: 9, repeatedValue: TileModel[]());
    
    init(){
        
        for row in 1...9{
            for column in 1...9{
                tiles[row-1].append(TileModel(ID: row+column-1, row: row, column: column, currentValue: 0, solutionValue: 0, isGiven: false, isHighlighted: false));
            }
        }
    }
    
    func isValidIndex(index: Int) -> Bool{
        if(index < 0 || index > tiles.count) { return false; }
        return true;
    }
    
    func solutionsAtIndexPaths(indexPaths: TileIndexPath[]) -> Int[]{
        var result = Array<Int>();
        
        for path in indexPaths{
            var tile = tiles[path.row-1][path.column-1];
            if(tile.currentValue > 0){
                result.append(tile.currentValue);
            }
        }
        
        return result;
    }

    func tilesAtIndexPaths(indexPaths: TileIndexPath[]) -> TileModel[]{
        var result = Array<TileModel>();
        
        for path in indexPaths{
            result.append(tiles[path.row-1][path.column-1]);
        }
        return result;
    }
    
    func tilePathsWithPossibles(possibles: Int[], inPaths paths:TileIndexPath[]) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        for path in paths{
            var values = tiles[path.row-1][path.column-1].possibleValues;
            if(values == possibles){
                result.append(path);
            }
        }
        return result;
    }
    
    func tilePathsWithPieceOfPossibles(possibles: Int[], inPaths paths: TileIndexPath[]) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        for path in paths{
            var values = tiles[path.row-1][path.column-1].possibleValues;
            if(values.count > 0){
                if(array(possibles, contains: values) && values.count < possibles.count){
                    result.append(path);
                }
            }
        }
        return result;
    }
    
    func removePossibles(possibles: Int[], atIndexPaths indexPaths:TileIndexPath[]) -> Bool{
        var removedPossibles = false;
        for path in indexPaths{
            tiles[path.row-1][path.column-1].possibleValues = tiles[path.row-1][path.column-1].possibleValues.filter( {
                if(array(possibles, contains: [$0]) == true){
                    removedPossibles = true;
                    return false; };
                return true;
            });
        }
        return removedPossibles;
    }
}