import UIKit
import CoreMotion

class ViewController: UIViewController {
   
    let manager = CMHeadphoneMotionManager()
    
    @IBOutlet weak var cursorImage: UIImageView!
    let SPEED_MULTIPLIER: Double = 12
  
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAirPods()
    }
}

extension ViewController {
    private func setupAirPods() {
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { [self] (deviceMotion, error) -> Void in
            if let motion = deviceMotion {
                let pitch = degrees(motion.attitude.pitch)
                let yaw = degrees(motion.attitude.yaw)
                cursorImage.center = CGPoint(x: view.center.x - yaw * SPEED_MULTIPLIER, y: view.center.y - pitch * SPEED_MULTIPLIER)
            } else {
                print("ERROR: \(error?.localizedDescription ?? "")")
            }
        })
    }
}

extension ViewController {
    func degrees(_ radians: Double) -> Double {
        return 180 / .pi * radians
    }
}

extension ViewController: CMHeadphoneMotionManagerDelegate {
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        print("AirPods Connected!")
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        print("AirPods Disconnected!")
    }
}
