//
//  ViewController.swift
//  Animations
//
//  Created by Aleksadnr Lavrinenko on 09.11.2021.
//

import UIKit

class ViewController: UIViewController {
	private lazy var _introButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle("Enter animation World", for: .normal)
		button.layer.cornerRadius = 12
		button.backgroundColor = UIColor(from: "#007FF5")
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.white, for: .normal)
		button.addAction(.init(handler: { [weak self] _ in
			self?.buttonPressed(button: button)
		}), for: .touchUpInside)
		return button
	}()

	private lazy var podlodkaImageView: UIImageView = {
		let imageView = UIImageView(image: .init(named: "podlodka"))
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private lazy var _appleButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(.init(named: "ic_apple")!, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .black
		button.addAction(.init(handler: { [weak self] action in
			let webViewController = WebViewController(url: .init(string: "https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/animation/")!)
			self?.present(webViewController, animated: true, completion: nil)
		}), for: .touchUpInside)
		return button
	}()

	private var centerYIntroButtonConstraint: NSLayoutConstraint?
	private var dynamicAniamtor: UIDynamicAnimator?
	private var snapBehaviour: UISnapBehavior?

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		view.addSubview(_introButton)
		view.addSubview(_appleButton)
		view.addSubview(podlodkaImageView)

		let centerYIntroButtonConstraint = _introButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		self.centerYIntroButtonConstraint = centerYIntroButtonConstraint
		NSLayoutConstraint.activate([
			_introButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			_introButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			centerYIntroButtonConstraint,
			_introButton.heightAnchor.constraint(equalToConstant: 44),

			_appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			_appleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			_appleButton.widthAnchor.constraint(equalToConstant: 24),
			_appleButton.heightAnchor.constraint(equalToConstant: 24),

			podlodkaImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
			podlodkaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			podlodkaImageView.heightAnchor.constraint(equalToConstant: 64),
			podlodkaImageView.widthAnchor.constraint(equalToConstant: 64)
		])

		addDynamicBehaviour(imageView: podlodkaImageView)

		let displayLink = CADisplayLink(
			target: self,
			selector: #selector(displayLinkUpdateHandler))
		displayLink.add(to: .current, forMode: .common)
	}

	@objc func displayLinkUpdateHandler() {
		print("Updating!")
	}

	private func addDynamicBehaviour(imageView: UIImageView) {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedView))
		imageView.addGestureRecognizer(panGesture)
		imageView.isUserInteractionEnabled = true

		dynamicAniamtor = UIDynamicAnimator(referenceView: view)
		snapBehaviour = UISnapBehavior(item: imageView, snapTo: CGPoint(
			x: view.center.x,
			y: view.frame.height - 64))
		guard let snapBehaviour = snapBehaviour else { assertionFailure(); return }
		dynamicAniamtor?.addBehavior(snapBehaviour)
	}

	@objc private func pannedView(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			guard let snapBehaviour = snapBehaviour else { assertionFailure(); return }
			dynamicAniamtor?.removeBehavior(snapBehaviour)
		case .changed:
			let translation = recognizer.translation(in: view)
			podlodkaImageView.center = .init(
				x: podlodkaImageView.center.x + translation.x,
				y: podlodkaImageView.center.y + translation.y)
			recognizer.setTranslation(.zero, in: view)
		case .ended, .cancelled, .failed:
			guard let snapBehaviour = snapBehaviour else { assertionFailure(); return }
			dynamicAniamtor?.addBehavior(snapBehaviour)
		case .possible:
			break
		@unknown default:
			break
		}
	}

	private func buttonPressed(button: UIButton) {
		buttonCAAnimation(button: button)
	}

	private func buttonMoveConstaint(button: UIButton) {
		UIView.animate(withDuration: 0.15) {
			self.centerYIntroButtonConstraint?.constant += 30
			button.superview?.layoutIfNeeded()
		}
	}

	private func buttonSizeUpAndBack(button: UIButton) {
		UIView.animate(withDuration: 0.15) {
			button.transform = button.transform.scaledBy(x: 0.95, y: 0.95)
			button.isUserInteractionEnabled = false
		} completion: { _ in
			UIView.animate(withDuration: 0.1) {
				button.transform = CGAffineTransform(scaleX: 1, y: 1)
				button.isUserInteractionEnabled = true
			}
		}
	}

	private func buttonSizeUpAndBackPropertyAniamtor(button: UIButton) {
		let toSmallSizeAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) {
			button.transform = button.transform.scaledBy(x: 0.95, y: 0.95)
			button.isUserInteractionEnabled = false
		}

		let toOriginalSizeAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) {
			button.transform = CGAffineTransform(scaleX: 1, y: 1)
			button.isUserInteractionEnabled = true
		}

		toSmallSizeAnimator.addCompletion { _ in
			toOriginalSizeAnimator.startAnimation()
		}
		toSmallSizeAnimator.startAnimation()
	}

	private func dynamicAnimation(view: UIView) {
		let flowLayout = UICollectionViewFlowLayout()

		let dynamicAnimator = UIDynamicAnimator(referenceView: view)
		let collectionDynamicAnimator = UIDynamicAnimator(collectionViewLayout: flowLayout)

		print(dynamicAnimator)
		print(collectionDynamicAnimator)
	}

	private func buttonCAAnimation(button: UIButton) {
		button.layer.cornerRadius = 12
		button.layer.backgroundColor =  UIColor(from: "#007FF5")?.cgColor

		CATransaction.begin()
		let baseDuration = 0.75
		let endCornerRadius = 0
		let endColor = UIColor(from: "#FFE475")
		CATransaction.setCompletionBlock {
//			button.layer.cornerRadius = 0
//			button.layer.backgroundColor = endColor?.cgColor

		}
		let cornerRadiusKeyPath = #keyPath(CALayer.cornerRadius)
		let cornerAnimation = CABasicAnimation(keyPath: cornerRadiusKeyPath)
		cornerAnimation.duration = 2 * baseDuration
		cornerAnimation.fromValue = 12
		cornerAnimation.toValue = endCornerRadius
		cornerAnimation.autoreverses = true

//
//		let bgColorKeyPath = #keyPath(CALayer.backgroundColor)
//		let bgColorAnimation = CABasicAnimation(keyPath: bgColorKeyPath)
//		bgColorAnimation.beginTime = CACurrentMediaTime() + baseDuration;
//		bgColorAnimation.duration = baseDuration
//		bgColorAnimation.fromValue = UIColor(from: "#007FF5")?.cgColor
//		bgColorAnimation.toValue = endColor?.cgColor

		button.layer.add(cornerAnimation, forKey: cornerRadiusKeyPath)
//		button.layer.add(bgColorAnimation, forKey: bgColorKeyPath)

		CATransaction.commit()
	}
}



extension UIColor {
	convenience init?(from hex: String) {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}

		if ((cString.count) != 6) {
			return nil
		}

		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0))
	}
}
