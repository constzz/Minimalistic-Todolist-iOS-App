import UIKit
import CoreData

class CategoriesViewController: UITableViewController {
        
    private var categoryItems: [Category] = [] {
        didSet {
            saveContext()
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func onAddCatgoryButtonClicked(_ sender: Any) {
        showAddCategoryAlert()
    }
    
    private func addNewCategory(categoryName: String) {
        let newCategory = Category(context: self.context)
        newCategory.title = categoryName
        setupNewCategories()
    }

    private func showAddCategoryAlert() {
        showGetInputAlert(title: "New category", inputTextFieldPlacholder: "Type a name of cateogry") { [weak self] categoryName in
            self?.addNewCategory(categoryName: categoryName)
        }
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CategoriesToTodoList":
            let destination = segue.destination as! ToDoTableViewController
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
                destination.selectedCategory = categoryItems[selectedRowIndexPath.row]
            }
        default:
            ()
        }
    }
}

//MARK: Core Data
extension CategoriesViewController {
    private func setupNewCategories() {
        if let categoryItems =  try? self.fetchEntities(with: NSFetchRequest<Category>(entityName: "Category")) {
            self.categoryItems = categoryItems
        }
    }
    private func loadCategories() {
        if let categoryItems = try? fetchEntities(with: NSFetchRequest<Category>(entityName: "Category")) {
            self.categoryItems = categoryItems
        }
    }
}

//MARK: TableView Delegate
extension CategoriesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategoriesToTodoList" , sender: self)
    }
}
//MARK: TableView Data Source
extension CategoriesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category")
        if let cell = cell {
            cell.textLabel?.text = categoryItems[indexPath.row].title
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryItems.count
    }
}

