"
I am position of a GeoObject.
"
Class {
	#name : #AbsoluteCoordinates,
	#superclass : #AbstractCoordinates,
	#instVars : [
		'latitudeInDegrees',
		'longitudeInDegrees',
		'altitudeInMeters'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #'instance creation' }
AbsoluteCoordinates class >> ausSydney [

	^ AbsoluteCoordinates 
		latitudeInDegrees: -33.8678500
		longitudeInDegrees: 151.2073200
		altitudeInMeters: 58
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frBordeaux [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 44.8378
		longitudeInDegrees: -0.594
		altitudeInMeters: 22
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frBrest [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.3897
		longitudeInDegrees: -4.48333
		altitudeInMeters: 52
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frElancourt [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.7839
		longitudeInDegrees:  1.95806
		altitudeInMeters: 138 
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frLyon [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 45.7589
		longitudeInDegrees: 4.84139
		altitudeInMeters: 237 
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frMarseille [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 43.2967
		longitudeInDegrees: 5.37639
		altitudeInMeters: 320
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frNevers [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 46.9925
		longitudeInDegrees:  3.15667
		altitudeInMeters: 203 
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> frParis [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.8667
		longitudeInDegrees: 2.33333
		altitudeInMeters: 79 
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees [

	| coordinates |
	coordinates := self latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees altitudeInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees altitudeInMeters: anAltitudeInMeters [

	| coordinates |
	coordinates := self new.
	coordinates latitudeInDegrees: aLatitudeInDegrees.
	coordinates longitudeInDegrees: aLongitudeInDegrees.
	coordinates altitudeInMeters: anAltitudeInMeters.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians [

	| coordinates |
	coordinates := self latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians altitudeInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians altitudeInMeters: anAltitudeInMeters [

	| coordinates |
	coordinates := self new.
	coordinates latitudeInRadians: aLatitudeInRadians.
	coordinates longitudeInRadians: aLongitudeInRadians.
	coordinates altitudeInMeters: anAltitudeInMeters.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> usaLosAngeles [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 34.0522300
		longitudeInDegrees: -118.2436800
		altitudeInMeters: 96
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> usaNewYork [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 40.7142700
		longitudeInDegrees: -74.0059700
		altitudeInMeters: 57 
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> usaSeattle [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 47.6062100
		longitudeInDegrees: -122.3320700
		altitudeInMeters: 56
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> zero [
	^self latitudeInDegrees: 0 longitudeInDegrees: 0 altitudeInMeters: 0
]

{ #category : #comparing }
AbsoluteCoordinates >> = anAbsoluteCoordinates [
	^ self latitudeInDegrees = anAbsoluteCoordinates latitudeInDegrees 
		and: [ self longitudeInDegrees = anAbsoluteCoordinates longitudeInDegrees
		and: [ self altitudeInMeters = anAbsoluteCoordinates altitudeInMeters ]]
]

{ #category : #accessing }
AbsoluteCoordinates >> altitude [
	self altitudeInMeters ifNil:[^nil].
	^ self altitudeInMeters units: #meters
]

{ #category : #accessing }
AbsoluteCoordinates >> altitudeInMeters [
	^ altitudeInMeters
]

{ #category : #accessing }
AbsoluteCoordinates >> altitudeInMeters: aNumber [
	altitudeInMeters := aNumber
]

{ #category : #converting }
AbsoluteCoordinates >> asLatLonDegreesPoint [
	self latitudeInDegrees ifNil:[^nil].
	self longitudeInDegrees ifNil:[^nil].
	^self latitudeInDegrees @ self longitudeInDegrees 
]

{ #category : #converting }
AbsoluteCoordinates >> asLatLonRadiansPoint [
	self latitudeInDegrees ifNil:[^nil].
	self longitudeInDegrees ifNil:[^nil].
	^self latitudeInRadians @ self longitudeInRadians 
]

{ #category : #converting }
AbsoluteCoordinates >> asPoint [
	^self asLatLonDegreesPoint
]

{ #category : #copying }
AbsoluteCoordinates >> copy [
	| copy |
	copy := super copy.
	copy altitudeInMeters: self altitudeInMeters.		
	copy latitudeInDegrees: self latitudeInDegrees.		
	copy longitudeInDegrees: self longitudeInDegrees.		
	^copy
]

{ #category : #accessing }
AbsoluteCoordinates >> isEmpty [ 
	^self latitudeInDegrees isNil and:[self longitudeInDegrees isNil and:[self altitudeInMeters isNil]]
]

{ #category : #accessing }
AbsoluteCoordinates >> isValid [ 
	^self latitudeInDegrees notNil and:[self longitudeInDegrees notNil]
]

{ #category : #accessing }
AbsoluteCoordinates >> latitude [
	self latitudeInDegrees ifNil:[^nil].
	^ self latitudeInDegrees units: #arcdegree
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInDegrees [
	^ latitudeInDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInDegrees: anObject [
	latitudeInDegrees := self normalizeLatitudeInDegrees: anObject.
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInRadians [
	^ latitudeInDegrees degreesToRadians
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInRadians: anObject [
	self latitudeInDegrees: anObject radiansToDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> longitude [
	self longitudeInDegrees ifNil:[^nil].
	^ self longitudeInDegrees units: #arcdegree
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInDegrees [
	^ longitudeInDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInDegrees: anObject [
	longitudeInDegrees := self wrapLongitude: anObject
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInRadians [
	^ longitudeInDegrees degreesToRadians
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInRadians: anObject [
	 self longitudeInDegrees: anObject radiansToDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> normalizeLatitudeInDegrees: aValueInDegrees [
	aValueInDegrees ifNil: [ ^aValueInDegrees ].
	aValueInDegrees > 90 ifTrue: [ ^ 90 ].
	aValueInDegrees < -90 ifTrue: [ ^ -90 ].
	^ aValueInDegrees
]

{ #category : #printing }
AbsoluteCoordinates >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' lat ', (self latitudeInDegrees ifNil:['--']) asString,'°';
		nextPutAll: ' lon ', (self longitudeInDegrees ifNil:['--']) asString,'°';
		nextPutAll: ' alt ', (self altitudeInMeters ifNil:['--']) asString,'m'
]

{ #category : #accessing }
AbsoluteCoordinates >> wrapLongitude: aValueInDegrees [
	| result |
	aValueInDegrees ifNil: [ ^aValueInDegrees ].
	result := aValueInDegrees.
	(result < -180 or: [ result > 180 ]) ifTrue:
		[ result := result + 180.
		result := result \\ 360.
	 	result := result < 0
			ifTrue: [ 180 + result ]
			ifFalse: [ -180 + result ]].
	^ result
]
