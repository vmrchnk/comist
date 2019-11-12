//
//  CreateTaskView.swift
//  Comist
//
//  Created by dewill on 29.10.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class CreateTaskView: UIView {
    
    var taskCreated: ((String, String) -> Void)?
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLable: UITextField!
    
    static let XIB_NAME = "CreateTaskView"
    
    let animationDuration = 0.4
    private var isKeyboardShowing = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.delegate = self
        taskView.layer.cornerRadius = 15
        self.taskView.frame = CGRect(x: 0, y: self.frame.maxY  , width: self.taskView.frame.width, height: self.taskView.frame.height)
        startAnimation(for: taskView, relativeTo: self.frame.maxY - self.taskView.frame.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registrateNotificationCenterObserver()
        
}
    
    private func registrateNotificationCenterObserver(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    @objc func closeView(_ sender: UITapGestureRecognizer){
        let tapPoint =  sender.location(in: self)
        if taskView.frame.contains(tapPoint) { return }
        self.endEditing(true);
        isKeyboardShowing = false
        startAnimation(for: taskView, relativeTo: self.frame.maxY, completion: {_ in self.completionBlock() })
    }
    
    private func completionBlock(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        self.removeFromSuperview()
    }
    
    @IBAction func pressedCreatingTaskButton(_ sender: Any) {
        errorView.isHidden  = false
        errorView.frame = CGRect(x: 0, y: -self.errorView.frame.height, width: self.errorView.frame.width, height: self.errorView.frame.height)
        if titleLable.text == "" || titleLable.text  == defaultTitle {
            validateBeforeCreating()
        } else {
            taskCreated?.self(titleLable.text!, descriptionTextView.text)}
        
    }
    
    private func validateBeforeCreating(){
        startAnimation(for: errorView, relativeTo: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.startAnimation(for: self.errorView, relativeTo: -self.errorView.frame.height, completion: {_ in self.errorView.isHidden = true})
        }
    }
        
        @objc func keyBoardWillShow(notification: NSNotification) {
            guard !isKeyboardShowing else { return }
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                isKeyboardShowing = true
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                print(  self.taskView.frame.maxY)
                startAnimation(for: taskView, relativeTo: self.taskView.frame.minY - keyboardHeight + 20)
            }
        }
        
        
        private func startAnimation(for view: UIView, relativeTo y: CGFloat, completion: ((Bool) -> Void)? = nil){
            UIView.animate(withDuration: animationDuration, animations: {
                view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
            }, completion: completion)
        }
        
        
        private let defaultTitle = "enter title here."
        @IBAction func inputtigTaskTitle(_ sender: UITextField) {
            if sender.text == defaultTitle {
                sender.text = ""
            }
        }
        
    }
    
    
    extension CreateTaskView: UITextViewDelegate {
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.tintColor = .black
            if textView.text == "enter description here." {
                textView.text = ""
            }
        }
}

