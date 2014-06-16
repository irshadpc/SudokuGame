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

class GameScreenViewController: UIViewController {

    var mode : GameMode! = GameMode.Classic;
    var difficulty : GameDifficulty! = GameDifficulty.Easy;
    
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("\(mode.toRaw()) and \(difficulty.toRaw())");
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
