//
//  ViewController.swift
//  Flo
//
//  Created by COUTO, TIAGO [AG-Contractor/1000] on 10/19/18.
//  Copyright © 2018 Couto Code. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var isGraphShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)  
    }
    
    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        
        if isGraphShowing {
            counterViewTap(nil)
        }
    }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if isGraphShowing {
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        }
        isGraphShowing = !isGraphShowing
    }

}

