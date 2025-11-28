//
//  Address+CoreDataClass.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import CoreData

@objc(Address)
public class Address: NSManagedObject {}

extension Address {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var country: String?

    static func createOrUpdate(from dto: AddressDTO, in ctx: NSManagedObjectContext) -> Address {
        let req: NSFetchRequest<Address> = Address.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", dto.id as CVarArg)
        let result = (try? ctx.fetch(req))?.first
        let ent = result ?? Address(context: ctx)
        ent.id = dto.id
        ent.street = dto.street
        ent.city = dto.city
        ent.state = dto.state
        ent.country = dto.country
        return ent
    }
}
