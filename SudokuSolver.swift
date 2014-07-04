//
//  SudokuSolver.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/24/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

enum SolverStep:Int{
    case NakedSingles
    case Possibles
    case HiddenSingles
    case NakedPairs
    case NakedTriples
    case HiddenPairs
    case HiddenTriples
}

class SudokuSolver{
    
    var manager: MDLTileManager;
    
    func getCounter(paths: TileIndexPath[]) -> TileIndexPath[][]{
        var result = TileIndexPath[][](count: 9, repeatedValue:TileIndexPath[]());
        for path in paths{
            let tile = manager.tiles[path.row-1][path.column-1];
            for value in tile.possibleValues{
                result[value-1].append(path);
            }
        }
        return result;
    }
    
    init(manager: MDLTileManager){
        self.manager = manager;
    }
    
    func generatePuzzle(givens:Array<Int>, atPositions positions:Array<TileIndexPath>){
        for index in 0...positions.count-1{
            let path = positions[index];
            manager.tiles[path.row-1][path.column-1].currentValue = givens[index];
            manager.tiles[path.row-1][path.column-1].isGiven = true;
        }
    }
    
    func takeStep(step: SolverStep, withPaths paths: TileIndexPath[])->Bool{
        switch(step){
            case .NakedSingles:
                return checkforNakedPairs(indexPaths: paths);
            case .Possibles:
                return checkforPossibles(indexPaths: paths);
            case .HiddenSingles:
                return checkForHiddenSingles(indexPaths: paths);
            case .NakedPairs:
                return checkforNakedPairs(indexPaths: paths);
            case .NakedTriples:
                return false;
            case .HiddenPairs:
                return false;
            case .HiddenTriples:
                return false;
            default:
                return false;
        }
    }
    
    
    func checkforSolvedTiles(indexPaths paths:TileIndexPath[]) -> Bool{
        var found = false;
        
        for path in paths{
            let tile = manager.tiles[path.row][path.column];
            if(tile.possibleValues.count == 1){
                manager.tiles[tile.row-1][tile.column-1].currentValue = tile.possibleValues[0];
                found = true;
            }
        }
        
        return found;
    }

    func checkforPossibles(indexPaths paths:TileIndexPath[]) -> Bool{
        var found = false;
        let solutions = manager.solutionsAtIndexPaths(paths);
        for path in paths{
            let tile = manager.tiles[path.row-1][path.column-1];
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
            manager.tiles[path.row-1][path.column-1].possibleValues = result;
        }
        return found;
    }
    
    func checkForHiddenSingles(indexPaths paths:TileIndexPath[]) -> Bool{
        var found = false;
        let counter = getCounter(paths);
                
        for (index, tally) in enumerate(counter){
            if(tally.count == 1){
                let tile = manager.tiles[tally[0].row-1][tally[0].column-1];
                manager.tiles[tally[0].row-1][tally[0].column-1].currentValue = index+1;
                manager.tiles[tally[0].row-1][tally[0].column-1].possibleValues.removeAll(keepCapacity: false);
                found = true;
            }
        }
        return found;
    }

    func checkforNakedPairs(indexPaths paths:TileIndexPath[]) -> Bool{
        var found = false;
        //Check by row first
        
        let doublePossibles = paths.filter { self.manager.tiles[$0.row-1][$0.column-1].possibleValues.count == 2 }
                
        for pathOfDouble in doublePossibles{
            let possibles = manager.tiles[pathOfDouble.row-1][pathOfDouble.column-1].possibleValues;
            let matches = manager.tilePathsWithPossibles(possibles, inPaths: paths);
            if(matches.count == 2){
                let pathsForRemoval = array(paths, removeElements: matches);
                found = manager.removePossibles(possibles, atIndexPaths: pathsForRemoval); //Only considered "found" if possibles are removed from tiles.
                if(found == true){ break; }
            }
        }
                
        if(!found){
            let triplePossibles = paths.filter { self.manager.tiles[$0.row-1][$0.column-1].possibleValues.count == 3 }
                    
            for pathOfTriple in triplePossibles{
                let possibles = manager.tiles[pathOfTriple.row-1][pathOfTriple.column-1].possibleValues;
                let matches = manager.tilePathsWithPossibles(possibles, inPaths: paths) + manager.tilePathsWithPieceOfPossibles(possibles, inPaths: paths);
                println(matches);
                if(matches.count == 3){
                    let pathsForRemoval = array(paths, removeElements: matches);
                    found = manager.removePossibles(possibles, atIndexPaths: pathsForRemoval); //Only considered "found" if possibles are removed from tiles.
                    if(found == true){ break; }
                }
            }
        }
        return found;
    }
    
    func checkForHiddenPairs() -> Bool{
        var found = false;
        
        var counter = TileIndexPath[][](count: 9, repeatedValue:TileIndexPath[]());
        
        
        
        return false;
    }
    
    
    func applyNakedCandidates(paths:TileIndexPath[]) -> Bool{
        var found = false;
        //Get locations of doubles, triples and quads.
        let doublePossibles = paths.filter { self.manager.tiles[$0.row][$0.column].possibleValues.count == 2 }
        //let triplePossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 3 }
        //let quadPossibles = paths.filter { self.manager.tiles[$0.toIndex()].possibleValues.count == 4 }

        for (index, pathOfDouble) in enumerate(doublePossibles){
            let tile = manager.tiles[pathOfDouble.row-1][pathOfDouble.column-1];
            for idx in index+1...doublePossibles.count-1{ //Enumerate through rest of array if there is any left
                let otherTile = manager.tiles[doublePossibles[idx].row-1][doublePossibles[idx].column-1];
                if( tile.possibleValues == otherTile.possibleValues){ //Compare possibles at location
                    //Match found, delete possibles with these values from every other tile
                    //let tempPaths = array(paths, removeElement: pathOfDouble);
                    //let pathsForRemoval = array(tempPaths, removeElement: doublePossibles[idx]);
                    //found = manager.removePossibles(tile.possibleValues, atIndexPaths: pathsForRemoval); //Only considered "found" if possibles are removed from tiles.
                    //if(found == true){ break; }
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
}