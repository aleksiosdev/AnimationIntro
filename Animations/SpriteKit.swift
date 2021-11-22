//
//  SpriteKit.swift
//  Animations
//
//  Created by Aleksadnr Lavrinenko on 22.11.2021.
//

import SpriteKit


class GameScene: SKScene {
  private var node = SKSpriteNode()
  private var animationFrames: [SKTexture] = []

	func runAnimation() {
		node.run(SKAction.repeatForever(
		   SKAction.animate(with: animationFrames,
							timePerFrame: 0.1,
							resize: false,
							restore: true)),
		   withKey:"yourKey")
	}
}
