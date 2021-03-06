//
//  TVShow.swift
//  Soap4TV
//
//  Created by Peter on 11/11/15.
//  Copyright © 2015 Peter Tikhomirov. All rights reserved.
//

import ObjectMapper

struct TVShow: Mappable {
	
	var sid: Int?
	var title: String?
	var title_ru: String?
	var description: String?
	var year: Int?
	var imdb_rating: Float?
	var imdb_votes: Int?
	var imdb_id: String?
	var tvdb_id: Int?
	var status: Int?
	var kinopoisk_id: Int?
	var kinopoisk_votes: Int?
	var kinopoisk_rating: Float?
	var country: String?
	var tvmaze_id: Int?
	var watching: Bool?
	var unwatched: Int?
	
	init?(_ map: Map){}
	
	let convertToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
		guard let myInt = value else { return nil }
		return Int(myInt)
		}, toJSON: { (value: Int?) -> String? in
			return nil
	})
	
	let convertToFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
		guard let myFloat = value else { return nil }
		return Float(myFloat)
		}, toJSON: { (value: Float?) -> String? in
			return nil
	})
	
	let convertToBool = TransformOf<Bool, String>(fromJSON: { (value: String?) -> Bool? in
		return value == "1" ? true : false
		}, toJSON: { (value: Bool?) -> String? in
			return nil
	})
	
	mutating func mapping(map: Map) {
		sid <- (map["sid"], convertToInt)
		title <- map["title"]
		title_ru <- map["title_ru"]
		description <- map["description"]
		year <- (map["year"], convertToInt)
		imdb_rating <- (map["imdb_rating"], convertToFloat)
		imdb_votes <- (map["imdb_votes"], convertToInt)
		imdb_id <- map["imdb_id"]
		tvdb_id <- (map["tvdb_id"], convertToInt)
		status <- (map["status"], convertToInt)
		kinopoisk_id <- (map["kinopoisk_id"], convertToInt)
		kinopoisk_votes <- (map["kinopoisk_votes"], convertToInt)
		kinopoisk_rating <- (map["kinopoisk_rating"], convertToFloat)
		country <- map["country"]
		tvmaze_id <- (map["tvmaze_id"], convertToInt)
		watching <- (map["watching"], convertToBool)
		unwatched <- map["unwatched"]
	}
}

extension TVShow: Equatable, Comparable {}

func ==(lhs: TVShow, rhs: TVShow) -> Bool {
	return lhs.sid == rhs.sid && lhs.sid == rhs.sid
}

infix operator • { associativity left precedence 140 } // Compating by rating operator
func •(lhs: TVShow, rhs: TVShow) -> Bool { // Comparing by new episodes
	if lhs.unwatched > 0 && rhs.unwatched > 0 { return lhs.title < rhs.title }
	if lhs.unwatched == 0 && rhs.unwatched == 0 { return lhs.title < rhs.title }
	return lhs.unwatched > rhs.unwatched
}

func <(lhs: TVShow, rhs: TVShow) -> Bool { // Comparing by show ID
	return lhs.sid < rhs.sid
}

func >(lhs: TVShow, rhs: TVShow) -> Bool { // Comparing by year && newest tv show
	if lhs.year == rhs.year {
		return lhs.sid > rhs.sid
	} else {
		return lhs.year > rhs.year
	}
}

infix operator ~ { associativity left precedence 140 } // Compating by rating operator
func ~(lhs: TVShow, rhs: TVShow) -> Bool {
	return lhs.imdb_rating > rhs.imdb_rating
}

infix operator ± { associativity left precedence 140 } // Compating by english alphabet
func ±(lhs: TVShow, rhs: TVShow) -> Bool {
	return lhs.title < rhs.title
}

infix operator § { associativity left precedence 140 } // Compating by russian alphabet
func §(lhs: TVShow, rhs: TVShow) -> Bool {
	return lhs.title_ru < rhs.title_ru
}


struct Schedule: Mappable {
	
	var episode: String?
	var date: NSDate?
	var title: String?
	var sid: Int?
	
	init?(_ map: Map){}
	
	let convertToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
		guard let myInt = value else { return nil }
		return Int(myInt)
		}, toJSON: { (value: Int?) -> String? in
			return nil
	})
	
	let convertToDate = TransformOf<NSDate, String>(fromJSON: { (value: String?) -> NSDate? in
		guard let dateValue = value else { return nil }
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		let myDate = dateFormatter.dateFromString(dateValue)
		return myDate
		}, toJSON: { (value: NSDate?) -> String? in
			return nil
	})
	
	mutating func mapping(map: Map) {
		sid <- (map["sid"], convertToInt)
		title <- map["title"]
		date <- (map["date"], convertToDate)
		episode <- map["episode"]
	}
}
