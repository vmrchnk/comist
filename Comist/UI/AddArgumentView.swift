//
//  AddArgumentView.swift
//  Comist
//
//  Created by dewill on 22.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class AddArgumentView: UIView {
    @IBOutlet weak var addArguemntFormView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var valuePicker: UIPickerView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var argumentTextField: UITextField!
    
    var createArgCallback: ((String, Int) -> Void)?
    
    private var isKeyboardShowing = false
    
    private var pickerData = ["1", "2", "3"]
    private var defaultInputFieldTitle = NSLocalizedString("ad_arg_title_text", comment: "")
    private var selectedPickerValue = 1
    var contentViewBackgroundColor: UIColor? {
        didSet {
            self.addArguemntFormView.backgroundColor = contentViewBackgroundColor
        }
    }
    
    @IBAction func savingArgument(_ sender: Any) {
        createArgCallback?.self(argumentTextField.text! ,selectedPickerValue)
        self.endEditing(true)
        self.removeFromSuperview()
        
    }
    let animationDuration = 0.4
    
    //MARK:-> init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        loadViewFromNib()
        fixSize()
        setupPicker()
        registrateNotificationCenterObserver()
        contentView.backgroundColor  = UIColor.black.withAlphaComponent(0.3)
        addArguemntFormView.layer.cornerRadius = 15
        addArguemntFormView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if argumentTextField.text == "" {  argumentTextField.text = defaultInputFieldTitle }
        setupLocalizedText()
        //animation
        self.addArguemntFormView.frame = CGRect(x: 0, y: self.frame.maxY  , width: self.addArguemntFormView.frame.width, height: self.addArguemntFormView.frame.height)
        startAnimation(for: addArguemntFormView, relativeTo: self.frame.maxY -
            self.addArguemntFormView.frame.height)
    }
    
    private func setupLocalizedText(){
        titleLabel.text = NSLocalizedString("ad_arg_title", comment: "")
        valueLabel.text  = NSLocalizedString("ad_arg_value", comment: "")
    }
    
    
    private func loadViewFromNib(){
        let myView = Bundle.main.loadNibNamed("AddArgumentView", owner: self, options: nil)![0] as! UIView
        self.addSubview(myView)
    }
    
    private func setupPicker(){
        valuePicker.delegate = self
        valuePicker.dataSource = self
    }
    
    
    func fixSize(){
        self.contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 500)
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func registrateNotificationCenterObserver(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    @objc func closeView(_ sender: UITapGestureRecognizer){
        let tapPoint =  sender.location(in: self)
        if addArguemntFormView.frame.contains(tapPoint) { return }
        self.endEditing(true);
        isKeyboardShowing = false
        startAnimation(for: addArguemntFormView, relativeTo: self.frame.maxY, completion: {_ in self.completionBlock() })
    }
    
    private func completionBlock(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        self.removeFromSuperview()
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        guard !isKeyboardShowing else { return }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardShowing = true
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(  self.addArguemntFormView.frame.maxY)
            startAnimation(for: addArguemntFormView, relativeTo: self.addArguemntFormView.frame.minY - keyboardHeight + 20)
        }
    }
    
    private func startAnimation(for view: UIView, relativeTo y: CGFloat, completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: animationDuration, animations: {
            view.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height)
        }, completion: completion)
    }
    
    @IBAction func onAddArgumetFieldClicked(_ sender: UITextField) {
        if sender.text == defaultInputFieldTitle {
            sender.text = ""
        }
    }
    
    
    
    
    
}

extension AddArgumentView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerValue = Int(pickerData[pickerView.selectedRow(inComponent: 0)]) ?? 1
    }
}




