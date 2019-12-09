//
//  ArgumentListView.swift
//  Comist
//
//  Created by dewill on 18.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class ArgumentListView: UIView {
    
    //MARK:-> Outlet
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var delegate:ArgumentListViewDelegate? = nil
    var argList = [ArgumentEntity]() {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
            tableView.reloadData()
            
        }
    }
    
    
    //MARK:-> init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    
    //MARK:-> setup UI
    private func loadViewFromNib(){
        let myView = Bundle.main.loadNibNamed("ArgumentListView", owner: self, options: nil)![0] as! UIView
        self.addSubview(myView)
        fixSize()
        contentView.backgroundColor = .clear
        registerCell()
        tableView.dataSource   = self
        tableView.delegate = self
    }
    
    
    func setupBackgroundImage(_ image: UIImage, with color: UIColor = .clear){
        backgroundImageView.image = image.image(alpha: 0.2)
        backgroundImageView.backgroundColor = color
    }
    
    // method for setting up all view's property from another class
    func setupView( color: UIColor = .clear, title: String, titleAligment: NSTextAlignment = .center, listLocation: ListLocation){
        setupBackgroundImage(UIImage(), with: color)
        titleView.text = title
        titleView.isHighlighted = true
        titleView.textAlignment = titleAligment
//        setRoundedBorder(for: tableView, location: listLocation)
        setRoundedBorder(for: backgroundImageView, location: listLocation )
    }
    
    private func setRoundedBorder(for view: UIView, location: ListLocation){
        view.layer.cornerRadius = 20
        if location == .left {
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]}
        else {
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
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
    
    private func registerCell(){
        tableView.register(UINib(nibName: "ArgumentTableViewCell", bundle: nil) , forCellReuseIdentifier:ArgumentTableViewCell.identifier )
    }
    
    
    
    //MARK: -> Actions
    @IBAction func creatingArgument(_ sender: UIButton) {
        delegate?.creatingArgument(sender)
    }
    
}

// enum for views location on container view
enum ListLocation {
    case left, right
}


protocol ArgumentListViewDelegate {
    // method for showing create arg form
    func creatingArgument(_ sender: UIButton)
    func edit(argument: ArgumentEntity)
    func delete(argument: ArgumentEntity)
}

extension ArgumentListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        argList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArgumentTableViewCell.identifier, for: indexPath) as! ArgumentTableViewCell
        let currentArg = argList[indexPath.item]
        cell.argTextLabel.text = currentArg.text ?? ""
        cell.valueLabel.text = String(currentArg.value)
        cell.setTextColor(value: Int(currentArg.value))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentArgument = argList[indexPath.item]
        delegate?.edit(argument: currentArgument)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletingArgument = argList[indexPath.item]
        delegate?.delete(argument: deletingArgument)
    }
    
}
