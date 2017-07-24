//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Keith Knight on 7/20/17.
//  Copyright © 2017 Living Green. All rights reserved.
//

/////////////////////
// MASTER CONTROLLER 
/////////////////////

import UIKit

class EmotionsViewController: UIViewController {

    /*
        viewDidLoad and didReceiveMemoryWarning are part of the ViewController life cycle
    */
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    
    // MARK: - Navigation  This is used to segue from this MVC to another MVC. It prepares the other MVC

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /*
         Need to cast with casting mechanism As because segue is this generic UIStoryboardSegue, it
         does not know about faceViewController or emotionViewController.
         We use the As cast with Any.
         It needs to be a faceViewController or we don't know how to prepare it.
         */
        let destinationViewController = segue.destination
        if let faceViewController = destinationViewController as? FaceViewController {
            /* 
             the as? is conditionally checking to see if destinationViewController can be cast to a FaceViewController
             if not... then prepare will do nothing and let that destinationViewController appear unprepared because we only know how to prepare a FaceViewController. Could set as? as a as! and let it crash
             */
            if let identifier = segue.identifier {  // check to make sure segue identifier has been set
                // expression set here (model change)
                if let expression = emotionalFaces[identifier] {
                    // set the model (which will call didSet updateUi and update the View
                    faceViewController.expression = expression
                }
            }
        }
    }
 
    // private dictionary to match the segue name to an expression (key, value)
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]

}
