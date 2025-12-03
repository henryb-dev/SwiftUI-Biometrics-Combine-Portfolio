//
//  AddressDTO.swift
//  Address
//
//  Created by Henry Bautista on 2/12/25.
//
import Foundation

struct AddressDTO: Codable {
    let id: UUID
    let street: String
    let city: String
    let state: String
    let country: String
}
