//
//  SudokuSolver.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/24/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

let GetPossibles = { (tile:TileModel, unitSolutions:Int[]) -> Int[] in
    let result = tile.possibleValues.filter {
        for value in unitSolutions {
            //If possible is already a found solution, then return false as it's longer a possible
            if($0 == value) { return false}
        }
        //No matches have been found so this element is still a possible
        return true;
    }
    return result;
}

class SudokuSolver{

    class func generatePuzzle(manager: MDLTileManager, withGivens givens:Array<Int>, atPositions positions:Array<TileIndexPath>){
        for index in 0...positions.count-1{
            let tileindex = positions[index].toIndex();
            manager.tiles[tileindex].currentValue = givens[index];
            manager.tiles[tileindex].isGiven = true;
        }
    }
    
    class func checkforSolvedTiles(manager:MDLTileManager){
        for tile in manager.tiles{
            if(tile.possibleValues.count == 1){
                manager.tiles[tile.ID-1].currentValue = tile.possibleValues[0];
            }
        }
    }

    class func checkforPossibles(manager: MDLTileManager){
        //Check by row first
        for unit in 1...9{
            self.applyNewPossibles(manager, atIndexPaths: TileIndexPath.indexPathesOfRow(unit), GetPossibles);
            self.applyNewPossibles(manager, atIndexPaths: TileIndexPath.indexPathesOfColumn(unit), GetPossibles);
            self.applyNewPossibles(manager, atIndexPaths: TileIndexPath.indexPathesOfBox(unit), GetPossibles);
        }
    }
    
    //class func checkForNakedCandidates
    
    class func applyNewPossibles(manager: MDLTileManager, atIndexPaths paths:TileIndexPath[], withTechnique eliminate:(TileModel, Int[]) -> Int[]){
        let solutions = manager.solutionsAtIndexPaths(paths);
        for path in paths{
            let tile = manager.tiles[path.toIndex()];
            manager.tiles[path.toIndex()].possibleValues = eliminate(tile, solutions);
        }
    }
}