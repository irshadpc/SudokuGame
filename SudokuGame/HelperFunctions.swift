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
        if($.contains(found, value: element)){
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