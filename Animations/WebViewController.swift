//
//  WebViewController.swift
//  Animations
//
//  Created by Aleksadnr Lavrinenko on 13.11.2021.
//

import Foundation
import WebKit

final class WebViewController: UIViewController {
	private let _webView: WKWebView = {
		let webView = WKWebView()
		webView.backgroundColor = .white
		webView.translatesAutoresizingMaskIntoConstraints = false
		return webView
	}()

	init(url: URL) {
		super.init(nibName: nil, bundle: nil)

		view.addSubview(_webView)
		NSLayoutConstraint.activate([
			_webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			_webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			_webView.topAnchor.constraint(equalTo: view.topAnchor),
			_webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])

		_webView.load(.init(url: url))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
