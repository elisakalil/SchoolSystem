//
//  ViewController.swift
//  SistemaEscola
//
//  Created by Renan Trévia on 2/11/22.
//  Copyright © 2022 Eldorado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var outputMessage: UILabel!
    @IBOutlet weak var enrollmentTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var monitorButton: UIButton!
    @IBOutlet weak var teacherButton: UIButton!
    @IBOutlet weak var coordinatorButton: UIButton!
    @IBOutlet weak var principalButton: UIButton!
    @IBOutlet weak var assistantButton: UIButton!
    @IBOutlet weak var removeEnrollmentTextField: UITextField!
    
    //MARK: Attributes
    var selectedPosition: Position = .monitor
    var collaboratorList: [Collaborator] = []
    var principalSalary: Double?
    
    //MARK: IBActions
    @IBAction func selectMonitor(_ sender: UIButton) {
        selectedPosition = .monitor
        selectedButton(button: sender)
    }
    
    @IBAction func selectTeacher(_ sender: UIButton) {
        selectedPosition = .teacher
        selectedButton(button: sender)
    }
    
    @IBAction func selectCoordinator(_ sender: UIButton) {
        selectedPosition = .coordinator
        selectedButton(button: sender)
    }
    
    @IBAction func selectPrincipal(_ sender: UIButton) {
        selectedPosition = .principal
        selectedButton(button: sender)
    }
    
    @IBAction func selectAssistant(_ sender: UIButton) {
        selectedPosition = .assistant
        selectedButton(button: sender)
    }
    
    @IBAction func registerCollaborator(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let enrollmentStr = enrollmentTextField.text,
              let enrollment = Int(enrollmentStr),
              let salaryStr = salaryTextField.text,
              let salary = Double(salaryStr) else {
            let message = "Os campos não foram preenchidos corretamente, verifique e tente novamente."
            showAlert(title: "Cadastro Colaborador", message: message)
            
            return
        }
        
        addNewCollaborator(collaborator: Collaborator(name: name, enrollment: enrollment, salary: salary, position: selectedPosition))
        resetRegisterCollaborator()
    }
    
    @IBAction func removeCollaborator(_ sender: UIButton) {
        guard let enrollment = Int(removeEnrollmentTextField.text ?? "0") else {return}
        removeCollaboratorWithEnrollment(enrollment: enrollment)
        showAlert(title: "Cadastro Colaborador", message: "Colaborador removido com sucesso!")
        showCollaboratorList(collaboratorList)
        resetRemoveCollaborator()
    }
    
    @IBAction func listMonthlyExpensesWithAllCollaborators(_ sender: UIButton) {
        let salaryExpenses = monthlySalaryExpenses(collaboratorList: collaboratorList)
        outputMessage.text = "O total de despesas mensais foi R$\(salaryExpenses)"
    }
    
    @IBAction func listMonthlyExpensesPerPosition(_ sender: UIButton) {
        let teacherExpenses = monthlyExpensesPerPosition(collaboratorList: collaboratorList, position: .teacher)
        let monitorExpenses = monthlyExpensesPerPosition(collaboratorList: collaboratorList, position: .monitor)
        let principalExpenses = monthlyExpensesPerPosition(collaboratorList: collaboratorList, position: .principal)
        let coordinatorExpenses = monthlyExpensesPerPosition(collaboratorList: collaboratorList, position: .coordinator)
        let assistentExpenses = monthlyExpensesPerPosition(collaboratorList: collaboratorList, position: .assistant)
        
        let list = """
            Professor: R$\(teacherExpenses)\n
            Monitor: R$\(monitorExpenses)\n
            Diretor: R$\(principalExpenses)\n
            Coordenador: R$\(coordinatorExpenses)\n
            Assistente: R$\(assistentExpenses)
        """
        
        outputMessage.text = list
    }
    
    @IBAction func listNumberOfPeoplePerPosition(_ sender: UIButton) {
        let numberOfTeacher = numberOfCollaboratorPerPosition(collaboratorList: collaboratorList, position: .teacher)
        let numberOfMonitor = numberOfCollaboratorPerPosition(collaboratorList: collaboratorList, position: .monitor)
        let numberOfPrincipal = numberOfCollaboratorPerPosition(collaboratorList: collaboratorList, position: .principal)
        let numberOfCoordinators = numberOfCollaboratorPerPosition(collaboratorList: collaboratorList, position: .coordinator)
        let numberOfAssitants = numberOfCollaboratorPerPosition(collaboratorList: collaboratorList, position: .coordinator)
        
        let list = """
            Professor: \(numberOfTeacher)\n
            Monitor: \(numberOfMonitor)\n
            Diretor: \(numberOfPrincipal)\n
            Coordenador: \(numberOfCoordinators)\n
            Assistente: \(numberOfAssitants)
        """
        
        outputMessage.text = list
    }
    
    @IBAction func listCollaboratorsNameAlphabeticalOrder(_ sender: UIButton) {
        let sortedList = collaboratorListSorted(collaboratorList: collaboratorList)
        showCollaboratorList(sortedList)
    }
    
    //MARK: Methods
    func showCollaboratorList(_ collaboratorList: [Collaborator]) {
        var list: String = """

    """
        for collaborator in collaboratorList {
            list += "\(collaborator.name) (matrícula: \(collaborator.enrollment))\n"
        }
        outputMessage.text = list
    }
    
    func addNewCollaborator(collaborator: Collaborator) {
        let hasPrincipal: Bool = hasPrincipal(collaboratorList: collaboratorList)
        let principalSalaryValid: Bool = isValidPrincipalSalary(collaboratorList: collaboratorList, principal: collaborator)
        let canAddNewCoordinator: Bool = canAddNewCoordinator(collaboratorList: collaboratorList)
        let validEnrollment: Bool = isValidEnrollment(collaboratorList: collaboratorList, enrollment: collaborator.enrollment)
        
        if validEnrollment {
            switch collaborator.position {
            case .principal:
                registerAPrincipal(hasPrincipal: hasPrincipal, principalSalaryValid: principalSalaryValid, collaborator: collaborator)
            case .coordinator:
                registerACoordinator(canAddNewCoordinator: canAddNewCoordinator, collaborator: collaborator)
            default:
                registerANewCollaborator(collaborator: collaborator)
            }
        } else {
            showAlert(title: "Atenção", message: "Esta matrícula já está sendo usada por outro colaborador!")
        }
    }
    
    func removeCollaboratorWithEnrollment(enrollment: Int) {
        for position in 0..<collaboratorList.count {
            let collaborator = collaboratorList[position]
            if collaborator.enrollment == enrollment {
                if collaborator.position == .principal {
                    principalSalary = nil
                }
                collaboratorList.remove(at: position)
                break
            }
        }
    }
    
    func monthlySalaryExpenses(collaboratorList: [Collaborator]) -> Double {
        var salarySum: Double = 0
        for collaborator in collaboratorList {
            salarySum += collaborator.salary
        }
        return salarySum
    }
    
    func monthlyExpensesPerPosition(collaboratorList: [Collaborator], position: Position) -> Double {
        var salarySum: Double = 0
        for collaborator in collaboratorList {
            if collaborator.position == position {
                salarySum += collaborator.salary
            }
        }
        return salarySum
    }

    func numberOfCollaboratorPerPosition(collaboratorList: [Collaborator], position: Position) -> Int {
        var count: Int = 0
        for collaborator in collaboratorList {
            if collaborator.position == position {
                count += 1
            }
        }
        return count
    }

    func collaboratorListSorted(collaboratorList: [Collaborator]) -> [Collaborator] {
        let sortedCollaboratorList = collaboratorList.sorted { $0.name.lowercased() < $1.name.lowercased() }
        return sortedCollaboratorList
    }

    func hasPrincipal(collaboratorList: [Collaborator]) -> Bool {
        var hasPrincipal = false
        for collaborator in collaboratorList {
            if collaborator.position == .principal {
               hasPrincipal = true
                break
            }
        }
        return hasPrincipal
    }

    func isValidPrincipalSalary(collaboratorList: [Collaborator], principal: Collaborator) -> Bool {
        var salaryIsValid = true
        for collaborator in collaboratorList {
            if collaborator.salary > principal.salary {
                salaryIsValid = false
                break
            }
        }
        return salaryIsValid
    }
    
    func registerAPrincipal(hasPrincipal: Bool, principalSalaryValid: Bool, collaborator: Collaborator) {
        if hasPrincipal {
            let message = "Colaborador(a) \(collaborator.name) não foi adicionado pois já existe um diretor cadastrado."
            showAlert(title: "Atenção", message: message)
        } else if !principalSalaryValid {
            let message = "O salário do diretor(a) não pode ser menor do que o do coordenador(a)"
            showAlert(title: "Atenção", message: message)
        } else {
            collaboratorList.append(collaborator)
            showCollaboratorList(collaboratorList)
            principalSalary = collaborator.salary
        }
    }

    func canAddNewCoordinator(collaboratorList: [Collaborator]) -> Bool {
        var numberOfCoordinator: Int = 0
        var numberOfTeacher: Int = 0
        var canAddNewCoordinator = true
        
        for collaborator in collaboratorList {
            if collaborator.position == .teacher {
                numberOfTeacher += 1
            }
            if collaborator.position == .coordinator {
                numberOfCoordinator += 1
            }
        }
        
        if numberOfTeacher > numberOfCoordinator {
            canAddNewCoordinator = true
        } else {
            canAddNewCoordinator = false
        }
        
        return canAddNewCoordinator
    }
    
    func registerACoordinator(canAddNewCoordinator: Bool, collaborator: Collaborator) {
        if !canAddNewCoordinator{
            let message = "Colaborador(a) \(collaborator.name) não foi adicionado pois o número máximo de coordenadores foi atingido."
            showAlert(title: "Atenção", message: message)
        } else {
            collaboratorList.append(collaborator)
            showCollaboratorList(collaboratorList)
        }
    }
    
    func isValidEnrollment(collaboratorList: [Collaborator], enrollment: Int) -> Bool {
        var isValidEnrollment = true
        for collaborator in collaboratorList {
            if collaborator.enrollment == enrollment {
                isValidEnrollment = false
                break
            }
        }
        return isValidEnrollment
    }
    
    func isValidSalary(salary: Double, principalSalary: Double) -> Bool {
        var isValidSalary = true
        if salary > principalSalary {
            isValidSalary = false
        }
        return isValidSalary
    }
    
    func registerANewCollaborator(collaborator: Collaborator) {
        if let validPrincipalSalary = principalSalary {
            if isValidSalary(salary: collaborator.salary, principalSalary: validPrincipalSalary) {
                collaboratorList.append(collaborator)
                showCollaboratorList(collaboratorList)
            } else {
                showAlert(title: "Atenção", message: "O salário informado não pode ser maior que o do diretor(a) (R$\(validPrincipalSalary))")
            }
        } else {
            collaboratorList.append(collaborator)
            showCollaboratorList(collaboratorList)
        }

    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

}

