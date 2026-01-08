"
See https://en.wikipedia.org/wiki/Degree_(angle)#Subdivisions
and https://en.wikipedia.org/wiki/ISO_6709
"
Class {
	#name : #DMSAbsoluteCoordinatesPrinter,
	#superclass : #AbstractAbsoluteCoordinatesPrinter,
	#instVars : [
		'characterDegree',
		'characterMinute',
		'characterSecond',
		'characterNorth',
		'characterSouth',
		'characterEast',
		'characterWest',
		'characterSeparatorLatLon',
		'characterSeparatorAlt',
		'altitudeUnit',
		'withSpaces'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> altitudeUnit [

	^ altitudeUnit ifNil: [ altitudeUnit := Unit meters ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> altitudeUnit: anObject [

	altitudeUnit := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterDegree [

	^ characterDegree ifNil:[ characterDegree := Character value: 16rB0 ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterDegree: anObject [

	characterDegree := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterEast [

	^ characterEast ifNil: [ characterEast := $E ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterEast: anObject [

	characterEast := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterMinute [

	^ characterMinute ifNil:[ characterMinute := Character value: 16r27 ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterMinute: anObject [

	characterMinute := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterNorth [

	^ characterNorth ifNil: [ characterNorth := $N ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterNorth: anObject [

	characterNorth := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSecond [

	^ characterSecond ifNil:[ characterSecond := Character value: 16r22 ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSecond: anObject [

	characterSecond := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSeparatorAlt [

	^ characterSeparatorAlt ifNil: [ characterSeparatorAlt := Character null ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSeparatorAlt: anObject [

	characterSeparatorAlt := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSeparatorLatLon [

	^ characterSeparatorLatLon ifNil: [ characterSeparatorLatLon := Character space ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSeparatorLatLon: anObject [

	characterSeparatorLatLon := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSouth [

	^ characterSouth ifNil: [ characterSouth := $S ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterSouth: anObject [

	characterSouth := anObject
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterWest [

	^ characterWest ifNil: [ characterWest := $W ]
]

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinter >> characterWest: anObject [

	characterWest := anObject
]

{ #category : #printing }
DMSAbsoluteCoordinatesPrinter >> printAbsoluteCoordinates: anAbsoluteCoordinates on: aStream [

	anAbsoluteCoordinates isValid ifFalse:[ ^ self ].

	self printLatitude: anAbsoluteCoordinates latitude on: aStream.

	self withSpaces ifTrue: [ aStream space ].
	aStream nextPut: self characterSeparatorLatLon.
	self withSpaces ifTrue: [ aStream space ].

	self printLongitude: anAbsoluteCoordinates longitude on: aStream.

	anAbsoluteCoordinates altitude ifNotNil: [ :e |
			self characterSeparatorAlt = Character null 
				ifFalse:[ aStream nextPut: self characterSeparatorAlt ]
				ifTrue:[ aStream space ].
			self withSpaces ifTrue: [ aStream space ].
			self printAltitude: e on: aStream ]
]

{ #category : #printing }
DMSAbsoluteCoordinatesPrinter >> printAltitude: anAltitudeUnit on: aStream [

	| altitude |
	anAltitudeUnit ifNil:[ ^ self ].
	altitude := (anAltitudeUnit convertTo: self altitudeUnit) value.

	aStream nextPutAll: (altitude roundTo: 1 asInteger) printString.
	aStream nextPutAll: self altitudeUnit abbreviation
]

{ #category : #printing }
DMSAbsoluteCoordinatesPrinter >> printLatitude: aLatitudeUnit on: aStream [
	"Degree Minute Second Orientation : 10°00'00''N"

	| num degrees minutes seconds latitude |
	aLatitudeUnit ifNil:[ ^ self ].
	latitude := (aLatitudeUnit convertTo: Unit deg) value.
	
	"conversion"
	num := latitude abs.
	degrees := num truncated.
	num := num - degrees.
	num := (num * 60.0 roundTo: 0.01) asFloat.
	num = 60.00 ifTrue: [
			degrees := degrees + 1.
			num := 0.0 ].
	minutes := num truncated.
	num := num - minutes.
	num := (num * 60.0 roundTo: 0.01) asFloat.
	num = 60.00 ifTrue: [
			minutes := minutes + 1.
			num := 0.0 ].
	seconds := num truncated.
	
	"print"
	degrees < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: degrees printString.
	aStream nextPut: self characterDegree.
	self withSpaces ifTrue:[ aStream space ].
	
	minutes < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: minutes printString.
	aStream nextPut: self characterMinute.
	self withSpaces ifTrue:[ aStream space ].
	
	seconds < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: seconds printString.
	aStream nextPut: self characterSecond.
	self withSpaces ifTrue:[ aStream space ].
	
	latitude < 0.0
		ifTrue: [ aStream nextPut: self characterSouth ]
		ifFalse: [ aStream nextPut: self characterNorth ].
	
]

{ #category : #printing }
DMSAbsoluteCoordinatesPrinter >> printLongitude: aLongitudeUnit on: aStream [
	"Degree Minute Second Orientation : 100°00'00''E"

	| num degrees valAngle minutes seconds longitude |
	aLongitudeUnit ifNil: [ ^ self ].
	longitude := (aLongitudeUnit convertTo: Unit deg) value.

	"conversion"
	valAngle := longitude > 180.0
		            ifTrue: [ longitude - 360.0 ]
		            ifFalse: [
				            longitude < -180.0
					            ifTrue: [ longitude + 360.0 ]
					            ifFalse: [ longitude ] ].
	num := valAngle abs.
	degrees := num truncated.
	num := num - degrees.
	num := (num * 60.0 roundTo: 0.01) asFloat.
	num = 60.00 ifTrue: [
			degrees := degrees + 1.
			num := 0.0 ].
	minutes := num truncated.
	num := num - minutes.
	num := (num * 60.0 roundTo: 0.01) asFloat.
	num = 60.00 ifTrue: [
			minutes := minutes + 1.
			num := 0.0 ].
	seconds := num truncated.

	"print"
	degrees < 100.0 ifTrue: [ aStream nextPut: $0 ].
	degrees < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: degrees printString.
	aStream nextPut: self characterDegree.
	self withSpaces ifTrue: [ aStream space ].

	minutes < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: minutes printString.
	aStream nextPut: self characterMinute.
	self withSpaces ifTrue: [ aStream space ].

	seconds < 10.0 ifTrue: [ aStream nextPut: $0 ].
	aStream nextPutAll: seconds printString.
	aStream nextPut: self characterSecond.
	self withSpaces ifTrue: [ aStream space ].

	valAngle < 0.0
		ifTrue: [ aStream nextPut: self characterWest ]
		ifFalse: [ aStream nextPut: self characterEast ]
]

{ #category : #format }
DMSAbsoluteCoordinatesPrinter >> reset [
	"Default values are ISO 6709"

	self withSpaces: nil.
	self characterSeparatorLatLon: nil.
	self characterSeparatorAlt: nil.
	
	self characterDegree: nil.
	self characterMinute: nil.
	self characterSecond: nil.
	
	self characterNorth: nil.
	self characterSouth: nil.
	self characterEast: nil.
	self characterWest: nil.
	
	self altitudeUnit: nil.
]

{ #category : #format }
DMSAbsoluteCoordinatesPrinter >> withSpaces [

	^ withSpaces ifNil: [ withSpaces := false ]
]

{ #category : #format }
DMSAbsoluteCoordinatesPrinter >> withSpaces: anObject [

	withSpaces := anObject
]
