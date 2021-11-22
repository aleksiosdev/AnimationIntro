//
//  AnimationChapter.swift
//  Animations
//
//  Created by Aleksadnr Lavrinenko on 13.11.2021.
//

import Foundation
import UIKit

struct AnimationChapterViewModel {
	let title: String
	let icon: UIImage
}

extension AnimationChapterViewModel: Equatable { }
extension AnimationChapterViewModel: Hashable { }
