Class {
	#name : #GeodesicFormulas,
	#superclass : #Object,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [

	self subclassResponsibility 
]

{ #category : #tools }
GeodesicFormulas >> distanceInMetersFrom: aFromAbsoluteCoordinate to: anEndAbsoluteCoordinate [

	self subclassResponsibility 
]

{ #category : #haversine }
GeodesicFormulas >> haversineDistanceFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [
	"Haversine formulas to compute distance from two positions of a big circle - efficient to compute distance around the equator"
	"sources: https://fr.wikipedia.org/wiki/Formule_de_haversine"
	
	| radius deltaLat deltaLon a c |	
	radius := WGS84 semiMajorAxisInMeters.
	deltaLat := aToAbsoluteCoordinate latitudeInRadians - aFromAbsoluteCoordinate latitudeInRadians.
	deltaLon := aToAbsoluteCoordinate longitudeInRadians - aFromAbsoluteCoordinate longitudeInRadians.
	
	a := ((deltaLat / 2) sin squared) 
			+ (aFromAbsoluteCoordinate latitudeInRadians cos * aToAbsoluteCoordinate latitudeInRadians cos * ((deltaLon / 2) sin squared)).
	c := 2 * (a sqrt arcTan: ((1 - a) sqrt)).

	^ radius * c
]
