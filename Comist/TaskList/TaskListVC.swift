//
//  ViewController.swift
//  Comist
//
//  Created by dewill on 29.10.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import CoreData
import UIKit
import Lottie

class TaskListVC: UIViewController {
    
    
    //MARK:-> Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    lazy var context = AppDelegate.viwContext
    var fetchedResultsController: NSFetchedResultsController<TaskEntity>?{
        didSet {
        }
    }
    
    var sectionCount = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:-> Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = Style.Color.voiletBackground.get()
        reqisterCell()
        configuratingTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSavedDate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//
//    private func showEmptyState(){
//        if fetchedResultsController?.fetchedObjects?.count == 0 {
//            emptyStateView.isHidden = false
//            emptyStaeAnimationView.play()
//        }else {
//            emptyStateView.isHidden = true
//        }
//    }
    
    //MARK:-> Config tableView, Cell
    private func configuratingTableView(){
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func reqisterCell(){
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: TaskTableViewCell.indentifier)
    }
    
    private func loadSavedDate(){
        if fetchedResultsController == nil {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let sort = NSSortDescriptor(key: "timestamp", ascending: false)
            let sortByTape  = NSSortDescriptor(key: "state", ascending: true)
            request.sortDescriptors = [sortByTape, sort]
            fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "state", cacheName: nil)
            fetchedResultsController?.delegate = self
        }
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print("ViewController.loadSaveDate \(error.localizedDescription)")
        }
        showEmptyState()
    }
    
    private func showEmptyState(){
  print("SHOW EMPTY STATE")
//          emptyStateView.isHidden = fetchedResultsController?.fetchedObjects?.count ?? 0 > 0 ? true : false
        
        if  fetchedResultsController?.fetchedObjects?.count ?? 0 > 0 {
            UIView.animate(withDuration: 0.4/*Animation Duration second*/, animations: {
                 self.emptyStateView.alpha = 0
                self.emptyStateView.frame = CGRect(x: self.emptyStateView.frame.maxX, y: self.emptyStateView.frame.minY, width: self.emptyStateView.bounds.width, height: self.emptyStateView.bounds.height)
            }, completion:  {
               (value: Bool) in
                   self.emptyStateView.isHidden = true
            })
        }
        else {
            self.emptyStateView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.emptyStateView.frame = CGRect(x: self.view.frame.minX, y: self.emptyStateView.frame.minY, width: self.emptyStateView.bounds.width, height: self.emptyStateView.bounds.height)
                     self.emptyStateView.alpha = 1
                }, completion:  nil)
        }
    }
    
    
    
    
    //MARK:-> Actions
    //show Create taskView
    @IBAction func addTaskTapped(_ sender: Any) {
        //Loadnig from Xib
        let  createTaskView = Bundle.main.loadNibNamed(CreateTaskView.XIB_NAME, owner: self, options: nil)?[0] as? CreateTaskView
        if let createTaskV = createTaskView {
            createTaskV.frame = view.frame
            view.addSubview(createTaskV)
            creatingNewTask(from: createTaskV)
        }
    }
    
    @IBAction func onDeleteModeOnTapped(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        }else {
             tableView.setEditing(true, animated: true)
            sender.setImage(#imageLiteral(resourceName: "remove_selected"), for: .normal)
        }
    }
    
    
    
    private func creatingNewTask(from createTaskV : CreateTaskView){
        createTaskV.taskCreated = { [weak self] (title, description) in
            //create TaskModel
            guard let self = self else { return }
            // storing in CoreDate
           let createdTask = TaskEntity.createTask(title: title, descrpiption: description, in: self.context)
            // go to new screen
            let vc = TaskVC()
            vc.taskEntity = createdTask
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}


//MARK:-> UITableViewDelegate, UITableViewDataSource
extension TaskListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController!.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = PaddingUILabel()
        myLabel.frame = CGRect(x: 8, y: 0, width: self.view.frame.width, height: 50)
        myLabel.font = UIFont(name: "Comfortaa-Light", size: 20)
        //todo add padding
        if  let section = fetchedResultsController?.sections?[section] {
            let sectionRawValue = Int(section.name)
            let type = ComistType(rawValue: sectionRawValue!)
            myLabel.text = type?.getTitle()
        }
        myLabel.bottomInset = 20
        myLabel.textColor = .white
        let headerView = UIView()
        headerView.backgroundColor =  Style.Color.voiletBackground.get()
        headerView.addSubview(myLabel)
    
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.indentifier, for: indexPath) as! TaskTableViewCell
        let task = fetchedResultsController!.object(at: indexPath)
        cell.task = task
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let commit = fetchedResultsController?.object(at: indexPath)
        context.delete(commit!)
        do {
            try context.save();
        } catch {
            print("TaskList.tableView -> \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskVC(nibName: "TaskVC", bundle: nil)
        if let task = fetchedResultsController?.object(at: indexPath){
            vc.taskEntity = task
        }
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

//MARK: -> NSFetchedResultsControllerDelegate
extension TaskListVC : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            
            //todo add animation (tableView.remeItemsAtRow)
            tableView.reloadData()
            showEmptyState()
            
        default:
            break
        }
    }
}




