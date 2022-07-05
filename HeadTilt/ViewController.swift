import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var cursorImage: UIImageView!
    var location = CGPoint(x: 0, y: 0)
    
    let manager = CMHeadphoneMotionManager()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        location = touches.first!.location(in: self.view)
        cursorImage.center = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        location = touches.first!.location(in: self.view)
        cursorImage.center = location
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAirPods()
    }
}

extension ViewController {
    private func setupAirPods() {
        manager.delegate = self
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { [self] (deviceMotion, error) -> Void in
            if let motion = deviceMotion {
                let attitude = motion.attitude
                let roll = degrees(attitude.roll)
                let pitch = degrees(attitude.pitch)
                let yaw = degrees(attitude.yaw)
                cursorImage.center = CGPoint(x: view.center.x + roll * 5, y: view.center.y + roll * 5)
     
                let r = motion.rotationRate
                let ac = motion.userAcceleration
                let g = motion.gravity
                
                DispatchQueue.main.async { [self] in
                    var str = "Attitude:\n"
                    str += degreeText("Roll", roll)
                    str += degreeText("Pitch", pitch)
                    str += degreeText("Yaw", yaw)
                    
                    str += "\nRotation Rate:\n"
                    str += xyzText(r.x, r.y, r.z)
                    
                    str += "\nAcceleration:\n"
                    str += xyzText(ac.x, ac.y, ac.z)
                    
                    str += "\nGravity:\n"
                    str += xyzText(g.x, g.y, g.z)
                    
//                    textView.text = str
                }
                
            } else {
                print("ERROR: \(error?.localizedDescription ?? "")")
            }
        })
    }
}

extension ViewController {
    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", abs(num))
    }
    
    func xyzText(_ x: Double, _ y: Double, _ z: Double) -> String {
        var str = ""
        str += String(format: "X: %.1f\n", abs(x))
        str += String(format: "Y: %.1f\n", abs(y))
        str += String(format: "Z: %.1f\n", abs(z))
        return str
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180 / .pi * radians
    }
}

extension ViewController: CMHeadphoneMotionManagerDelegate {
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
//        textView.text = "AirPods Connected!"
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
//        textView.text = "AirPods Disconnected :("
    }
}
