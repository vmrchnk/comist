//
//  TaskVC.swift
//  Comist
//
//  Created by dewill on 07.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit
import CoreData

class TaskVC: UIViewController {
    
    //MARK:-> Outlet
    @IBOutlet weak var removeArgumentButton: UIButton!
    @IBOutlet weak var counterTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var argScoreLabel: UILabel!
    @IBOutlet weak var positiveArgView: ArgumentListView!
    @IBOutlet weak var negativeArgView: ArgumentListView!
    
    lazy var context = AppDelegate.viwContext
    var taskEntity:TaskEntity?
    
    // updating custom argument tables
    var positiveArgCount = 0
    {
        didSet {
            setupScoreLabel()
        }
    }
    var negativeArgCount = 0 {
        didSet {
            setupScoreLabel()
        }
    }
    var positiveArgsData = [ArgumentEntity](){
        didSet{
            positiveArgView.argList = positiveArgsData
        }
    }
    var negativeArgsData = [ArgumentEntity](){
        didSet{
            negativeArgView.argList = negativeArgsData
        }
    }
    
    
    //MARK:-> Lifecircle
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = Style.Color.voiletBackground.get()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupHeader()
        setupScrollView()
        setupAddArgumentViews()
        setupLocalaizedText()
        //fix it preficate
        getTaskEntity()
        
    }
    
    //MARK:-> setup UI
    private func setupHeader(){
        if let task = taskEntity {
            titleLabel.text = task.title
            descriptionLabel.text = task.taskDescription
        }
    }
    
    // The View for adding argument
    private func setupAddArgumentViews(){
        positiveArgView.setupView( color: Style.Color.greenBackground.get(), title: NSLocalizedString("task_vc_positive", comment: ""), titleAligment: .right, listLocation: .left)
        positiveArgView.delegate = self
        negativeArgView.setupView( color: Style.Color.redBackground.get(), title: NSLocalizedString("task_vc_negative", comment: ""), titleAligment: .left, listLocation: .right)
        negativeArgView.delegate = self
    }
    
    private func setupLocalaizedText(){
        counterTitleLabel.text = NSLocalizedString("task_vc_counter", comment: "")
    }
    private func setupScrollView(){
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
    }
    
    private func setupScoreLabel(){
        let scoreString = "\(positiveArgCount) | \(negativeArgCount)"
        argScoreLabel.text = scoreString
    }
    
    //MARK:-> Work with CoreDate
    private func getTaskEntity(){
        guard let task = taskEntity else { return }
        removeAllFromLocalArray()
        //fix it preficate
        let request: NSFetchRequest = TaskEntity.fetchRequest()
        //        let predicate = NSPredicate(format: "timestemp = %lld",  task.timestamp )
        //        request.predicate = predicate
        do{
            let taskList = try context.fetch(request)
            taskEntity = taskList.filter({$0.timestamp == task.timestamp}).first
            guard let task = taskEntity else { return }
            sortArgumentByType(in: task)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func sortArgumentByType(in entity: TaskEntity){
        removeAllFromLocalArray()
        for args  in taskEntity!.argument!  as! Set<ArgumentEntity>{
            //Force unwrapping cause Type is not optional
            let type:ComistType = ComistType(rawValue: Int(args.type))!
            switch type {
            case .none : print(0)
            case .positive : self.positiveArgsData.append(args);
            positiveArgCount =  positiveArgCount + Int(args.value)
            case .negative:  self.negativeArgsData.append(args);
            negativeArgCount = negativeArgCount + Int(args.value)
            }
        }
    }
    
    private func removeAllFromLocalArray(){
        resetCounter()
        positiveArgsData.removeAll()
        negativeArgsData.removeAll()
    }
    
    private func resetCounter(){
        positiveArgCount = 0
        negativeArgCount = 0
    }
    
    private func addArgumentToTaskInStore(type: ComistType, text:String, value: Int){
        let newArgument = ArgumentEntity.createArgEntity(type: type, text: text, value: value, in: context)
        guard let currentTask = taskEntity else {return }
        currentTask.addToArgument(newArgument)
        sortArgumentByType(in: currentTask)
        var state = ComistType.none
        if positiveArgCount > negativeArgCount {
            state = ComistType.positive
        }else if negativeArgCount > positiveArgCount {
            state = ComistType.negative
        }
        print(state)
        currentTask.state = Int16(state.rawValue)
        TaskEntity.update(new: currentTask, in: context)
        getTaskEntity()
    }
    
    private func update(_ entity: ArgumentEntity, with text: String, and value: Int){
        entity.text = text
        entity.value = Int64(value)
        taskEntity?.addToArgument(entity)
        guard let updatedEntity = taskEntity else { return }
        TaskEntity.update(new: updatedEntity, in: context)
        getTaskEntity()
    }
    
    private func initAddArgumentView() -> AddArgumentView{
        let addArgView = AddArgumentView()
        addArgView.frame = view.frame
        view.addSubview(addArgView)
        return addArgView
    }
    
    
    //MARK: -> Actions
    @IBAction func onBackButtonClick(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    
    var isEditModeActive = false {
        didSet {
            positiveArgView.tableView.setEditing(isEditModeActive, animated: true)
            negativeArgView.tableView.setEditing(isEditModeActive, animated: true)
        }
    }
    @IBAction func onDeleteTapped(_ sender: Any) {
        if isEditModeActive {
            removeArgumentButton.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        }else {
            removeArgumentButton.setImage(#imageLiteral(resourceName: "remove_selected"), for: .normal)
        }
        isEditModeActive = !isEditModeActive
    }
}


//MARK:-> ArgumentListViewDelegate
extension TaskVC : ArgumentListViewDelegate {
    
    func delete(argument: ArgumentEntity) {
        taskEntity?.removeFromArgument(argument)
        guard let updatedTask = taskEntity else { return }
        TaskEntity.update(new: updatedTask, in: context)
        getTaskEntity()
    }
    
    func edit(argument: ArgumentEntity) {
        let addArgView = initAddArgumentView()
        addArgView.argumentTextField.text = argument.text
        let type = ComistType(rawValue: Int(argument.type))
        if type == ComistType.positive  {
            addArgView.contentViewBackgroundColor = #colorLiteral(red: 0.1882352941, green: 0.4980392157, blue: 0.1294117647, alpha: 1)
        }else {
            addArgView.contentViewBackgroundColor = #colorLiteral(red: 0.462745098, green: 0.1098039216, blue: 0.0431372549, alpha: 1)
        }
        addArgView.createArgCallback = { [weak self] (text, value) in
            self?.update(argument, with: text, and: value)
        }
    }
    
    
    func creatingArgument(_ sender: UIButton){
        let addArgView = initAddArgumentView()
        
        // We don't know what is view (positive/ negative) that's why use this way to find it.
        // 0.0 - posisive
        // else negative
        var type : ComistType = .none
        if scrollView.contentOffset.x == 0.0 {
            addArgView.contentViewBackgroundColor = #colorLiteral(red: 0.1882352941, green: 0.4980392157, blue: 0.1294117647, alpha: 1)
            type = .positive
        }else {
            addArgView.contentViewBackgroundColor = #colorLiteral(red: 0.462745098, green: 0.1098039216, blue: 0.0431372549, alpha: 1)
            type = .negative
        }
        addArgView.createArgCallback = { [weak self] (text, value) in
            self?.addArgumentToTaskInStore(type: type, text: text, value: value)
        }
    }
    
}

//MARK:-> UIGestureRecognizerDelegate
extension TaskVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
