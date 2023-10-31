//
//  ViewController.swift
//  WaterTracker
//
//  Created by 김우현 on 2023/06/01.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var firstViewLabel: UILabel!
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var mainLiter: UILabel!
    @IBOutlet weak var userLiter: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    var circleProgressBarView: CircleProgressBar!
    var waterManager = WaterManager()
    
    let user = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        userDefaults()
        setupCircleProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDefaults()
        circleProgressBarView.saveProgressAnimation()
    }
    
    func setupUI() {
        mainLiter.text = "0 L"
        userLiter.text = "0.0 %"
        
        waterButton.clipsToBounds = true
        waterButton.layer.cornerRadius = 15
        
        setupMainLabel()
    }
    
    func setupMainLabel() {
        firstViewLabel.text = "건강을 위해"
        secondViewLabel.text = "수분을 섭취하세요!"
    }
    
    func setupClearLabel() {
        firstViewLabel.text = "축하합니다!"
        secondViewLabel.text = "하루 섭취량을 다 채웠어요!"
    }
    
    func setupCircleProgressBar() {
        circleProgressBarView = CircleProgressBar(frame: .zero)
        circleProgressBarView.center = view.center
        
        view.addSubview(circleProgressBarView)
    }
    
    func userDefaults() {
        let standard = user.double(forKey: "standard")
        mainLiter.text = "\(standard) L"
        
        let intake = user.double(forKey: "percent")

        if intake >= 100.0 {
            userLiter.text = "100.0 %"
            setupClearLabel()
            waterButton.isEnabled = false
            resetButton.isEnabled = true
        } else if intake > 0.0 && intake <= 100.0 {
            let result = String(format: "%.1f", intake)
            userLiter.text = "\(result) %"
            resetButton.isEnabled = false
        } else {
            userLiter.text = "0.0 %"
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        circleProgressBarView.plusWater = 0.0
        waterManager.percentage = 0.0
        user.set(waterManager.percentage, forKey: "percent")
        user.set(circleProgressBarView.plusWater, forKey: "plusWater")
        
        setupMainLabel()
        userDefaults()
        circleProgressBarView.saveProgressAnimation()
        waterButton.isEnabled = true
    }
    
    @IBAction func addWaterButtonTapped(_ sender: UIButton) {
        let mL = Double(user.integer(forKey: "intake"))
        let L = user.double(forKey: "standard")
        
        if mL > 0.0 && L > 0.0 {
            let result = waterManager.waterPercent(ml: mL, L: L) // 퍼센트로 변환
            let percent = String(format: "%.1f", result)
            
            if result >= 100.0 {
                circleProgressBarView.progressAnimation(value: 1.0)
                userLiter.text = "100.0 %"
                firstViewLabel.text = "축하합니다!"
                secondViewLabel.text = "하루 섭취량을 다 채웠어요!"
                sender.isEnabled = false
                resetButton.isEnabled = true
            } else if result > 0.0 && result <= 100.0 {
                let value = waterManager.waterProgressPercent(ml: mL, L: L) // 프로그래스바 퍼센트로 변환
                circleProgressBarView.progressAnimation(value: value) // 프로그래스바 애니메이션
                
                userLiter.text = "\(percent) %"
                resetButton.isEnabled = false
            }
        } else {
            userLiter.text = "0.0 %"
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.storyboard?.instantiateViewController(withIdentifier: "setView") else { return }
        self.navigationController?.pushViewController(view, animated: true)
    }
}

