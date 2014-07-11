//
//  SBVSetters.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

extension UISudokuboardView{
    func setState(state:TileState, forTileAtIndexPath path:TileIndexPath){
        let tileView = self.subviews[path.toIndex()] as UIView
        switch state {
        case TileState.None:
            tileView.layer.borderColor = UIColor.blackColor().CGColor;
            break;
        case TileState.Selected:
            tileView.layer.borderColor = UIColor.greenColor().CGColor;
            break;
        case TileState.Highlighted:
            tileView.layer.borderColor = UIColor.blueColor().CGColor;
            break;
        case TileState.Correct:
            tileView.layer.borderColor = UIColor.yellowColor().CGColor;
            break;
        case TileState.Wrong:
            tileView.layer.borderColor = UIColor.redColor().CGColor;
            break;
        }
        tileViewModels[path.toIndex()].selectedState = state;
    }
    
    func setValue(value:Int, forTileAtIndexPath path:TileIndexPath){
        let tileView = self.subviews[path.toIndex()] as UIView
        (tileView.subviews[0] as UILabel).text = (value == 0) ? "" : value.description;
        tileViewModels[path.toIndex()].currentValue = value;
    }
    
    func setPossibles(possibles:[Int], forTileAtIndexPath path:TileIndexPath){
        let tileview = self.subviews[path.toIndex()] as UIView
        
        self.clearPossiblesForTileAtIndexPath(path);
        //Apply new possibles
        for possible in possibles{
            (tileview.subviews[possible] as UIView).hidden = false;
        }
    }
    
    func clearPossiblesForTileAtIndexPath(path: TileIndexPath){
        let tileview = self.subviews[path.toIndex()] as UIView
        for index in 1...9{
            (tileview.subviews[index] as UIView).hidden = true;
        }
    }
    
    func highlightIndexPathes(pathSet: Array<TileIndexPath>){
        for path in pathSet{
            self.setState(TileState.Highlighted, forTileAtIndexPath: path);
        }
    }
}