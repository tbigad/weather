
import UIKit

public extension UIViewController {
    func showAlertMessage(title:String, message:String, handle: @escaping (()->Void))  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button"), style: .default, handler: { _ in
            handle()
        }))
        present(alert, animated: true, completion: nil)
    }
}
