"
I am Cartesian Coordinates.

The geocentric coordinate system is a geographic coordinate system in which the Earth is modeled as an ellipsoid in a right-handed XYZ (3D Cartesian) system, measured from the center of the Earth. In this system:

- X points towards the prime meridian
- Y points to 90° outside of the equatorial plane
- Z points in the direction of the North Pole.

It is important to note that the geocentric coordinate system is not a planar coordinate system based on a map projection. It is used internally as a transient system, serving as a computational framework in several geographical transformation methods.
"
Class {
	#name : #CartesianCoordinates,
	#superclass : #SmockAbstractCoordinates,
	#instVars : [
		'xInMeters',
		'yInMeters',
		'zInMeters'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #'instance creation' }
CartesianCoordinates class >> xInMeters: aXMeters yInMeters: aYMeters [

	| coordinates |
	coordinates := self xInMeters: aXMeters yInMeters: aYMeters zInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
CartesianCoordinates class >> xInMeters: aXMeters yInMeters: aYMeters zInMeters: aZMeters [ 

	| coordinates |
	coordinates := self new.
	coordinates xInMeters: aXMeters.
	coordinates yInMeters: aYMeters.
	coordinates zInMeters: aZMeters.
	^coordinates
]

{ #category : #'instance creation' }
CartesianCoordinates class >> zero [

	^ self xInMeters: 0 yInMeters: 0 zInMeters: 0
]

{ #category : #comparing }
CartesianCoordinates >> = aCartesianCoordinates [
	
	aCartesianCoordinates ifNil:[ ^ false ].

	^ self xInMeters = aCartesianCoordinates xInMeters
		and: [ self yInMeters = aCartesianCoordinates yInMeters  
		and: [ self zInMeters = aCartesianCoordinates zInMeters ]]
]

{ #category : #copying }
CartesianCoordinates >> asPoint [

	self isValid ifFalse: [ ^ nil ].
	^ self xInMeters @ self yInMeters
]

{ #category : #copying }
CartesianCoordinates >> copy [

	| copy |
	copy := super copy.
	copy xInMeters: self xInMeters.		
	copy yInMeters: self yInMeters.		
	copy zInMeters: self zInMeters.		
	^copy
]

{ #category : #testing }
CartesianCoordinates >> isEmpty [

	^ self xInMeters isNil and: [ self yInMeters isNil and: [ self zInMeters isNil ] ]
]

{ #category : #testing }
CartesianCoordinates >> isValid [

	^ self xInMeters notNil and: [ self yInMeters notNil ]
]

{ #category : #printing }
CartesianCoordinates >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' x ', (self xInMeters ifNil:['--']) asString, 'm';
		nextPutAll: ' y ', (self yInMeters ifNil:['--']) asString, 'm';
		nextPutAll: ' z ', (self zInMeters ifNil:['--']) asString, 'm'
]

{ #category : #accessing }
CartesianCoordinates >> xInMeters [

	^ xInMeters
]

{ #category : #accessing }
CartesianCoordinates >> xInMeters: anObject [

	xInMeters := anObject
]

{ #category : #accessing }
CartesianCoordinates >> yInMeters [

	^ yInMeters
]

{ #category : #accessing }
CartesianCoordinates >> yInMeters: anObject [

	yInMeters := anObject
]

{ #category : #accessing }
CartesianCoordinates >> zInMeters [

	^ zInMeters
]

{ #category : #accessing }
CartesianCoordinates >> zInMeters: anObject [

	zInMeters := anObject
]
