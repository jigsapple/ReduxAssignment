//
//  TaskListViewController.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReSwift

class TaskListViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    var tasks = BehaviorSubject(value: [SectionModel(model: "", items: [Task]())])
    private var bag = DisposeBag()
    var mainCoordinator: MainCoordinator?
    
    lazy var tableView : UITableView = {
        let tblView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Tasks"
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        self.view.addSubview(tableView)
        
        //subscribe to store
        mainStore.subscribe(self)
        
        //fetching data
        mainStore.dispatch(fetchTasksThunk)
        
        //tableView Rx binding
        bindTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //unsubscribe from store
        mainStore.unsubscribe(self)
    }
    
    //protocol confirm from storeSubcscriber
    func newState(state: AppState) {
        let secondSection = SectionModel(model: "My Tasks", items: state.taskData)
        self.tasks.on(.next([secondSection]))
    }
    
    @objc func onTapAdd() {
        let testTask = Task(title: "taskno - \(Int(arc4random_uniform(2000)))", isFinished: false)
        mainStore.dispatch(AppAction.addTask(task: testTask))
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Task>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            if item.isFinished ?? false {
                cell.textLabel?.attributedText = item.title?.strikeThrough()
            } else {
                cell.textLabel?.attributedText = NSAttributedString(string: item.title ?? "")
            }
            return cell
        } titleForHeaderInSection: { dataSorce, sectionIndex in
            return dataSorce[sectionIndex].model
        }

        self.tasks.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            guard self != nil else { return }
            mainStore.dispatch(AppAction.deleteTask(indexAt: indexPath.row))
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Are you Sure ?", message: "is this task finished ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                mainStore.dispatch(AppAction.makeItFinished(indexAt: indexPath.row))
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}

extension TaskListViewController : UITableViewDelegate { }
