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
        appearance.backgroundColor = .darkGray
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
        
//        navigationBar.isHidden = true
    }
}

