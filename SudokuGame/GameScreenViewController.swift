//
//  GameScreenViewController.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/15/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

enum GameMode : Int{
    case Classic
    case TimeTrial
    case SudokuX
}

enum GameDifficulty : Int {
    case Easy
    case Medium
    case Hard
    case Expert
}


//By apples recommendations the board should be no smaller than 396 x 396 + 18 pixels for border size
class GameScreenViewController: UIViewController, UISudokuboardViewDelegate, UISudokuboardViewDatasource {

    var mode : GameMode! = GameMode.Classic;
    var difficulty : GameDifficulty! = GameDifficulty.Easy;
    var gameboard: UISudokuboardView = UISudokuboardView(frame: CGRectMake(50, 50, 450, 450))
    
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameboard.delegate = self;
        gameboard.datasource = self;
        self.view.addSubview(gameboard);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sudokuboardView(gameboard:AnyObject!, shouldSelect_sudokutileWithIndex index:TileIndex) -> Bool{
        return true;
    }
    
    func sudokuboardView(gameboard:AnyObject!, didSelect_sudokutileWithIndex index:TileIndex){
        
    }
    
    func sudokuboardView(gameboard:AnyObject!, shouldDeselect_sudokuTileWithIndex index:TileIndex) -> Bool{
        return true;
    }
    
    func sudokuboardView(gameboard:AnyObject!, didDeleselect_sudokuTileWithIndex index:TileIndex){
        
    }
    
    func sudokuboardView(gameboard: AnyObject!, imageName_forChesstileWithIndex index: TileIndex) -> String?{
        return nil;
    }
    
    func sudokuboardView(gameboard: AnyObject!, selectionState_forChesstileWithIndex index: TileIndex) -> TileState {
        return TileState.None;
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
