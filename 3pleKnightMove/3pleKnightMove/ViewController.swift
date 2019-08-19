//
//  ViewController.swift
//  3pleKnightMove
//
//  Created by Filippos Pirpilidis on 05/08/2019.
//  Copyright © 2019 Filippos Pirpilidis. All rights reserved.
//

import UIKit
import PopupDialog

struct Point {
    var x : Int
    var y : Int
}

struct Path {
    var p : [Point]
}

class ViewController: UIViewController {
    
    
    @IBOutlet var chessSquare0: [UIButton]!
    @IBOutlet var chessSquare1: [UIButton]!
    @IBOutlet var chessSquare2: [UIButton]!
    @IBOutlet var chessSquare3: [UIButton]!
    @IBOutlet var chessSquare4: [UIButton]!
    @IBOutlet var chessSquare5: [UIButton]!
    @IBOutlet var chessSquare6: [UIButton]!
    @IBOutlet var chessSquare7: [UIButton]!
    var is_Start : Int = 0
    
    var buttons : [[UIButton]] = [[UIButton]]()
    
    var chessBoard : [[Int]] = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]
    
    @IBAction func calculateButtonAction(_ sender: UIButton) {
        calculate_moves(chessBoard: chessBoard)
        for i in 0...chessBoard[7].count - 1 {
            print("\(chessBoard[7][i])")
        }
    }
    
    var move_count : Int = 0
    var available_comb : [Int] = [Int]()
    
    let x_knight = [-1,  1,  -2,  2, -2, 2, -1, 1]
    let y_knight = [-2, -2,  -1, -1,  1, 1,  2, 2]
    
    
    func checkNextMove(bx:Int, by:Int, comb:Int) -> Bool {
        
        let x = bx + x_knight[comb]
        let y = by + y_knight[comb]
        
        return isValid(x: x, y: y)
        
    }
    
    func isValid(x:Int, y:Int) -> Bool{
        if (x < 0 || y < 0 || x > 7 || y > 7){
            return false
        }
        return true;
    }
    
    
    
    func getTarget(bx : Int, by:Int, comb:Int) -> [Int] {
        if checkNextMove(bx: bx, by: by, comb: comb){
            return [bx+x_knight[comb],by+y_knight[comb]]
        } else {
            return [bx,by]
        }
    }
    
    func canMoveTo(x:Int,y:Int,tx:Int,ty:Int) -> [Point] {
        var canMove : [Point] = [Point]()
        for i in 0...7 {
            var arr : [Int] = getTarget(bx: x, by: y, comb: i)
            if arr[0] != x && arr[1] != y {
                let p = Point(x: arr[0], y: arr[1])
                canMove.append(p)
                
            }
        }
        return canMove
    }
    
    func calculate_moves(chessBoard : [[Int]]){
        
        var sx: Int = 0
        var sy: Int = 0
        var tx: Int = 0
        var ty: Int = 0
        
        for y in 0...7 {
            for x in 0...7 {
                
                if chessBoard[y][x] == 1 {
                    sx = x
                    sy = y
                }
                
                if chessBoard[y][x] == 2 {
                    tx = x
                    ty = y
                }
                
            }
        }
        
        
        var paths2Reach : [Path] = [Path]()
        let startP = canMoveTo(x: sx, y: sy, tx: tx, ty: ty)
        for i in 0...startP.count - 1 {
            let firstDP = canMoveTo(x: startP[i].x, y: startP[i].y, tx: tx, ty: ty)
            for j in 0...firstDP.count - 1 {
                let secondDP = canMoveTo(x: firstDP[j].x, y: firstDP[j].y, tx: tx, ty: ty)
                for k in 0...secondDP.count - 1 {
                    if secondDP[k].y == ty && secondDP[k].x == tx {
                        let points = [Point(x: sx, y: sy),startP[i],firstDP[j],secondDP[k]]
                        let path = Path(p: points)
                        paths2Reach.append(path)
                        
                    }
                }
            }
        }
        
        if paths2Reach.count > 0 {
            showChessVC(paths2Reach: paths2Reach)
        } else {
            showNoCombinationMessage()
        }
        
    }
    
    func showNoCombinationMessage() {
        let alert = UIAlertController(title: "Can't reach", message: "There is no way to reach the target! Reset?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.is_Start = 0
                self.clearSquares()
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showChessVC(paths2Reach : [Path]){
        let chessVC = ChessBoardVC(nibName: "ChessBoardVC", bundle: nil)
        // Create the dialog
        let popup = PopupDialog(viewController: chessVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        popup.preferredContentSize = CGSize(width: 240, height: 270)
        
        // Create second button
        let buttonClose = DefaultButton(title: "Close", height: 30) {
            popup.dismiss()
        }
        var index : Int = 0
        let buttonNext = DefaultButton(title: "Next", height: 30) {
            chessVC.setPaths(paths2Reach: paths2Reach)
            chessVC.startAnimatePath(index: index)
            index = index + 1
        }
        buttonNext.dismissOnTap = false
        // Add buttons to dialog
        popup.addButtons([buttonClose,buttonNext])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    @IBAction func buttonresetAction(_ sender: UIButton) {
        is_Start = 0
        clearSquares()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [
            chessSquare0,
            chessSquare1,
            chessSquare2,
            chessSquare3,
            chessSquare4,
            chessSquare5,
            chessSquare6,
            chessSquare7
        ]
        self.is_Start = 0
        clearSquares()
    }
    
    
    @IBAction func chessSquare0Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[0][sender.tag - 1] == 0 {
                chessSquare0[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[0][sender.tag - 1] = 1
                if sender.tag % 2 == 1 {
                    chessSquare0[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare0[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[0][sender.tag - 1] == 0 {
                chessSquare0[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[0][sender.tag - 1] = 2
                if sender.tag % 2 == 1 {
                    chessSquare0[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare0[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
        
        
    }
    
    @IBAction func chessSquare1Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[1][sender.tag - 1] == 0 {
                chessSquare1[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[1][sender.tag - 1] = 1
                if sender.tag % 2 == 0 {
                    chessSquare1[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare1[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[1][sender.tag - 1] == 0 {
                chessSquare1[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[1][sender.tag - 1] = 2
                if sender.tag % 2 == 0 {
                    chessSquare1[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare1[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    @IBAction func chessSquare2Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[2][sender.tag - 1] == 0 {
                chessSquare2[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[2][sender.tag - 1] = 1
                if sender.tag % 2 == 1 {
                    chessSquare2[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare2[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[2][sender.tag - 1] == 0 {
                chessSquare2[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[2][sender.tag - 1] = 2
                if sender.tag % 2 == 1 {
                    chessSquare2[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare2[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    @IBAction func chessSquare3Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[3][sender.tag - 1] == 0 {
                chessSquare3[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[3][sender.tag - 1] = 1
                if sender.tag % 2 == 0 {
                    chessSquare3[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare3[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[3][sender.tag - 1] == 0 {
                chessSquare3[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[3][sender.tag - 1] = 2
                if sender.tag % 2 == 0 {
                    chessSquare3[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare3[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    @IBAction func chessSquare4Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[4][sender.tag - 1] == 0 {
                chessSquare4[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[4][sender.tag - 1] = 1
                if sender.tag % 2 == 1 {
                    chessSquare4[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare4[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[4][sender.tag - 1] == 0 {
                chessSquare4[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[4][sender.tag - 1] = 2
                if sender.tag % 2 == 1 {
                    chessSquare4[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare4[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    @IBAction func chessSquare5Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[5][sender.tag - 1] == 0 {
                chessSquare5[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[5][sender.tag - 1] = 1
                if sender.tag % 2 == 0 {
                    chessSquare5[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare5[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[5][sender.tag - 1] == 0 {
                chessSquare5[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[5][sender.tag - 1] = 2
                if sender.tag % 2 == 0 {
                    chessSquare5[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare5[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    @IBAction func chessSquare6Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[6][sender.tag - 1] == 0 {
                chessSquare6[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[6][sender.tag - 1] = 1
                if sender.tag % 2 == 1 {
                    chessSquare6[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare6[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[6][sender.tag - 1] == 0 {
                chessSquare6[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[6][sender.tag - 1] = 2
                if sender.tag % 2 == 1 {
                    chessSquare6[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare6[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
                print(chessBoard)
            }
        }
    }
    
    @IBAction func chessSquare7Action(_ sender: UIButton) {
        if is_Start == 0 {
            if chessBoard[7][sender.tag - 1] == 0 {
                chessSquare7[sender.tag - 1].setBackgroundImage(UIImage(named: "wn"), for: .normal)
                chessBoard[7][sender.tag - 1] = 1
                if sender.tag % 2 == 0 {
                    chessSquare7[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare7[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        } else if is_Start == 1 {
            if chessBoard[7][sender.tag - 1] == 0 {
                chessSquare7[sender.tag - 1].setBackgroundImage(UIImage(named: "bn"), for: .normal)
                chessBoard[7][sender.tag - 1] = 2
                if sender.tag % 2 == 0 {
                    chessSquare7[sender.tag - 1].backgroundColor = .yellow
                } else {
                    chessSquare7[sender.tag - 1].backgroundColor = .black
                }
                is_Start = is_Start + 1
            }
        }
    }
    
    
    func clearSquares() {
        
        
        
        for y in 0...7 {
            for x in 0...7 {
                chessBoard[y][x] = 0
            }
        }
        
        for i in 0...7 {
            available_comb.append(i)
        }
        
        for i in 0...7 {
            
            chessSquare0[i].setBackgroundImage(nil, for: .normal)
            if chessSquare0[i].tag % 2 == 0 {
                chessSquare0[i].backgroundColor = .black
            } else {
                chessSquare0[i].backgroundColor = .yellow
            }
            chessSquare0[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare1[i].setBackgroundImage(nil, for: .normal)
            if chessSquare1[i].tag % 2 == 1 {
                chessSquare1[i].backgroundColor = .black
            } else {
                chessSquare1[i].backgroundColor = .yellow
            }
            chessSquare1[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare2[i].setBackgroundImage(nil, for: .normal)
            if chessSquare2[i].tag % 2 == 0 {
                chessSquare2[i].backgroundColor = .black
            } else {
                chessSquare2[i].backgroundColor = .yellow
            }
            chessSquare2[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare3[i].setBackgroundImage(nil, for: .normal)
            if chessSquare3[i].tag % 2 == 1 {
                chessSquare3[i].backgroundColor = .black
            } else {
                chessSquare3[i].backgroundColor = .yellow
            }
            chessSquare3[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare4[i].setBackgroundImage(nil, for: .normal)
            if chessSquare4[i].tag % 2 == 0 {
                chessSquare4[i].backgroundColor = .black
            } else {
                chessSquare4[i].backgroundColor = .yellow
            }
            chessSquare4[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare5[i].setBackgroundImage(nil, for: .normal)
            if chessSquare5[i].tag % 2 == 1 {
                chessSquare5[i].backgroundColor = .black
            } else {
                chessSquare5[i].backgroundColor = .yellow
            }
            chessSquare5[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare6[i].setBackgroundImage(nil, for: .normal)
            if chessSquare6[i].tag % 2 == 0 {
                chessSquare6[i].backgroundColor = .black
            } else {
                chessSquare6[i].backgroundColor = .yellow
            }
            chessSquare6[i].setTitle("", for: .normal)
            
        }
        
        for i in 0...7 {
            
            chessSquare7[i].setBackgroundImage(nil, for: .normal)
            if chessSquare7[i].tag % 2 == 1 {
                chessSquare7[i].backgroundColor = .black
            } else {
                chessSquare7[i].backgroundColor = .yellow
            }
            chessSquare7[i].setTitle("", for: .normal)
            
        }
    }
    
}

