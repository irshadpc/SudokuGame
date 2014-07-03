//
//  HelperFunctions.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/28/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

//Useful until better support is added for Swift

func array<T: Equatable>(array:T[], contains other:T[]) -> Bool{
    var mutable = other;
    for element in array{
        for (index, agent) in enumerate(mutable){
            if(element == agent){
                mutable.removeAtIndex(index);
            }
        }
        if(mutable.count == 0){ return true; }
    }
    return false;
}

func array<T: Equatable>(array:T[], removeElement element: T) -> Array<T>{
    var result = array.copy();
    for (index, agent) in enumerate(result){
        if(agent == element){
            result.removeAtIndex(index);
            return result;
        }
    }
    result.removeAll(keepCapacity: false);
    return result;
}

func array<T: Equatable>(array:T[], indexesMatchingElement agent: T) -> Array<Int>{
    var result = Int[]();
    
    for(index, element) in enumerate(array){
        if(agent == element){
            result.append(index);
        }
    }
    return result;
}

