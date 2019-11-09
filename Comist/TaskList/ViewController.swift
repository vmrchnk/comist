//
//  ViewController.swift
//  Comist
//
//  Created by dewill on 29.10.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    let blackView = UIView()
    @IBAction func addTask(_ sender: Any) {
        let  createTaskView = Bundle.main.loadNibNamed(CreateTaskView.XIB_NAME, owner: self, options: nil)?[0] as? CreateTaskView
        if let createTaskV = createTaskView {
            createTaskV.frame = view.frame
            view.addSubview(createTaskV)
            createTaskV.taskCreated = { let controller = TaskVC(); self.present(controller, animated: true, completion: nil) }
        }
        
    }
    
    //        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    //        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideBlackView)))
    //        if let window = UIApplication.shared.keyWindow {
    //            window.addSubview(blackView)
    //            blackView.frame = window.frame
    //            blackView.alpha = 0
    //            UIView.animate(withDuration: 0.3, animations: {self.blackView.alpha = 1})
    //            window.addSubview(createTaskView)
    //            createTaskView.frame  = CGRect(x: 0, y: blackView.frame.maxY, width: window.frame.width, height: 300)
    //            UIView.animate(withDuration: 0.3, animations: {
    //                       self.createTaskView.frame = CGRect(x: 0, y: self.blackView.frame.maxY - 300, width: self.blackView.frame.width, height: self.blackView.frame.width)
    //
    //                   })
    //
    //        }
    
}

