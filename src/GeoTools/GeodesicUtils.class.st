"
GeodesicUtils provide some tools to compute geodesics easily. 
Please use this class ponctually, if you need several/chained processing reuse an instance of GeodesicFormulas.
"
Class {
	#name : #GeodesicUtils,
	#superclass : #Object,
	#classInstVars : [
		'formulas'
	],
	#category : #'GeoTools-Geodesic'
}

{ #category : #utilities }
GeodesicUtils class >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [
	"Find the position that corresponds to a fraction of t (0 <= t <= 1) of a geodesic that is defined by two positions"

	^ self formulas
		  absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate
		  to: aToAbsoluteCoordinate
		  atFraction: aFraction
]

{ #category : #utilities }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistance azimuth: anAzimuth [
	"Return the position (AbsoluteCoordinates) from a starting coordinates, a distance and an angle as Unit instances"

	^ self
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInMeters: (aDistance convertTo: Unit meter) value
		  azimuthInRadians: (anAzimuth convertTo: Unit radian) value
]

{ #category : #utilities }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	"Return the position (AbsoluteCoordinates) from a starting coordinates, a distance in meters and an angle in radians"

	^ self formulas
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInMeters: aDistanceInM
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #utilities }
GeodesicUtils class >> azimuthFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Return an azimuth between two absolute coordinates as a Unit instance"

	^ (self formulas
		   azimuthInRadiansFrom: startAbsoluteCoordinate
		   to: endAbsoluteCoordinate) radians
]

{ #category : #utilities }
GeodesicUtils class >> azimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Return an azimuth between two absolute coordinates as a Number in radians degrees"

	^ self formulas
		  azimuthInRadiansFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #cleanup }
GeodesicUtils class >> cleanUp [

	formulas := nil.

	super cleanUp
]

{ #category : #utilities }
GeodesicUtils class >> distanceFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Return a distance between two absolute coordinates as a Unit instance"

	^ (self formulas
		   distanceInMetersFrom: startAbsoluteCoordinate
		   to: endAbsoluteCoordinate) meters
]

{ #category : #utilities }
GeodesicUtils class >> distanceInMetersFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Return a distance between two absolute coordinates as a Number in meters"

	^ self formulas
		  distanceInMetersFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #accessing }
GeodesicUtils class >> formulas [

	^ formulas ifNil: [ formulas := GeodesicVincentyFormulas new ]
]

{ #category : #utilities }
GeodesicUtils class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuth: anAzimuthInDegree area: aListOfAbsoluteCoords [

	self
		deprecated: 'Use isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuthInDegrees: anAzimuthInDegree area: aListOfAbsoluteCoords'
		transformWith: 
			'`@receiver isAzimuthTowardsAreaFrom: `@anAbsCoordOrigin azimuth: `@anAzimuthInDegree area: `@aListOfAbsoluteCoords'
			-> 
			'`@receiver isAzimuthTowardsAreaFrom: `@anAbsCoordOrigin azimuthInDegrees: `@anAzimuthInDegree area: `@aListOfAbsoluteCoords'.

	^ self
		  isAzimuthTowardsAreaFrom: anAbsCoordOrigin
		  azimuthInDegrees: anAzimuthInDegree degreesToRadians
		  area: aListOfAbsoluteCoords
]

{ #category : #utilities }
GeodesicUtils class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuthInDegrees: anAzimuthInDegree area: aListOfAbsoluteCoords [

	^ self
		  isAzimuthTowardsAreaFrom: anAbsCoordOrigin
		  azimuthInRadians: anAzimuthInDegree degreesToRadians
		  area: aListOfAbsoluteCoords
]

{ #category : #utilities }
GeodesicUtils class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuthInRadians: anAzimuthInRadians area: aListOfAbsoluteCoords [

	| listAngles isPointingArea azRad |
	isPointingArea := false.

	aListOfAbsoluteCoords isEmptyOrNil ifTrue: [ ^ isPointingArea ].

	"Compute angles between origin position and vertices of area"
	listAngles := (aListOfAbsoluteCoords collect: [ :absCoord |
		               self azimuthInRadiansFrom: anAbsCoordOrigin to: absCoord ]) asOrderedCollection.
	listAngles add: listAngles first.

	azRad := anAzimuthInRadians.

	isPointingArea := false.
	listAngles withIndexDo: [ :a :i |
		| nextAngle |
		isPointingArea := isPointingArea or: [ azRad closeTo: a precision: 1e-3 ].

		i < listAngles size ifTrue: [ | diff |
			nextAngle := listAngles at: i + 1.
			diff := nextAngle - a.
			diff negative ifTrue:[ diff := diff + (2 * Float pi)].
			isPointingArea := (diff <= Float pi) 
				ifTrue: [ isPointingArea or: [ azRad isAngleInRadiansBetween: a and: nextAngle ] ]
				ifFalse: [ isPointingArea or: [ azRad isAngleInRadiansBetween: nextAngle and: a  ] 
			].
			isPointingArea := isPointingArea or: [ azRad closeTo: nextAngle precision: 1e-3 ] 
		] 
	].

	^ isPointingArea
]

{ #category : #'see class side' }
GeodesicUtils >> seeClassSide [ 
]
