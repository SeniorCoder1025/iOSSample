//
//  AppDatabase.swift
//  iOSSample
//
//  Created by apple on 9/19/18.
//  Copyright © 2018 ken. All rights reserved.
//

import SQLite

class DeliverTable {
    
    let table = Table("delivers")
    let id      = Expression<Int64>("id")
    let desc    = Expression<String>("desc")
    let imageUrl = Expression<String>("imageUrl")
    let lng     = Expression<Double>("lng")
    let lat     = Expression<Double>("lat")
    let address = Expression<String>("address")
    
    var db: Connection? {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            let db = try Connection("\(path)/db.sqlite3")
            return db
        } catch {
            print(error)
        }
        return nil
    }
    
    static let shared = DeliverTable()
    
    init() {
        createTable()
    }
    
    func insertDeliver(deliver: Deliver) {
        do {
            try db?.run(table.insert(
                or: .replace,
                id <- deliver.id,
                desc <- deliver.desc,
                imageUrl <- deliver.imageUrl,
                lat <- deliver.lat,
                lng <- deliver.lng,
                address <- deliver.address
            ))
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try db?.run(table.delete())
        } catch {
            print(error)
        }
    }
    
    func getAll() -> [Deliver] {
        var delivers = [Deliver]()
        do {
            for deliverRow in (try db?.prepare(table))! {
                let deliver = Deliver()
                deliver.id = deliverRow[id]
                deliver.desc = deliverRow[desc]
                deliver.imageUrl = deliverRow[imageUrl]
                deliver.lat = deliverRow[lat]
                deliver.lng = deliverRow[lng]
                deliver.address = deliverRow[address]
                delivers.append(deliver)
            }
            return delivers
        } catch {
            return delivers
        }
    }
    
    func getDelivers(offset: Int, limit: Int) -> [Deliver] {
        var delivers = [Deliver]()
        do {
            for deliverRow in (try db?.prepare(table.order(id).limit(limit, offset: offset)))! {
                let deliver = Deliver()
                deliver.id = deliverRow[id]
                deliver.desc = deliverRow[desc]
                deliver.imageUrl = deliverRow[imageUrl]
                deliver.lat = deliverRow[lat]
                deliver.lng = deliverRow[lng]
                deliver.address = deliverRow[address]
                delivers.append(deliver)
            }
            return delivers
        } catch {
            return delivers
        }
    }
    
    func createTable() {
        do {
            try db?.run(table.create(ifNotExists: true){ t in
                t.column(id, primaryKey: true)
                t.column(desc)
                t.column(imageUrl)
                t.column(lng)
                t.column(lat)
                t.column(address)
            })
        }catch{
            print(error)
        }
    }
}
