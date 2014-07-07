//
//  HelperFunctions.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/28/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

//Useful until better support is added for Swift

func indexesOfRepeatedValues<T:Equatable>(array:T[]) -> Int[][]{
    var result = Int[][]();
    var found = T[]();
    
    for(index, element) in enumerate(array){
        //Iterate through rest of array
        if(!arrayHelp(found, containsElement: element)){
            var matchFound = false;
            for idx in index+1...array.count-1{
                if(element == array[idx]){
                    if(!matchFound){
                        result.append(Int[]());
                        result[result.count-1].append(index);
                        found.append(element);
                        matchFound = true;
                    }
                    result[result.count-1].append(idx);
                }
            }
        }
    }
    return result;
}

func arrayHelp<T:Equatable>(array:T[][], contains other: T[]) -> Bool{
    if(array.count == 0 || other.count == 0) { return false; }
    
    for element in array{
        if(!arrayHelp(element, contains: other)){
            return false;
        }
    }
    return true;
}

func arrayHelp<T: Equatable>(array:T[], contains other:T[]) -> Bool{
    if(array.count == 0 || other.count == 0) { return false; }
    
    var mutable = other;
    var result = false;
    
    for element in other{
        if(!arrayHelp(array, containsElement: element)){
            return false;
        }
    }
    
    return true;
}

func arrayHelp<T: Equatable>(array:T[], containsElement element:T) -> Bool{
    if(array.count == 0) { return false; }
    
    for agent in array{
        if(agent == element){
            return true;
        }
    }
    return false;
}