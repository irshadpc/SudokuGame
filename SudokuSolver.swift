//
//  SudokuSolver.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/24/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

class SudokuSolver{
    
    var manager: MDLTileManager;

    init(manager: MDLTileManager){
        self.manager = manager;
    }
    
    func generatePuzzle(givens:Array<Int>, atPositions positions:Array<TileIndexPath>){
        for index in 0...positions.count-1{
            let tileindex = positions[index].toIndex();
            manager.tiles[tileindex].currentValue = givens[index];
            manager.tiles[tileindex].isGiven = true;
        }
    }
    
    func checkforSolvedTiles() -> Bool{
        var found = false;
        for tile in manager.tiles{
            if(tile.possibleValues.count == 1){
                manager.tiles[tile.ID-1].currentValue = tile.possibleValues[0];
                found = true;
            }
        }
        return found;
    }

    func checkforPossibles() -> Bool{
        var found = false;
        //Check by row first
        for unitType in 0...2{
            for unit in 1...9{
                let result = self.applyNewPossibles(TileIndexPath.indexPathsOfUnit(unit, ofUnitType: UnitType.fromRaw(unitType)!));
                if(result == true) { found = true; };
            }
        }
        return found;
    }
    
    func checkForHiddenSingles() -> Bool{
        var found = false;
        
        for unitType in 0...2{
            for unit in 1...9{
                let result = self.applyNakedSingles(TileIndexPath.indexPathsOfUnit(unit, ofUnitType: UnitType.fromRaw(unitType)!));
                if(result == true) { found = true };
            }
        }
        return found;
    }
    
    func checkforNakedPairs() -> Bool{
        var found = false;
        //Check by row first
        for unitType in 0...2{
            for unit in 1...9{
                let paths = TileIndexPath.indexPathsOfUnit(unit, ofUnitType: UnitType.fromRaw(unitType)!);
                let doublePossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 2 }
                
                for pathOfDouble in doublePossibles{
                    let possibles = manager.tiles[pathOfDouble.toIndex()].possibleValues;
                    let matches = manager.tilePathsWithPossibles(possibles, inUnit: unit, ofType: UnitType.fromRaw(unitType)!);
                    if(matches.count == 2){
                        let tempPaths = array(paths, removeElement: matches[0]);
                        let pathsForRemoval = array(tempPaths, removeElement: matches[1]);
                        found = manager.removePossibles(possibles, atIndexPaths: pathsForRemoval); //Only considered "found" if possibles are removed from tiles.
                        if(found == true){ break; }
                    }
                }
                //found = self.applyNakedCandidates(TileIndexPath.indexPathsOfUnit(unit, ofUnitType: UnitType.fromRaw(unitType)!));
            }
        }
        return found;
    }
    
    func applyNakedSingles(paths:TileIndexPath[]) -> Bool{
        var found = false;
        var counter = TileIndexPath[][](count: 9, repeatedValue:TileIndexPath[]());
        
        for path in paths{
            let tile = manager.tiles[path.toIndex()];
            for value in tile.possibleValues{
                counter[value-1].append(path);
            }
        }
        
        for (index, tally) in enumerate(counter){
            if(tally.count == 1){
                let tile = manager.tiles[tally[0].toIndex()];
                manager.tiles[tally[0].toIndex()].currentValue = index+1;
                manager.tiles[tally[0].toIndex()].possibleValues.removeAll(keepCapacity: false);
                found = true;
            }
        }
        
        return found;
    }
    
    func applyNakedCandidates(paths:TileIndexPath[]) -> Bool{
        var found = false;
        //Get locations of doubles, triples and quads.
        let doublePossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 2 }
        //let triplePossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 3 }
        //let quadPossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 4 }

        for (index, pathOfDouble) in enumerate(doublePossibles){
            let tile = manager.tiles[pathOfDouble.toIndex()];
            for idx in index+1...doublePossibles.count-1{ //Enumerate through rest of array if there is any left
                let otherTile = manager.tiles[doublePossibles[idx].toIndex()];
                if( tile.possibleValues == otherTile.possibleValues){ //Compare possibles at location
                    //Match found, delete possibles with these values from every other tile
                    let tempPaths = array(paths, removeElement: pathOfDouble);
                    let pathsForRemoval = array(tempPaths, removeElement: doublePossibles[idx]);
                    found = manager.removePossibles(tile.possibleValues, atIndexPaths: pathsForRemoval); //Only considered "found" if possibles are removed from tiles.
                    if(found == true){ break; }
                }
            }
        }

        
        
        /*
        for (index, pathOfTriple) in enumerate(triplePossibles){
            let tile = manager.tiles[pathOfTriple.toIndex()];
            var matches = [pathOfTriple]; //Keep track of location of possibles
            for idx in index...triplePossibles.count{
                let otherTile = manager.tiles[triplePossibles[idx].toIndex()];
                if(tile.possibleValues == otherTile.possibleValues){
                    matches.append(triplePossibles[idx]);
                }
            }
            
            if(matches.count != 3){
                //Have not found enough to satisfy condition, iterate through doubles
                for pathOfDouble in doublePossibles{
                    let otherTile = manager.tiles[pathOfDouble.toIndex()];
                    if(array(tile.possibleValues, contains: otherTile.possibleValues)){
                        matches.append(pathOfDouble);
                    }
                }
            }
            
            if(matches.count == 3){
                //Condition satisfied, delete possbble with values from every other tile.
                let pathsForRemoval = paths.filter( { array(matches, contains: [$0]) == false } );
                manager.removePossibles(tile.possibleValues, atIndexPaths: pathsForRemoval);
                found = true;
            }
        }*/
        return found;
    }
    
    
    
    
    func applyNewPossibles(paths:TileIndexPath[]) -> Bool{
        var found = false;
        let solutions = manager.solutionsAtIndexPaths(paths);
        for path in paths{
            let tile = manager.tiles[path.toIndex()];
            let result = tile.possibleValues.filter {
                for value in solutions {
                    //If possible value is already a found solution, then return false as it's longer a possible
                    if($0 == value) {
                        return false;
                    }
                }
                //No matches have been found so this number is still a possible
                return true;
            }
            if(result.count != tile.possibleValues.count) { found = true };
            manager.tiles[path.toIndex()].possibleValues = result;
        }
        return found;
    }
}