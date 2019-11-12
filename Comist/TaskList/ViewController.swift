//
//  ViewController.swift
//  Comist
//
//  Created by dewill on 29.10.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    
    //MARK:-> Outlets
    @IBOutlet weak var tableView: UITableView!
    
    lazy var context = AppDelegate.viwContext
    
    
    //MARK:-> Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        reqisterCell()
        configuratingTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingItemsFromDataStore()
    }
    
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
    
    
    private func loadingItemsFromDataStore(){
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do{
            let taskList = try context.fetch(request)
            print("TASK COUNT \(taskList.count)")
        }catch{
            print("ViewController.viewWillApera \(error.localizedDescription)")
        }
    }
    
    
    
    
    //MARK:-> Actions
    //show Create taskView
    @IBAction func addTask(_ sender: Any) {
        //Loadnig from Xib
        let  createTaskView = Bundle.main.loadNibNamed(CreateTaskView.XIB_NAME, owner: self, options: nil)?[0] as? CreateTaskView
        if let createTaskV = createTaskView {
            createTaskV.frame = view.frame
            view.addSubview(createTaskV)
            creatingNewTask(from: createTaskV)
        }
    }
    
    
    private func creatingNewTask(from createTaskV : CreateTaskView){
        createTaskV.taskCreated = { [weak self] (title, description) in
            //create TaskModel
            guard let self = self else { return }
             let taskModel = self.createTaskModel(with: title, and: description)
            // storeing in CoreDate
            TaskEntity.createTask(model: taskModel, in: self.context)
            // go to new screen
            let controller = TaskVC();
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
    private func createTaskModel(with title: String, and description: String) -> TaskModel {
        let task = TaskModel(title: title, description: description, positiveArgs: [ArgumentModel](), negativeArgs: [ArgumentModel]())
        return task
    }
}


//MARK:-> UITableViewDelegate, UITableViewDataSource
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        mockArray.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.indentifier, for: indexPath) as! TaskTableViewCell
        //        cell.task = mockArray[indexPath.item]
        return cell
    }
    
    
}


