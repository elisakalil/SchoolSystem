//
//  Collaborator.swift
//  SistemaEscola
//
//  Created by Thaina da Silva Ebert on 14/04/22.
//  Copyright © 2022 Eldorado. All rights reserved.
//

import Foundation

enum Position {
    case monitor, teacher, coordinator, principal, assistant
}

struct Collaborator {
    let name: String
    let enrollment: Int
    let salary: Double
    let position: Position
    
    func description() -> String {
        switch position {
        case .monitor:
            return "Monitor"
        case .teacher:
            return "Professor"
        case .coordinator:
            return "Coordenador"
        case .principal:
            return "Diretor"
        case .assistant:
            return "Assistente"
        }
    }
    
    func abbreviation(ofPosition position: Position) -> String {
        switch position {
        case .monitor:
            return "Mntr."
        case .teacher:
            return "Prof."
        case .coordinator:
            return "Coord."
        case .principal:
            return "Dir."
        case .assistant:
            return "Asst."
        }
    }
    
    func presentation() -> String {
        return "Meu nome é \(name), sou \(position) e minha matrícula é \(enrollment)"
    }
}

