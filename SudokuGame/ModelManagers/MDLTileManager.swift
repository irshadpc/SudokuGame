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
        
        var currentValue = 0;
        var solutionValue = 0;
        var isHighlighted = false;
        func isCorrect() -> Bool{
            return (solutionValue != 0) && (currentValue == solutionValue);
        }
        
        init(ID: Int, currentValue current: Int, solutionValue solution: Int, isGiven given:Bool, isHighlighted highlighted:Bool){
            self.ID = ID;
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
    
    var tiles = Array<TileModel>();
    
    init(){
        for ID in 0...80{
            tiles.append(TileModel(ID: ID+1, currentValue: 0, solutionValue: 0, isGiven: false, isHighlighted: false));
        }
    }
    
    func isValidIndex(index: Int) -> Bool{
        if(index < 0 || index > tiles.count) { return false; }
        return true;
    }
    
    func tileWithID(ID: Int) -> TileModel?{
        if(!self.isValidIndex(ID)) { return nil; }
        for tile in tiles{
            if(tile.ID == ID) { return tile; }
        }
        return nil;
    }
    
    func solutionsAtIndexPaths(indexPaths: TileIndexPath[]) -> Int[]{
        var result = Array<Int>();
        
        for path in indexPaths{
            var index = path.toIndex();
            if(tiles[index].currentValue > 0){
                result.append(tiles[index].currentValue);
            }
        }
        
        return result;
    }

    func tilesAtIndexPaths(indexPaths: TileIndexPath[]) -> TileModel[]{
        var result = Array<TileModel>();
        
        for path in indexPaths{
            result.append(tiles[path.toIndex()]);
        }
        return result;
    }
    
    func tilePathsWithPossibles(possibles: Int[], inUnit unit: Int, ofType type: UnitType) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        let indexPaths = TileIndexPath.indexPathsOfUnit(unit, ofUnitType: type);
        for path in indexPaths{
            var values = tiles[path.toIndex()].possibleValues;
            if(values == possibles){
                result.append(path);
            }
        }
        return result;
    }
    
    func tilePathsWithPieceOfPossibles(possibles: Int[], inUnit unit: Int, ofType type: UnitType) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        let indexPaths = TileIndexPath.indexPathsOfUnit(unit, ofUnitType: type);
        for path in indexPaths{
            var values = tiles[path.toIndex()].possibleValues;
            if(array(possibles, contains: values)){
                result.append(path);
            }
        }
        return result;
    }
    
    func removePossibles(possibles: Int[], atIndexPaths indexPaths:TileIndexPath[]) -> Bool{
        var removedPossibles = false;
        for path in indexPaths{
            tiles[path.toIndex()].possibleValues = tiles[path.toIndex()].possibleValues.filter( {
                if(array(possibles, contains: [$0]) == true){
                    removedPossibles = true;
                    return false; };
                return true;
            });
        }
        return removedPossibles;
    }
}