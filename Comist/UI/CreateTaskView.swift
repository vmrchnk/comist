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
    @IBOutlet weak var errorViewLabel: UILabel!
    

    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    private let defaultTitle = NSLocalizedString("crate_task_defaultTitle", comment: "")
    private let defaultDescription = NSLocalizedString("create_task_enter_description", comment: "")
    
    static let XIB_NAME = "CreateTaskView"
    
    let animationDuration = 0.4
    private var isKeyboardShowing = false
    
    
    
    //MARK: -> standart method
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.delegate = self
        taskView.layer.cornerRadius = 15
        self.taskView.frame = CGRect(x: 0, y: self.frame.maxY  , width: self.taskView.frame.width, height: self.taskView.frame.height)
        startAnimation(for: taskView, relativeTo: self.frame.maxY - self.taskView.frame.height)
        setLocalizedText()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registrateNotificationCenterObserver()
    }
    
    private func setLocalizedText(){
        errorViewLabel.text = NSLocalizedString("input_error", comment: "eror, when title = nil")
        titleTextField.text = NSLocalizedString("Title", comment: "")
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionTextView.text = defaultDescription
        titleTextField.text = defaultTitle
        titleLabel.text = NSLocalizedString("Title", comment: "")
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
            startAnimation(for: taskView, relativeTo: self.taskView.frame.minY - keyboardHeight + 40)
        }
    }
    
    
    private func startAnimation(for view: UIView, relativeTo y: CGFloat, completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: animationDuration, animations: {
            view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
        }, completion: completion)
    }
    
    
    //MARK: -> Actions
    @IBAction func pressedCreatingTaskButton(_ sender: Any) {
        errorView.isHidden  = false
        errorView.frame = CGRect(x: 0, y: -self.errorView.frame.height, width: self.errorView.frame.width, height: self.errorView.frame.height)
        if titleTextField.text == "" || titleTextField.text  == defaultTitle {
            validateBeforeCreating()
        } else {
            if descriptionTextView.text == defaultDescription {
                descriptionTextView.text = ""
            }
            taskCreated?.self(titleTextField.text!, descriptionTextView.text)
            self.endEditing(true)
            self.removeFromSuperview()
        }
    }
    
    @IBAction func inputtigTaskTitle(_ sender: UITextField) {
        if sender.text == defaultTitle {
            sender.text = ""
        }
    }
    
}


//MARK:-> UITextViewDelegate
extension CreateTaskView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.tintColor = .black
        if textView.text == defaultDescription {
            textView.text = ""
        }
    }
}

