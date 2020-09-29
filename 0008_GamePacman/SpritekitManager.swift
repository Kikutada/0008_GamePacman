//
//  SpritekitManager.swift
//  Sprite Manager Class for SpriteKit
//
//  Created by Kikutada on 2020/08/09.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation
import SpriteKit

/// Asset management class creates the textures that cut out the image file to a specified size.
class CgAssetManager {

    var view: SKScene?

    //   e.g.)
    //     image file -> cutout -> textures[] numberOfTextures = 8
    //      (64x32)      (16x16)   <----->    numberOfColumns = 4
    //       OOOO                  4,5,6,7 |
    //       OOOO                  0,1,2,3 |  numberOfRows = 2
    //
    var textures: [SKTexture] = []
    var textureSize: CGSize!
    var numberOfColumns = 0
    var numberOfRows = 0
    var numberOfTextures = 0

    /// Create and initialize an asset object containing the textures from a specified image file
    /// - Parameters:
    ///   - view: SKScene object that organizes all of the active SpriteKit content
    ///   - imageNamed: An image file to Initialize textures using
    ///   - width: The size of the width of the texture that cuts out the image file
    ///   - height: The size of height of the texture that cuts out the image file
    ///
    init(view: SKScene, imageNamed: String, width: Int, height: Int) {

        self.view = view

        let image = SKTexture.init(imageNamed: imageNamed)
        image.usesMipmaps = true
        textureSize = CGSize(width: width, height: height)
        numberOfColumns = Int(CGFloat(image.size().width)/CGFloat(width))
        numberOfRows = Int(CGFloat(image.size().height)/CGFloat(height))
        numberOfTextures = numberOfColumns * numberOfRows
        
        for i in 0 ..< numberOfRows {
            for j in 0 ..< numberOfColumns {
                let x = (CGFloat(j) * CGFloat(width)) / CGFloat(image.size().width)
                let y = (CGFloat(i) * CGFloat(height)) / CGFloat(image.size().height)
                let w = CGFloat(width) / CGFloat(image.size().width)
                let h = CGFloat(height) / CGFloat(image.size().height)

                // Cut out the specified size as a texture
                let texture = SKTexture.init(rect: CGRect(x: x, y: y, width: w, height: h), in: image)
                texture.filteringMode = SKTextureFilteringMode.nearest
                textures.append(texture)
            }
        }
    }
}

/// Sprite management class cuts out an image file as textures and draws a sprite with a texture by a specified number.
class CgSpriteManager: CgAssetManager {
    
    private var maxNumberOfSprites = 0
    private var sprites: [SKSpriteNode?] = []
    private var drawingState: [Bool] = []         // True while drawing
    
    /// Create and initialize a sprite management object containing the textures from a specified image file.
    /// - Parameters:
    ///   - view: SKScene object that organizes all of the active SpriteKit content
    ///   - imageNamed: An image file to Initialize textures using
    ///   - width: The size of the width of the texture that cuts out the image file
    ///   - height: The size of height of the texture that cuts out the image file
    ///   - maxNumber: Maximum number of sprites to draw
    init(view: SKScene, imageNamed: String, width: Int, height: Int, maxNumber: Int) {
        super.init(view: view, imageNamed: imageNamed, width: width, height: height)

        self.maxNumberOfSprites = maxNumber
        for _ in 0 ..< maxNumber {
            let obj = SKSpriteNode.init(texture: textures.first)
            sprites.append(obj)
            drawingState.append(false)
        }
    }
    
    /// Draw a sprite with a texture
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - texture: Texture number to set a sprite
    func draw(_ number: Int, texture: Int) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            if !drawingState[number] {
                drawingState[number] = true
                obj.isHidden = false
                view?.addChild(obj)
            }
            self.setTexture(number, texture: texture)
        }
    }

    /// Draw a sprite with a texture at the specified position
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - x: X coordinate for position
    ///   - y: Y coordinate for position
    ///   - texture: Texture number to set a sprite
    func draw(_ number: Int, x: CGFloat, y: CGFloat, texture: Int) {
        draw(number, texture: texture)
        setPosition(number, x: x, y: y)
    }

    /// Clear a drawing sprite
    /// - Parameter number: Sprite control number between 0 to (maxNumber-1)
    func clear(_ number: Int) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if drawingState[number] {
            if let obj = sprites[number] {
                obj.removeFromParent()
            }
            drawingState[number] = false
        }
    }
    
    /// Hide a sprite. However, It still exists in the scene and continue to interact in other ways.
    /// - Parameter number: Sprite control number between 0 to (maxNumber-1)
    func hide(_ number: Int) {
        if let obj:SKSpriteNode = sprites[number] {
            obj.isHidden = true
        }
    }

    /// Show a hidden sprite
    /// - Parameter number: Sprite control number between 0 to (maxNumber-1)
    func show(_ number: Int) {
        if let obj:SKSpriteNode = sprites[number] {
            obj.isHidden = false
        }
    }
    
    /// Set the position (x,y) of the specific sprite number
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - x: X coordinate for position
    ///   - y: Y coordinate for position
    func setPosition(_ number: Int, x: CGFloat, y: CGFloat) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.position.x = x
            obj.position.y = y
        }
    }
    
    /// Set the depth (z) of the specific sprite number
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - zPosition: Depth value. The bigger the value, the closer
    func setDepth(_ number: Int, zPosition: CGFloat) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.zPosition = zPosition
        }
    }

    /// Set a texture to a sprite
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - texture: Texture number to set a sprite
    func setTexture(_ number: Int, texture: Int) {
        guard (number < maxNumberOfSprites && number >= 0 ) && (texture < numberOfTextures && texture >= 0) else { return }
        if let obj = sprites[number] {
            obj.texture = textures[texture]
        }
    }
    
    /// Start animation by textures
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - sequence: Sequence of textures for animation as an array
    ///   - timePerFrame: Update rate in sec
    ///   - forever: True to repeat forever. False to repeat one time
    func startAnimation(_ number: Int, sequence: [Int], timePerFrame: Double,  repeat forever: Bool) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        var textures:[SKTexture] = []
        
        for txNo in sequence {
            if (txNo < numberOfTextures) && (txNo >= 0) {
                textures.append(self.textures[txNo])
            }
        }
        
        if let obj = sprites[number] {
            // Draw the sprite, if it is not drawn.
            if !drawingState[number] {
                drawingState[number] = true
                view?.addChild(obj)
            }

            let action = SKAction.animate(with: textures, timePerFrame: timePerFrame)
            var repeatAction: SKAction

            if forever {
                repeatAction = SKAction.repeatForever(action)
            } else {
                repeatAction = SKAction.repeat(action, count: 1)
            }

            obj.removeAllActions()
            obj.run(repeatAction)
        }
    }
    
    /// Stop an animated sprite
    /// - Parameter number: Sprite control number between 0 to (maxNumber-1)
    func stopAnimation(_ number: Int) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.removeAllActions()
        }
    }

    /// Set a sprite coordinate axes
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - xOrigin: X axis position
    ///   - yOrigin: Y axis position
    ///  The default value is (0.5,0.5), which means that the sprite is centered on its position.
    ///  e.g.)  (xScale, yScale)  sets to (0.0,0.0), which means that its axes sets to lower left.
    ///      (xScale, yScale)  sets to (1.0,1.0), which means that its axes sets to upper right.
    func setOrigin(_ number: Int, xOrigin: CGFloat, yOrigin: CGFloat) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.anchorPoint = CGPoint(x: xOrigin, y: yOrigin)
        }
    }
    
    /// Rotate a sprite
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - radian: Set the rotation angle in radians
    ///   e.g.) radins = CGFloat(10.0 * .pi / 180.0)
    func setRotation(_ number: Int, radians: CGFloat) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.zRotation = radians
        }
    }
    
    /// Scale and flip a sprite
    /// - Parameters:
    ///   - number: Sprite control number between 0 to (maxNumber-1)
    ///   - xScale: A scaling factor that multiplies the width of  a sprite
    ///   - yScale: A scaling factor that multiplies the height of a sprite
    ///   e.g.)  (xScale, yScale) sets to (0.5, 1.0) , which means that  a sprite is scaled of 50% size in X direction.
    ///       (xScale, yScale) sets to (1.0, -1.0), which means that a sprite is flipped in Y direction.
    func setScale(_ number: Int, xScale: CGFloat, yScale: CGFloat) {
        guard (number < maxNumberOfSprites && number >= 0) else { return }
        if let obj = sprites[number] {
            obj.xScale = xScale
            obj.yScale = yScale
        }
    }
}

/// Background management class cuts out an image file as textures and draws a tile by a specified texture number.
class CgBackgroundManager : CgAssetManager {
    
    private var maxNumberOfBackgrounds = 0

    private var tileGroups: [SKTileGroup] = []
    private var tileSets: SKTileSet?
    private var bgNodes: [SKTileMapNode?] = []
    private var drawingState: [Bool] = []        // True while drawing
    
    init(view: SKScene, imageNamed: String, width: Int, height: Int, maxNumber: Int) {
        super.init(view: view, imageNamed: imageNamed, width: width, height: height)
        
        for i in 0 ..< numberOfTextures {
            let definition = SKTileDefinition.init(texture: textures[i])
            let tileGroup = SKTileGroup.init(tileDefinition: definition)
            tileGroups.append(tileGroup)
        }
        
        let numberOfadd = extendTextures()
        numberOfTextures += numberOfadd
        
        tileSets = SKTileSet(tileGroups: tileGroups)
        self.maxNumberOfBackgrounds = maxNumber

        for _ in 0 ..< maxNumber {
            let obj = SKTileMapNode.init(tileSet:tileSets!, columns: 1, rows: 1, tileSize: self.textureSize)
            bgNodes.append(obj)
            drawingState.append(false)
        }
    }
    
    /// To set animated textures, extendTextures function is overriden by subclass of CgBackground
    /// - Returns: Number of added textures by calling extendAnimationTexture function
    func extendTextures() -> Int {
        // vitrual function.
        return 0
    }
    
    /// Add the animated textures. Their texture numbers are assigned in addition to a image
    /// - Parameters:
    ///   - sequence: Sequence of texture numbers for animations as an array
    ///   - timePerFrame: Update rate in sec
    func extendAnimationTexture(sequence: [Int], timePerFrame: CGFloat) {
        var textures:[SKTexture] = []

        for txNo in sequence {
            if (txNo < numberOfTextures) && (txNo >= 0) {
                textures.append(self.textures[txNo])
            }
        }

        let definition = SKTileDefinition(textures: textures, size: self.textureSize, timePerFrame: timePerFrame)
        let tileGroup = SKTileGroup(tileDefinition: definition)
        tileGroups.append(tileGroup)
    }
    
    /// Draw a background with textures at the specified position
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - x: X coordinate for position
    ///   - y: Y coordinate for position
    ///   - columnsInWidth: Number of columns in width
    ///   - rowsInHeight: Number of rows in height
    func draw(_ number: Int, x: CGFloat, y: CGFloat, columnsInWidth: Int, rowsInHeight: Int) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        if let obj = bgNodes[number] {
            if !drawingState[number] {
                drawingState[number] = true
                obj.numberOfColumns = columnsInWidth
                obj.numberOfRows = rowsInHeight
                obj.position = CGPoint(x: x, y: y)
                obj.enableAutomapping = false
                view?.addChild(obj)
            }
        }
    }
    
    /// Clear a drawing background
    ///   - number: Background control number between 0 to (maxNumber-1)
    func clear(_ number: Int) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        if drawingState[number] {
            if let obj = bgNodes[number] {
                obj.removeFromParent()
            }
            drawingState[number] = false
        }
    }
    
    /// Set the position (x,y) of the specific background number
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - x: X coordinate for position
    ///   - y: Y coordinate for position
    func setPosition(_ number: Int, x: CGFloat, y: CGFloat) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        if let obj = bgNodes[number] {
            obj.position.x = x
            obj.position.y = y
        }
    }

    /// Sets the depth (z) of the specific background number
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - zPosition: Depth value. The bigger the value, the closer
    func setDepth(_ number: Int, zPosition: CGFloat) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        if let obj = bgNodes[number] {
            obj.zPosition = zPosition
        }
    }
    
    /// Fill a background by a specified texture
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - texture: Texture number to fill a background
    func fill(_ number: Int, texture: Int) {
        guard (number < maxNumberOfBackgrounds && number >= 0 ) && (texture < numberOfTextures && texture >= 0) else { return }
        if let obj = bgNodes[number] {
            obj.fill(with: tileGroups[texture])
        }
    }
    
    /// Put a texture on a background at the specified position
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - column: Column coordinate for position
    ///   - row: Row coordinate for position
    ///   - texture: Texture number to put on a background
    func put(_ number: Int, column: Int, row: Int, texture: Int) {
        guard (number < maxNumberOfBackgrounds && number >= 0 ) && (texture < numberOfTextures && texture >= 0) else { return }
        if let obj = bgNodes[number] {
            obj.setTileGroup(tileGroups[texture], forColumn: column, row: row)
        }
    }
    
    /// Put multiple textures on a background at the specified position
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - column: Column coordinate for position
    ///   - row: Row coordinate for position
    ///   - columnsInWidth: Number of columns in width
    ///   - rowsInHeight: Number of rows in height
    ///   - textures: Texture numbers to put on a background
    ///   - offset: Offset to add to texture number
    func put(_ number: Int, column: Int, row: Int, columnsInwidth: Int, rowsInHeight: Int, textures: [Int], offset: Int = 0) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        var h = 0
        var v = 0
        
        for txNo in textures {
            put(number, column: column+h, row: row+v, texture: txNo+offset)
            h += 1
            if h >= columnsInwidth {
                h = 0
                v += 1
                if v >= rowsInHeight { break }
            }
        }
    }
    
    /// Put string of textures on a background at the specified position
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - column: Column coordinate for position
    ///   - row: Row coordinate for position
    ///   - string: String corresponded to texture numbers
    ///   - offset: Offset to add to texture number
    func putString(_ number: Int, column: Int, row: Int, string: String, offset: Int = 0) {
        guard (number < maxNumberOfBackgrounds && number >= 0) else { return }
        var i = column

        for c in string.utf8 {
            let txNo: Int = Int(c) + offset
            put(number, column: i, row: row, texture: txNo)
            i += 1
        }
    }

}
