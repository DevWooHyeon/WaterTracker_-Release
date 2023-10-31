//
//  SettingViewController.swift
//  WaterTracker
//
//  Created by 김우현 on 2023/06/01.
//

import UIKit
import UserNotifications

final class SettingViewController: UIViewController {
    @IBOutlet weak var oneIntakePicker: UITextField!
    @IBOutlet weak var oneStandardPicker: UITextField!
    
    private var waterManager = WaterManager()
    private let pickerViewManager = PickerViewsManager()
    
    let user = UserDefaults.standard
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupPickerView()
        setupToolBar()
        setupTextField()
    }
    
    // MARK: -ui & view 설정
    func setupTitle() {
        title = "설정"
    }
    
    func setupPickerView() {
        pickerViewManager.onePickerView.delegate = self
        pickerViewManager.oneDayPickerView.delegate = self
        
        pickerViewManager.onePickerView.dataSource = self
        pickerViewManager.oneDayPickerView.dataSource = self
        
        self.oneIntakePicker.inputView = pickerViewManager.onePickerView
        self.oneStandardPicker.inputView = pickerViewManager.oneDayPickerView
    }
    
    func setupToolBar() {
        let tool = UIToolbar()
        tool.sizeToFit()
        
        let done = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        tool.setItems([space, done], animated: true)
        tool.isUserInteractionEnabled = true
        
        self.oneIntakePicker.inputAccessoryView = tool
        self.oneStandardPicker.inputAccessoryView = tool
    }
    
    func setupTextField() {
        oneIntakePicker.delegate = self
        oneStandardPicker.delegate = self
        
        oneIntakePicker.tintColor = .clear
        oneStandardPicker.tintColor = .clear
        
        oneIntakePicker.placeholder = "mL"
        oneStandardPicker.placeholder = "L"
        
        oneIntakePicker.text = "\(UserDefaults.standard.integer(forKey: "intake")) mL"
        oneStandardPicker.text = "\(UserDefaults.standard.double(forKey: "standard")) L"
    }
    
    // MARK: - Button & Touch 이벤트
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
}

// MARK: - UIPickerView Data extension

extension SettingViewController: UIPickerViewDataSource {
    // 컴포넌트의 컬럼 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case pickerViewManager.onePickerView, pickerViewManager.oneDayPickerView:
            return 1
        default:
            return 1
        }
    }
    // 각 컬럼의 행(row)의 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerViewManager.onePickerView:
            return waterManager.getOneDrinkWaterList().count
        case pickerViewManager.oneDayPickerView:
            return waterManager.getOneDayWaterList().count
        default:
           return 0
        }
    }
}

// MARK: - UIPickerView Delegate extension
extension SettingViewController: UIPickerViewDelegate {
    // 피커뷰 컴포넌트 생성
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerViewManager.onePickerView:
            let oneDrink = waterManager.getOneDrinkWaterList()
            return "\(oneDrink[row]) ml"
            
        case pickerViewManager.oneDayPickerView:
            let oneDay = waterManager.getOneDayWaterList()
            return "\(oneDay[row]) L"
            
        default:
            return ""
        }
    }
    // 피커뷰 컴포넌트를 텍스트필드에 띄우기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerViewManager.onePickerView:
            self.oneIntakePicker.text = "\(waterManager.getOneDrinkWaterList()[row]) ml"
            let intake = waterManager.getOneDrinkWaterList()[row]
            
            user.set(intake, forKey: "intake")
            
        case pickerViewManager.oneDayPickerView:
            self.oneStandardPicker.text = " \(waterManager.getOneDayWaterList()[row])  L"
            let standard = waterManager.getOneDayWaterList()[row]
            
            user.set(standard, forKey: "standard")
            
        default:
            break
        }
    }
    // 피커뷰 컴포넌트의 높이
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
}

// MARK: - UITextField Delegate extension
extension SettingViewController: UITextFieldDelegate {
    // 텍스트 필드 수정 불가
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
