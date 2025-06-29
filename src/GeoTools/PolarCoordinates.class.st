"
I am a PolarCoordinates.
"
Class {
	#name : #PolarCoordinates,
	#superclass : #SmockAbstractCoordinates,
	#instVars : [
		'azimuthInRadians',
		'distanceInMeters',
		'elevationInMeters'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #'instance creation' }
PolarCoordinates class >> azimuthInRadians: anAzimuth distanceInMeters: aDistance [
	| coordinates |
	coordinates := self azimuthInRadians: anAzimuth distanceInMeters: aDistance elevationInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
PolarCoordinates class >> azimuthInRadians: anAzimuth distanceInMeters: aDistance elevationInMeters: anElevation [
	| coordinates |
	coordinates := self new.
	coordinates azimuthInRadians: anAzimuth.
	coordinates distanceInMeters: aDistance.
	coordinates elevationInMeters: anElevation.
	^coordinates
]

{ #category : #'instance creation' }
PolarCoordinates class >> zero [

	^ self azimuthInRadians: 0 distanceInMeters: 0 elevationInMeters: 0
]

{ #category : #comparing }
PolarCoordinates >> = aPolarCoordinates [
	
	aPolarCoordinates ifNil:[ ^ false ].

	^ self azimuthInRadians = aPolarCoordinates azimuthInRadians 
		and: [ self distanceInMeters = aPolarCoordinates distanceInMeters and:[self elevationInMeters  = aPolarCoordinates elevationInMeters ] ]
]

{ #category : #converting }
PolarCoordinates >> asCartesianCoordinates [

	^ CartesianCoordinates 
		xInMeters: self azimuthInRadians cos * self distanceInMeters * self elevationInMeters sin  
		yInMeters: self azimuthInRadians cos * self distanceInMeters * self elevationInMeters cos  
		zInMeters: self azimuthInRadians sin * self distanceInMeters
]

{ #category : #converting }
PolarCoordinates >> asPoint [

	self isValid ifFalse:[ ^ nil ].
	^ self azimuthInDegrees @ self distanceInMeters 
]

{ #category : #accessing }
PolarCoordinates >> azimuthInDegrees [

	^ azimuthInRadians ifNotNil: [ :e | e radiansToDegrees ]
]

{ #category : #accessing }
PolarCoordinates >> azimuthInRadians [

	^ azimuthInRadians
]

{ #category : #accessing }
PolarCoordinates >> azimuthInRadians: anObject [

	azimuthInRadians := anObject
]

{ #category : #copying }
PolarCoordinates >> copy [

	| copy |
	copy := super copy.
	copy azimuthInRadians: self azimuthInRadians.		
	copy distanceInMeters: self distanceInMeters.	
	copy elevationInMeters: self elevationInMeters. 	
	^copy
]

{ #category : #accessing }
PolarCoordinates >> distanceInMeters [

	^ distanceInMeters
]

{ #category : #accessing }
PolarCoordinates >> distanceInMeters: anObject [

	distanceInMeters := anObject
]

{ #category : #accessing }
PolarCoordinates >> elevationInMeters [

	^ elevationInMeters
]

{ #category : #accessing }
PolarCoordinates >> elevationInMeters: anObject [

	elevationInMeters := anObject
]

{ #category : #testing }
PolarCoordinates >> isEmpty [

	^ self azimuthInRadians isNil and: [ self distanceInMeters isNil and: [ self elevationInMeters isNil ] ]
]

{ #category : #testing }
PolarCoordinates >> isValid [

	^ self azimuthInRadians notNil and: [ self distanceInMeters notNil ]
]

{ #category : #converting }
PolarCoordinates >> localToAbsoluteCoordinates: anOriginAbsoluteCoordinates [
	"Convert a local polar coordinates to an absoluted coordinates by an Earth-Centered, Earth-Fixed cartesian coordinates using an absolute coordinates as referential"

	| localCartesianCoordinates ecefCartesianCoordinates |
	localCartesianCoordinates := self asCartesianCoordinates.
	ecefCartesianCoordinates := anOriginAbsoluteCoordinates localToECEFCartesianCoordinates: localCartesianCoordinates.
	^ ecefCartesianCoordinates asECEFtoAbsoluteCoordinates
]

{ #category : #copying }
PolarCoordinates >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' az ', (self azimuthInRadians ifNil:['--']) asString,'radians';
		nextPutAll: ' dist ', (self distanceInMeters ifNil:['--']) asString,'m';
		nextPutAll: ' ele ', (self elevationInMeters ifNil:['--']) asString,'m'
]
