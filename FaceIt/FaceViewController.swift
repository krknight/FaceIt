//
//  ViewController.swift
//  FaceIt
//
//  Created by Keith Knight on 7/2/17.
//  Copyright © 2017 Living Green. All rights reserved.
//

//////////////
// CONTROLLER
//////////////


import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .open, mouth: .neutral)  { // Controller to Model cnxn
        didSet { // property observers can be used on any var. If var changes then execute
            updateUI(); // Not called on init, only when expression changes
        }
    }
    
    @IBOutlet weak var inYourFaceMuffin: FaceView! {
        didSet {   // property observer
            ///////////////////////////////////////////////////////////////////////
            // Gesture pinch, expand, tap recognizer
            // Start
            ///////////////////////////////////////////////////////////////////////
            
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            
            // need the target and the recognizer (action)
            let pinchRecognizer = UIPinchGestureRecognizer(target: inYourFaceMuffin , action: handler)
            // the action is FaceView.changeScale handler
            inYourFaceMuffin.addGestureRecognizer(pinchRecognizer)
            
            // Tap recognizer
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            inYourFaceMuffin.addGestureRecognizer(tapRecognizer)
            
            // Swipe recognizer
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            inYourFaceMuffin.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            inYourFaceMuffin.addGestureRecognizer(swipeDownRecognizer)
            
            
            
            ///////////////////////////////////////////////////////////////////////
            // Gesture pinch, expand, tap trecognizer
            // End
            ///////////////////////////////////////////////////////////////////////
            
            updateUI()  // gets called when iOS makes this connection
        }      
    }
    
    
    // Gesture tap open/close eyes handler
    func toggleEyes (byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            // Now change the model ‘var expression’ which will invoke didSet below
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }

    // Gesture swipe to change happiness handler. Note: no params because a swipe is discrete
    func increaseHappiness () {
        expression = expression.happier
    }
    func decreaseHappiness() {
        expression = expression.sadder
    }

    
    // Call updateUi() everytime the model changes. If the expression changes in the model
    // FacialExpression.swift we must update our UI. Do this using a property observer.
    
    // make the model FacialExpression match the UI (the view FaceView.swift))
    // to do this need to deal with the eyes and the mouth
    private func updateUI()
    {
        switch expression.eyes {  // model
        case .open:
            inYourFaceMuffin?.eyesOpen = true  // view  note: faceView is nil until it gets wired up by iOS
        case .closed:
            inYourFaceMuffin?.eyesOpen = false // view
        case .squinting:
            inYourFaceMuffin?.eyesOpen = false // view
        }
        
        // To avoid a crash caused by use optional chaining ‘?’. faceView?.eyesOpen = true
        // if faceView evaluates to nil then the rest of the line is ignored
        // Good practice to protect your updateUI() in case your outlets are not set.
        
        inYourFaceMuffin?.mouthCurvature = mouthCurvatures[expression.mouth]  ?? 0x0 // model init to grin
        // Double = optional double  i.e. Double?  so get an error
        // expression.mouth returns Double? because it might not be in the dictionary
        // so use defaulting e.g. ?? 0.0 … if we can’t find expression.mouth we will have neutral
        //  mouth
        
    }
    
    // Create a dictionary of FacialExpression.mouthposition as model and value as the view
    // This is a mapping data structure
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown:-1.0, .smile:1.0, .neutral: 0.0, .smirk:-0.5]
    
}


