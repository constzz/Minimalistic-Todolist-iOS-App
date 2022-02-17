import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var selectedCategory: Category? {
        didSet {
            if let selectedCategory = selectedCategory {
                navigationItem.title = selectedCategory.title
            }
        }
    }
    
    private var items: [TodoEntity] = [] {
        didSet {
            saveContext()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadTodoEntities()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    

    @IBAction func onAddButtonClicked(_ sender: UIBarButtonItem) {
        showTodoAlert()
    }
    
    private func showTodoAlert() {
        showGetInputAlert(title: "Add todo", inputTextFieldPlacholder: "Type the name of the task") { [weak self] todoName in
            self?.addNewTodoEntity(title: todoName)
        }
    }
    
    private func addNewTodoEntity(title: String) {
        let newTodo = TodoEntity(context: self.context)
        newTodo.title = title
        newTodo.done = false
        newTodo.category = self.selectedCategory
        self.loadTodoEntities(searchQuery: nil)
    }
    

}

//MARK: Core Data
extension ToDoTableViewController {
    private func loadTodoEntities(searchQuery: String? = nil) {
        if let selectedCategory = selectedCategory {
            let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
            var predicates: [NSPredicate] = []
            predicates.append(NSPredicate(format: "category.title MATCHES %@", selectedCategory.title ?? ""))
            if let searchQuery = searchQuery {
                predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchQuery))
            }
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
            request.sortDescriptors = [NSSortDescriptor(key: "done", ascending: true)]
            self.items = try! fetchEntities(with: request)
        }
    }
}

//MARK: TableView Data Source
extension ToDoTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableIndentifier")
        if let cell = cell {
            cell.textLabel?.text = items[indexPath.row].title
            cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

//MARK: TableView Delegate
extension ToDoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = tableView.cellForRow(at: indexPath)
        let newCheckmarkState = selectedRow?.accessoryType == .checkmark ? UITableViewCell.AccessoryType.none : .checkmark
        items[indexPath.row].done = newCheckmarkState == .checkmark
        selectedRow?.accessoryType = newCheckmarkState
        saveContext()
        loadTodoEntities()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UISearchBarDelegate Delegate
extension ToDoTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadTodoEntities()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            loadTodoEntities(searchQuery: searchText)
        }
    }
}


