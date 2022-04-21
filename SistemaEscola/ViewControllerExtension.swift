//
//  ViewControllerExtension.swift
//  SistemaEscola
//
//  Created by Renan Trévia on 2/14/22.
//  Copyright © 2022 Eldorado. All rights reserved.
//

import UIKit

extension ViewController {
    func resetRemoveCollaborator() {
        resetAllTextFieldRemove()
    }
    
    func resetAllTextFieldRemove() {
        removeEnrollmentTextField.text = ""
    }
    
    func resetRegisterCollaborator() {
        resetAllButtonOfPosition()
        resetAllTextFieldRegister()
        
        monitorButton.backgroundColor = .systemBlue
        monitorButton.setTitleColor(.white, for: .normal)
        
        selectedPosition = .monitor
    }
    
    func resetAllTextFieldRegister() {
        enrollmentTextField.text = ""
        nameTextField.text = ""
        salaryTextField.text = ""
    }
    
    func resetAllButtonOfPosition() {
        monitorButton.backgroundColor = .clear
        teacherButton.backgroundColor = .clear
        coordinatorButton.backgroundColor = .clear
        principalButton.backgroundColor = .clear
        assistantButton.backgroundColor = .clear
        
        monitorButton.setTitleColor(.systemBlue, for: .normal)
        teacherButton.setTitleColor(.systemBlue, for: .normal)
        coordinatorButton.setTitleColor(.systemBlue, for: .normal)
        principalButton.setTitleColor(.systemBlue, for: .normal)
        assistantButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    func selectedButton(button: UIButton) {
        resetAllButtonOfPosition()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
    }
}
