import SwiftUI

final class CustomNavigationTransactionHelper: NSObject {
    
    static let enableScrollViewTag = 3234234
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer!
    private weak var navigationController: CustomNavigationController?
    private var lastStatusBarStyle: UIStatusBarStyle = .lightContent
    private let isLeftToRight = UIApplication.shared.isLeftToRight ? true : false
    private var isBegan = false
    
    private let percentToFinish: CGFloat = 0.3
    private let velocityToFinish: CGFloat = 1200
    
    var isEnableGestureRecognizer: Bool = true {
        didSet {
            edgeSwipeGestureRecognizer?.isEnabled = isEnableGestureRecognizer
            panGesture?.isEnabled = isEnableGestureRecognizer
        }
    }
    
    func setup(_ navigationController: CustomNavigationController) {
        self.navigationController = navigationController
        navigationController.delegate = self

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        navigationController.view.addGestureRecognizer(panGesture)
        
        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer?.delegate = self
        edgeSwipeGestureRecognizer!.edges = isLeftToRight ? .left : .right
        navigationController.view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIPanGestureRecognizer) {
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width * (isLeftToRight ? 1 : -1)
        
        let velocityX = gestureRecognizer.velocity(in: gestureRecognizer.view).x * (isLeftToRight ? 1 : -1)

        if gestureRecognizer.state == .began && velocityX > 0 {
//            KeyboardManager.hideKeyboard()
            isBegan = true
            lastStatusBarStyle = navigationController?.statusBarStyle ?? .lightContent
            interactionController = UIPercentDrivenInteractiveTransition()
            interactionController?.completionCurve = .easeInOut
            navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if (percent > percentToFinish && gestureRecognizer.state != .cancelled) ||  velocityX > velocityToFinish {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
                if isBegan {
                    navigationController?.statusBarStyle = lastStatusBarStyle
                }
            }
            isBegan = false
            interactionController = nil
        }
    }
}

// MARK: NavigationControllerDelegate
extension CustomNavigationTransactionHelper: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop { return PushPopAnimator(presenting: false, isLeftToRight: isLeftToRight) }
        if operation == .push { return PushPopAnimator(presenting: true, isLeftToRight: isLeftToRight) }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

// MARK: GestureRecognizerDelegate
extension CustomNavigationTransactionHelper: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if navigationController?.parent == nil &&
            otherGestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return false
        }
        if gestureRecognizer == edgeSwipeGestureRecognizer { return true }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view?.tag == Self.enableScrollViewTag { return true }
        return false
    }
}

// MARK: PushPopAnimator
final class PushPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    let parallaxPercent: CGFloat
    let duration: TimeInterval
    public private(set) var isAnimating: Bool = false
    private let sign: CGFloat
    
    public init(presenting: Bool, isLeftToRight: Bool, parallaxPercent: CGFloat = 0.25, duration: TimeInterval = 0.33) {
        self.presenting = presenting
        self.parallaxPercent = parallaxPercent
        self.duration = duration
        self.sign = isLeftToRight ? 1 : -1
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        let dimmingView = UIView(frame: container.frame)
        dimmingView.backgroundColor = UIColor.black
        let maxDimmingViewAlpha: CGFloat = 0.1
        let startingX: CGFloat
        if presenting {
            container.addSubview(dimmingView)
            container.addSubview(toView)
            dimmingView.alpha = 0
            startingX = sign * toView.frame.width
        } else {
            container.insertSubview(toView, belowSubview: fromView)
            container.insertSubview(dimmingView, belowSubview: fromView)
            dimmingView.alpha = maxDimmingViewAlpha
            startingX = -sign * toView.frame.width * self.parallaxPercent
        }
        toView.frame = CGRect(x: startingX,
                              y: toView.frame.origin.y,
                              width: toView.frame.width,
                              height: toView.frame.height)

        self.isAnimating = true
        let animationBlock = {
            let finalX: CGFloat
            if self.presenting {
                finalX = -self.sign * fromView.frame.width * self.parallaxPercent
                dimmingView.alpha = maxDimmingViewAlpha
            } else {
                finalX = self.sign * fromView.frame.width
                dimmingView.alpha = 0
                toView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            
            toView.frame = transitionContext.finalFrame(for: toVC)
            fromView.transform = CGAffineTransform(translationX: finalX, y: 0)
        }
        let completionBlock: (Bool) -> Void = { _ in
            container.addSubview(toView)
            dimmingView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.isAnimating = false
            
            // for SwiftUI buttons
            fromView.transform = CGAffineTransform(translationX: 1, y: 0)
            fromView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        if transitionContext.isInteractive {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveLinear,
                           animations: animationBlock,
                           completion: completionBlock)
        } else {
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    options: .calculationModeCubic,
                                    animations: animationBlock,
                                    completion: completionBlock)
        }
    }
}
