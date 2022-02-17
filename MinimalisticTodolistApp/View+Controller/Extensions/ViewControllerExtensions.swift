import UIKit

extension UIViewController {
    
    func showGetInputAlert(
        title: String,
        message: String? = nil,
        inputTextFieldPlacholder: String,
        animated: Bool = true,
        actions: [UIAlertAction]? = nil,
        completionHandler: @escaping (String) -> Void
    ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { uiTextField in
            uiTextField.placeholder = inputTextFieldPlacholder
            textField = uiTextField
        }
        if let actions = actions, !actions.isEmpty {
            actions.forEach { action in
                alert.addAction(action)
            }
        }
        alert.addAction(UIAlertAction.init(title: "Add", style: .default) { _ in
            completionHandler(textField.text ?? "")
        })
        present(alert, animated: true)
    }
    
}

