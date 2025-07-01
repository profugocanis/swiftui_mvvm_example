import UIKit

class CustomNavigationController: UINavigationController {
    
    override var prefersStatusBarHidden: Bool { false }
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
    
    private let customNavigationTransactionHelper = CustomNavigationTransactionHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationTransactionHelper.setup(self)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
    }
}
