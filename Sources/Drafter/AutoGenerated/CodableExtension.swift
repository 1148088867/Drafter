// Generated using Sourcery 0.11.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT








// MARK: - ClassNode Codable
extension ClassNode {
    enum CodingKeys: String, CodingKey {
        case isSwift 
        case superCls 
        case className 
        case protocols 
        case methods 
    }

}

// MARK: - ImplementationNode Codable
extension ImplementationNode {
    enum CodingKeys: String, CodingKey {
        case className 
        case methods 
    }

}

// MARK: - InterfaceNode Codable
extension InterfaceNode {
    enum CodingKeys: String, CodingKey {
        case superCls 
        case className 
        case protocols 
    }

}

// MARK: - InvokeParam Codable
extension InvokeParam {
    enum CodingKeys: String, CodingKey {
        case name 
        case invokes 
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        invokes = try container.decode([MethodInvokeNode].self, forKey: .invokes)
    }
}

// MARK: - MethodInvokeNode Codable
extension MethodInvokeNode {
    enum CodingKeys: String, CodingKey {
        case isSwift 
        case invoker 
        case methodName 
        case params 
    }

}

// MARK: - MethodInvoker Codable
extension MethodInvoker {
    enum CodingKeys: String, CodingKey {
        case key
        case name_0
        case method_0
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .name(let val0):
                try container.encode("name", forKey: .key)
                try container.encode(val0, forKey: .name_0)
            case .method(let val0):
                try container.encode("method", forKey: .key)
                try container.encode(val0, forKey: .method_0)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        switch key {
        case "name":
            self = .name(
                try container.decode(String.self, forKey: .name_0)
            )
        default:
            self = .method(
                try container.decode(MethodInvokeNode.self, forKey: .method_0)
            )
        }
    }
}

// MARK: - MethodNode Codable
extension MethodNode {
    enum CodingKeys: String, CodingKey {
        case isSwift 
        case isStatic 
        case returnType 
        case methodName 
        case params 
        case invokes 
    }

}

// MARK: - Param Codable
extension Param {
    enum CodingKeys: String, CodingKey {
        case outterName 
        case type 
        case innerName 
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        outterName = try container.decode(String.self, forKey: .outterName)
        type = try container.decode(String.self, forKey: .type)
        innerName = try container.decode(String.self, forKey: .innerName)
    }
}

// MARK: - ProtocolNode Codable
extension ProtocolNode {
    enum CodingKeys: String, CodingKey {
        case name 
        case supers 
    }

}

