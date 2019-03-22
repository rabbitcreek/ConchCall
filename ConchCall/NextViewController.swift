//
//  NextViewController.swift
//  ConchCall
//
//  Created by RobertW. on 3/19/19.
//  Copyright © 2019 RobertW. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class NextViewController: UIViewController, ARSCNViewDelegate {
    
    var audioPlayer: AVAudioPlayer!
    let soundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "0001", ofType: "wav")!)
    var mover: Double = 0
    var position = SCNVector3(0,0,0)
    var count = -0.5
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
        // Gestures
        
       /*
        let tapGesure = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesure)
 */
        // Show statistics such as fps and timing information
        self.sceneView.autoenablesDefaultLighting = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        // Run the view's session
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func addFoodModelTo(position: SCNVector3) {
        guard let conchScene = SCNScene(named: "art.scnassets/conch3.dae") else {
            fatalError("Unable to find conch3.dae")
        }
        guard let baseNode = conchScene.rootNode.childNode(withName: "baseNode", recursively: true) else {
            fatalError("Unable to find baseNode")
        }
        baseNode.position = position
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ t in
            self.count = self.count + self.mover
            //print(self.count)
            if self.mover < 0 {
            baseNode.position = SCNVector3(0,0,self.count)
            }
            if self.count <= -20 {
                t.invalidate()
            }
        }
             
        baseNode.scale = SCNVector3Make(0.04, 0.04, 0.04)
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        baseNode.runAction(forever)
        sceneView.scene.rootNode.addChildNode(baseNode)
        // The lightingModel of the material has to be set to .physicallyBased to take advantage of the environment lighting
    }
   
   
    @IBAction func fireConch(_ sender:UIButton) {
    position = SCNVector3(0.1,-0.1,-0.6)
        
        sender.setImage(nil, for: [])
        //fireConch.enabled = false
        let conflictingAction = sender as UIButton
        conflictingAction.isEnabled = false
    addFoodModelTo(position: position)
        print(position)
        
    
 
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
   
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.soundEffect)
            self.audioPlayer.numberOfLoops = 1
            self.audioPlayer.play()
            
        } catch {
            // couldn't load file :(
        }
        
        
        // add the light to the scene
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.mover = -0.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.performSegue(withIdentifier: "Return", sender: self)
        }
        
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}



