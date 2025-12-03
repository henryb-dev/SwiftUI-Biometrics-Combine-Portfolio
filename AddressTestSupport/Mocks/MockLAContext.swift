//
//  MockLAContext.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import LocalAuthentication
@testable import Address

class MockLAContext: LAContext {
    var canEval = true
    var evalSucceeds = true

    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEval
    }

    override func evaluatePolicy(_ policy: LAPolicy,
                                 localizedReason: String,
                                 reply: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
                    reply(self.evalSucceeds, nil)
        }
    }
}
