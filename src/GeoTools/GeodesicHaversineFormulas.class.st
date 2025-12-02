Class {
	#name : #GeodesicHaversineFormulas,
	#superclass : #GeodesicFormulas,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicHaversineFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [
	"Calculate intermediate point along great circle path at given fraction"
	
	| distance azimuth |
	
	(aFromAbsoluteCoordinate isValid and: [aToAbsoluteCoordinate isValid]) ifFalse: [ ^ nil ].
	(aFraction >= 1.0) ifTrue: [ ^ aToAbsoluteCoordinate copy ].
	(aFraction <= 0.0) ifTrue: [ ^ aFromAbsoluteCoordinate copy ].
	
	distance := self distanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.
	azimuth := self azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.
	
	^ self absoluteCoordinatesFrom: aFromAbsoluteCoordinate distanceInMeters: distance * aFraction azimuthInRadians: azimuth
]

{ #category : #tools }
GeodesicHaversineFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	"Calculate destination point given distance and bearing from start point"
	
	| radius angularDistance lat1 lon1 lat2 lon2 |
	
	anAbsoluteCoordinates isValid ifFalse: [ ^ nil ].
	aDistanceInM = 0 ifTrue: [ ^ anAbsoluteCoordinates copy ].
	
	radius := WGS84 semiMajorAxisInMeters.
	angularDistance := aDistanceInM / radius.
	
	lat1 := anAbsoluteCoordinates latitudeInRadians.
	lon1 := anAbsoluteCoordinates longitudeInRadians.
	
	lat2 := ((lat1 sin * angularDistance cos) + (lat1 cos * angularDistance sin * anAzimuthInRadians cos)) arcSin.
	
	lon2 := lon1 + ((anAzimuthInRadians sin * angularDistance sin * lat1 cos) 
		arcTan: ((angularDistance cos) - (lat1 sin * lat2 sin))).
	
	"Normalize longitude to [-π, π]"
	lon2 := (((lon2 + (3 * Float pi)) euclideanModulo: (2 * Float pi)) - Float pi).
	
	^ AbsoluteCoordinates latitudeInRadians: lat2 longitudeInRadians: lon2
]

{ #category : #tools }
GeodesicHaversineFormulas >> azimuthInRadiansFrom: aFromAbsoluteCoordinates to: anToAbsoluteCoordinates [
	"Calculate initial bearing (azimuth) from start point to end point"
	
	| lat1 lat2 deltaLon y x azimuth |
	
	(aFromAbsoluteCoordinates isValid not or: [anToAbsoluteCoordinates isValid not]) ifTrue: [ ^ 0 ].
	
	"Same point - no azimuth"
	(aFromAbsoluteCoordinates latitudeInRadians = anToAbsoluteCoordinates latitudeInRadians 
		and: [aFromAbsoluteCoordinates longitudeInRadians = anToAbsoluteCoordinates longitudeInRadians]) 
		ifTrue: [ ^ 0 ].
	
	lat1 := aFromAbsoluteCoordinates latitudeInRadians.
	lat2 := anToAbsoluteCoordinates latitudeInRadians.
	deltaLon := anToAbsoluteCoordinates longitudeInRadians - aFromAbsoluteCoordinates longitudeInRadians.
	
	y := deltaLon sin * lat2 cos.
	x := (lat1 cos * lat2 sin) - (lat1 sin * lat2 cos * deltaLon cos).
	
	azimuth := (y @ x) theta.
	
	^ azimuth negative
		ifTrue: [ azimuth + (2 * Float pi) ]
		ifFalse: [ azimuth ]
]

{ #category : #tools }
GeodesicHaversineFormulas >> distanceInMetersFrom: aFromAbsoluteCoordinate to: anEndAbsoluteCoordinate [
	"Haversine formulas to compute distance from two positions of a big circle - efficient to compute distance around the equator"
	"sources: https://fr.wikipedia.org/wiki/Formule_de_haversine"
	
	| radius deltaLat deltaLon a c |	
	radius := WGS84 semiMajorAxisInMeters.
	deltaLat := anEndAbsoluteCoordinate latitudeInRadians - aFromAbsoluteCoordinate latitudeInRadians.
	deltaLon := anEndAbsoluteCoordinate longitudeInRadians - aFromAbsoluteCoordinate longitudeInRadians.
	
	a := ((deltaLat / 2) sin squared) 
			+ (aFromAbsoluteCoordinate latitudeInRadians cos * anEndAbsoluteCoordinate latitudeInRadians cos * ((deltaLon / 2) sin squared)).
	c := 2 * (a sqrt arcTan: ((1 - a) sqrt)).

	^ radius * c
]
