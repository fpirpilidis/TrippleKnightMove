//
//  ChessBoardVC.swift
//  3pleKnightMove
//
//  Created by Filippos Pirpilidis on 08/08/2019.
//  Copyright © 2019 Filippos Pirpilidis. All rights reserved.
//

import UIKit
import DWAnimatedLabel

class ChessBoardVC: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pathLabel: DWAnimatedLabel!
    @IBOutlet weak var img00: UIImageView!
    @IBOutlet weak var img01: UIImageView!
    @IBOutlet weak var img02: UIImageView!
    @IBOutlet weak var img03: UIImageView!
    @IBOutlet weak var img04: UIImageView!
    @IBOutlet weak var img05: UIImageView!
    @IBOutlet weak var img06: UIImageView!
    @IBOutlet weak var img07: UIImageView!
    
    
    @IBOutlet weak var img10: UIImageView!
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var img12: UIImageView!
    @IBOutlet weak var img13: UIImageView!
    @IBOutlet weak var img14: UIImageView!
    @IBOutlet weak var img15: UIImageView!
    @IBOutlet weak var img16: UIImageView!
    @IBOutlet weak var img17: UIImageView!
    
    @IBOutlet weak var img20: UIImageView!
    @IBOutlet weak var img21: UIImageView!
    @IBOutlet weak var img22: UIImageView!
    @IBOutlet weak var img23: UIImageView!
    @IBOutlet weak var img24: UIImageView!
    @IBOutlet weak var img25: UIImageView!
    @IBOutlet weak var img26: UIImageView!
    @IBOutlet weak var img27: UIImageView!
    
    @IBOutlet weak var img30: UIImageView!
    @IBOutlet weak var img31: UIImageView!
    @IBOutlet weak var img32: UIImageView!
    @IBOutlet weak var img33: UIImageView!
    @IBOutlet weak var img34: UIImageView!
    @IBOutlet weak var img35: UIImageView!
    @IBOutlet weak var img36: UIImageView!
    @IBOutlet weak var img37: UIImageView!
    
    @IBOutlet weak var img40: UIImageView!
    @IBOutlet weak var img41: UIImageView!
    @IBOutlet weak var img42: UIImageView!
    @IBOutlet weak var img43: UIImageView!
    @IBOutlet weak var img44: UIImageView!
    @IBOutlet weak var img45: UIImageView!
    @IBOutlet weak var img46: UIImageView!
    @IBOutlet weak var img47: UIImageView!
    
    @IBOutlet weak var img50: UIImageView!
    @IBOutlet weak var img51: UIImageView!
    @IBOutlet weak var img52: UIImageView!
    @IBOutlet weak var img53: UIImageView!
    @IBOutlet weak var img54: UIImageView!
    @IBOutlet weak var img55: UIImageView!
    @IBOutlet weak var img56: UIImageView!
    @IBOutlet weak var img57: UIImageView!
    
    @IBOutlet weak var img60: UIImageView!
    @IBOutlet weak var img61: UIImageView!
    @IBOutlet weak var img62: UIImageView!
    @IBOutlet weak var img63: UIImageView!
    @IBOutlet weak var img64: UIImageView!
    @IBOutlet weak var img65: UIImageView!
    @IBOutlet weak var img66: UIImageView!
    @IBOutlet weak var img67: UIImageView!
    
    @IBOutlet weak var img70: UIImageView!
    @IBOutlet weak var img71: UIImageView!
    @IBOutlet weak var img72: UIImageView!
    @IBOutlet weak var img73: UIImageView!
    @IBOutlet weak var img74: UIImageView!
    @IBOutlet weak var img75: UIImageView!
    @IBOutlet weak var img76: UIImageView!
    @IBOutlet weak var img77: UIImageView!
    
    var images: [[UIImageView]]!
    var paths2Reach : [Path] = [Path]()
    var pathNum : Int = 0
    var currentPathIndex : Int = 0
    var isAnimationFilished : Bool = true
    
    let chessPoints : [[Point]] = [
        [Point(x: 0, y: 0),Point(x: 30, y: 0),Point(x: 60, y: 0),Point(x: 90, y: 0),Point(x: 120, y: 0),Point(x: 150, y: 0),Point(x: 180, y: 0),Point(x: 210, y: 0)],
        [Point(x: 0, y: 30),Point(x: 30, y: 30),Point(x: 60, y: 30),Point(x: 90, y: 30),Point(x: 120, y: 30),Point(x: 150, y: 30),Point(x: 180, y: 30),Point(x: 210, y: 30)],
        [Point(x: 0, y: 60),Point(x: 30, y: 60),Point(x: 60, y: 60),Point(x: 90, y: 60),Point(x: 120, y: 60),Point(x: 150, y: 60),Point(x: 180, y: 60),Point(x: 210, y: 60)],
        [Point(x: 0, y: 90),Point(x: 30, y: 90),Point(x: 60, y: 90),Point(x: 90, y: 90),Point(x: 120, y: 90),Point(x: 150, y: 90),Point(x: 180, y: 90),Point(x: 210, y: 90)],
        [Point(x: 0, y: 120),Point(x: 30, y: 120),Point(x: 60, y: 120),Point(x: 90, y: 120),Point(x: 120, y: 120),Point(x: 150, y: 120),Point(x: 180, y: 120),Point(x: 210, y: 120)],
        [Point(x: 0, y: 150),Point(x: 30, y: 150),Point(x: 60, y: 150),Point(x: 90, y: 150),Point(x: 120, y: 150),Point(x: 150, y: 150),Point(x: 180, y: 150),Point(x: 210, y: 150)],
        [Point(x: 0, y: 180),Point(x: 30, y: 180),Point(x: 60, y: 180),Point(x: 90, y: 180),Point(x: 120, y: 180),Point(x: 150, y: 180),Point(x: 180, y: 180),Point(x: 210, y: 180)],
        [Point(x: 0, y: 210),Point(x: 30, y: 210),Point(x: 60, y: 210),Point(x: 90, y: 210),Point(x: 120, y: 210),Point(x: 150, y: 210),Point(x: 180, y: 210),Point(x: 210, y: 210)]
    ]
    var keepPoint : Point!
    func setPaths(paths2Reach : [Path]) {
        self.paths2Reach = paths2Reach
        pathNum = paths2Reach.count
    }
    
    func recurAnim(indexPath : Int, indexPoint : Int, destinationx  : CGFloat, destinationy : CGFloat, imageV : UIImageView) {
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .init(), animations: {
            
            imageV.frame.origin.y = destinationy
            imageV.frame.origin.x = destinationx
        }) { (complete) in
            
            self.textView.text.append("\(self.paths2Reach[indexPath].p[(indexPoint)].y)-\(self.paths2Reach[indexPath].p[(indexPoint)].x)\n")
            
            if (indexPoint) < self.paths2Reach[indexPath].p.count-1 {
                let x = self.chessPoints[self.paths2Reach[indexPath].p[(indexPoint + 1)].y][self.paths2Reach[indexPath].p[(indexPoint + 1)].x].x
                let y = self.chessPoints[self.paths2Reach[indexPath].p[(indexPoint + 1)].y][self.paths2Reach[indexPath].p[(indexPoint + 1)].x].y
                var destinationY:CGFloat = CGFloat(y)
                var destinationX:CGFloat = CGFloat(x)
                self.recurAnim(indexPath: indexPath, indexPoint: indexPoint+1, destinationx: destinationX, destinationy: destinationY,imageV: imageV)
            }else{
                imageV.frame.origin.x = CGFloat(self.keepPoint.x)
                imageV.frame.origin.y = CGFloat(self.keepPoint.y)
                self.isAnimationFilished = true
            }
            print("Filished!")
        }
    }
    
    func startAnimatePath(index : Int) {
        if (index < pathNum) && isAnimationFilished {
            
            self.textView.text = ""
            self.pathLabel.text = ""
            self.isAnimationFilished = false
            pathLabel.animationType = .fade
            pathLabel.placeHolderColor = .gray
            pathLabel.text = "Path \(index+1)/\(pathNum)"
            pathLabel.startAnimation(duration: 0.7, nil)
            images[self.paths2Reach[index].p[0].y][self.paths2Reach[index].p[0].x].image = UIImage(named: "wn")
            
            let x = self.chessPoints[self.paths2Reach[index].p[1].y][self.paths2Reach[index].p[1].x].x
            let y = self.chessPoints[self.paths2Reach[index].p[1].y][self.paths2Reach[index].p[1].x].y
            var destinationY:CGFloat = CGFloat(y)
            var destinationX:CGFloat = CGFloat(x)
            keepPoint = Point(x: self.chessPoints[self.paths2Reach[index].p[0].y][self.paths2Reach[index].p[0].x].x, y: self.chessPoints[self.paths2Reach[index].p[0].y][self.paths2Reach[index].p[0].x].y)
            
            self.textView.text = ""
            recurAnim(indexPath: index, indexPoint: 0, destinationx: destinationX, destinationy: destinationY,imageV: images[self.paths2Reach[index].p[0].y][self.paths2Reach[index].p[0].x])
            
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [
            [img00,img01,img02,img03,img04,img05,img06,img07],
            [img10,img11,img12,img13,img14,img15,img16,img17],
            [img20,img21,img22,img23,img24,img25,img26,img27],
            [img30,img31,img32,img33,img34,img35,img36,img37],
            [img40,img41,img42,img43,img44,img45,img46,img47],
            [img50,img51,img52,img53,img54,img55,img56,img57],
            [img60,img61,img62,img63,img64,img65,img66,img67],
            [img70,img71,img72,img73,img74,img75,img76,img77]
        ]
        for i in 0...7 {
            for j in 0...7 {
                images[i][j].image = nil
            }
        }
        self.textView.text = ""
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pathLabel.text = "Path"
        //        UIView.animate(withDuration: 0.9) {
        //            self.img00.frame.origin.y = destinationY
        //            self.img00.frame.origin.x = destinationX
        //        }
        
    }
    
    
}
