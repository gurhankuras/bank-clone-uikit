//
//  CampaignEntity+CoreDataProperties.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//
//

import Foundation
import CoreData

extension CampaignEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CampaignEntity> {
        return NSFetchRequest<CampaignEntity>(entityName: "CampaignEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var link: String?
    @NSManaged public var read: Bool

}

extension CampaignEntity: Identifiable {

}
