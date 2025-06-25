Class {
	#name : #GeodesicFormulas,
	#superclass : #Object,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [

	| distance azimuth |
	
	(aFromAbsoluteCoordinate isValid and: [aToAbsoluteCoordinate isValid]) ifFalse: [ ^ nil ].
	(aFraction >= 1.0) ifTrue: [ ^ aToAbsoluteCoordinate copy ].
	(aFraction <= 0.0) ifTrue: [ ^ aFromAbsoluteCoordinate copy ].
	
	distance := self distanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.
	azimuth := self azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.

	^ self absoluteCoordinatesFrom: aFromAbsoluteCoordinate distanceInMeters: (distance * aFraction) azimuthInRadians: azimuth
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
