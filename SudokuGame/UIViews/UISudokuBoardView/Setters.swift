//
//  SBVSetters.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

extension UISudokuboardView{
    func setState(state:TileState?, forTileAtIndex index:TileIndex){
        if(!state) { return; }
        
        var tileView = self.subviews[index.toID()] as UIView
        switch state! {
        case TileState.None:
            tileView.layer.borderColor = UIColor.blackColor().CGColor;
            break;
        case TileState.Selected:
            tileView.layer.borderColor = UIColor.greenColor().CGColor;
            break;
        case TileState.Highlighted:
            tileView.layer.borderColor = UIColor.yellowColor().CGColor;
            break;
        case TileState.Correct:
            tileView.layer.borderColor = UIColor.blueColor().CGColor;
            break;
        case TileState.Wrong:
            tileView.layer.borderColor = UIColor.redColor().CGColor;
            break;
        }
        tileViewModels[index.toID()].selectedState = state!;
    }
    
    func setValue(value:Int?, forTileAtIndex index:TileIndex){
        if(!value) { return; }
        
        var tileView = self.subviews[index.toID()] as UIView
        (tileView.subviews[0] as UILabel).text = (value == 0) ? "" : value.description;
        tileViewModels[index.toID()].currentValue = value!;
    }
}