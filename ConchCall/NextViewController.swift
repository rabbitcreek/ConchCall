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

class NextViewController: UIViewController, ARSCNViewDelegate{
    var audioPlayer: AVAudioPlayer!
    let soundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "0001", ofType: "wav")!)
    var mover: Double = 0
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(configuration)
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/conch3.dae")!
        let planeNode = scene.rootNode.childNode(withName: "baseNode", recursively: true)
        planeNode?.scale = SCNVector3Make(0.05, 0.05, 0.05)
        planeNode?.position = SCNVector3(0.5,0,-0.5)
        var count = -0.5
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ t in
            count = count + self.mover
            print(count)
            planeNode?.position = SCNVector3(0.5,0,count)
            if count <= -20 {
                t.invalidate()
            }
        }
        
        self.sceneView.scene.rootNode.addChildNode(planeNode!)
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        planeNode?.runAction(forever)
        // Set the scene to the view
        //sceneView.scene = scene
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.environmentTexturing = .automatic
        // Create a session configuration
        // let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func addLight() {
    // 1
    let directionalLight = SCNLight()
    directionalLight.type = .directional
    // 2
    directionalLight.intensity = 0
    // 3
    directionalLight.castsShadow = true
    directionalLight.shadowMode = .deferred
    // 4
    directionalLight.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    // 5
    directionalLight.shadowSampleCount = 10
    // 6
    let directionalLightNode = SCNNode()
    directionalLightNode.light = directionalLight
    directionalLightNode.rotation = SCNVector4Make(1, 1, 0, -Float.pi / 3)
    sceneView.scene.rootNode.addChildNode(directionalLightNode)
    }
    @objc func tapped(recognizer :UIGestureRecognizer) {
        // Get exact position where touch happened on screen of iPhone (2D coordinate)
        let touchPosition = recognizer.location(in: sceneView)
        
        // 2.
        // Conduct a hit test based on a feature point that ARKit detected to find out what 3D point this 2D coordinate relates to
        let hitTestResult = sceneView.hitTest(touchPosition, types: .featurePoint)
        
        // 3.
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {
                return
            }
            print(hitResult.worldTransform.columns.3)
            // setting up url for your soundtrack
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundEffect)
            audioPlayer.play()
            
            
            
        } catch {
            // couldn't load file :(
        }
        
        
        // add the light to the scene
        
        
        
        
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            
            
            self.addLight()
            self.mover = -0.2
            
            
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            
            self.performSegue(withIdentifier: "Return", sender: self)
        }
    }
    
    
    
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}



