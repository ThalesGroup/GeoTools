"
An AbsoluteCoordinatesTest is a test class for testing the behavior of AbsoluteCoordinates
"
Class {
	#name : #AbsoluteCoordinatesTest,
	#superclass : #TestCase,
	#instVars : [
		'absCoord'
	],
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #running }
AbsoluteCoordinatesTest >> setUp [

	super setUp.

	absCoord := AbsoluteCoordinates new
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinates [
	| coord |
	coord := AbsoluteCoordinates new.
	self assert: coord isEmpty equals: true.
	self assert: coord isValid equals: false.
	self assert: coord latitudeInDegrees isNil.
	self assert: coord latitude isNil.
	self assert: coord longitudeInDegrees isNil.
	self assert: coord longitude isNil.
	
	coord latitudeInDegrees: 45.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: false.
	self assert: coord latitudeInDegrees equals: 45.
	self assert: coord latitudeInRadians equals: 0.7853981633974483.
	self assert: coord latitude equals: (45 units: #arcdegree).
	
	coord longitudeInDegrees: 90.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord longitudeInRadians equals: 1.5707963267948966.
	self assert: coord longitude equals: (90 units: #arcdegree).
	
	coord altitudeInMeters: 100.
	self assert: coord isEmpty equals: false.
	self assert: coord isValid equals: true.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesAsGeometryPoint [
	| coord |
	
	coord := AbsoluteCoordinates frBrest.
	self assert: coord asGeometryPoint equals: (GPoint x: -4.48333 y: 48.3897).
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesAsPoint [
	| coord |
	coord := AbsoluteCoordinates new.
	self assert: coord asPoint isNil.
	self assert: coord asLatLonRadiansPoint isNil.
	self assert: coord asLatLonDegreesPoint isNil.
	
	coord := AbsoluteCoordinates frBrest.
	self assert: coord asPoint equals: (48.3897@ -4.48333).
	self assert: coord asLatLonRadiansPoint equals: (0.8445595890523@ -0.07824886995343737).
	self assert: coord asLatLonDegreesPoint equals: (48.3897@ -4.48333).
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesConstructor [
	| coord |
	coord := AbsoluteCoordinates latitudeInDegrees: 16 longitudeInDegrees: 8.
	self assert: coord latitudeInDegrees equals: 16.
	self assert: coord longitudeInDegrees equals: 8.
	self assert: coord altitudeInMeters equals: nil.
	
	coord := AbsoluteCoordinates latitudeInDegrees: 16 longitudeInDegrees: 8 altitudeInMeters: 0.
	self assert: coord latitudeInDegrees equals: 16.
	self assert: coord longitudeInDegrees equals: 8.
	self assert: coord altitudeInMeters equals: 0.
	
	coord := AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.75.
	self assert: coord latitudeInRadians equals: 0.5.
	self assert: coord longitudeInRadians equals: 0.75.
	self assert: coord altitudeInMeters equals: nil.
	
	coord := AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.75 altitudeInMeters: 0.
	self assert: coord latitudeInRadians equals: 0.5.
	self assert: coord longitudeInRadians equals: 0.75.
	self assert: coord altitudeInMeters equals: 0.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesCopy [
	| coord copy |
	coord := AbsoluteCoordinates new.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
	
	coord := AbsoluteCoordinates zero.
	copy := coord copy.
	self assert: copy ~~ coord.
	self assert: copy equals: coord.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesEnums [
	| coord |
	coord := AbsoluteCoordinates frBrest.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.3897 longitudeInDegrees: -4.48333 altitudeInMeters: 52) equals: coord.
	
	coord := AbsoluteCoordinates frParis.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.8667 longitudeInDegrees: 2.33333 altitudeInMeters: 79) equals: coord.
	
	coord := AbsoluteCoordinates frBordeaux.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 44.8378 longitudeInDegrees: -0.594 altitudeInMeters: 22) equals: coord.
	
	coord := AbsoluteCoordinates frElancourt.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 48.7839 longitudeInDegrees: 1.95806 altitudeInMeters: 138) equals: coord.
	
	coord := AbsoluteCoordinates frLyon.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 45.7589 longitudeInDegrees: 4.84139 altitudeInMeters: 237) equals: coord.
	
	coord := AbsoluteCoordinates frMarseille.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 43.2967 longitudeInDegrees: 5.37639 altitudeInMeters: 320) equals: coord.
	
	coord := AbsoluteCoordinates frNevers.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 46.9925 longitudeInDegrees: 3.15667 altitudeInMeters: 203) equals: coord.
	
	coord := AbsoluteCoordinates ausSydney.
	self assert: (AbsoluteCoordinates latitudeInDegrees: -33.86785 longitudeInDegrees: 151.20732 altitudeInMeters: 58) equals: coord.
	
	coord := AbsoluteCoordinates usaNewYork.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 40.71427 longitudeInDegrees: -74.00597 altitudeInMeters: 57) equals: coord.
	
	coord := AbsoluteCoordinates usaLosAngeles.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 34.05223 longitudeInDegrees: -118.24368 altitudeInMeters: 96) equals: coord.
	
	coord := AbsoluteCoordinates usaSeattle.
	self assert: (AbsoluteCoordinates latitudeInDegrees: 47.60621 longitudeInDegrees: -122.33207 altitudeInMeters: 56) equals: coord.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesLimitations [
	| coord |
	coord := AbsoluteCoordinates latitudeInDegrees: 45 longitudeInDegrees: 90 altitudeInMeters: 100.
	
	coord latitudeInDegrees: 500.
	self assert: coord latitudeInDegrees equals: 90.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord altitudeInMeters equals: 100.
	coord latitudeInDegrees: -500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: 90.
	self assert: coord altitudeInMeters equals: 100.
	
	coord longitudeInDegrees: 500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: 140.
	self assert: coord altitudeInMeters equals: 100.
	coord longitudeInDegrees: -500.
	self assert: coord latitudeInDegrees equals: -90.
	self assert: coord longitudeInDegrees equals: -140.
	self assert: coord altitudeInMeters equals: 100.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAbsoluteCoordinatesRandom [
	| coord |
	coord := AbsoluteCoordinates random.
	self deny: coord isEmpty.
	self assert: coord isValid.
	self deny: coord latitudeInDegrees isNil.
	self deny: coord latitude isNil.
	self deny: coord longitudeInDegrees isNil.
	self deny: coord longitude isNil.
	
	"random not generate an altitude value"
	self assert: coord altitudeInMeters isNil.
	self assert: coord altitude isNil.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAltitude [

	self assert: absCoord altitude isNil.

	absCoord altitudeInMeters: 100.
	self assert: absCoord altitude equals: (100 units: #meters).

	absCoord altitudeInMeters: 0.
	self assert: absCoord altitude equals: (0 units: #meters).

	absCoord altitudeInMeters: -100.
	self assert: absCoord altitude equals: (-100 units: #meters).

	absCoord altitudeInMeters: nil.
	self assert: absCoord altitude isNil
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAltitudeInMeters [

	self assert: absCoord altitudeInMeters isNil.

	absCoord altitudeInMeters: 100.
	self assert: absCoord altitudeInMeters equals: 100.
	
	absCoord altitudeInMeters: 0.
	self assert: absCoord altitudeInMeters equals: 0.

	absCoord altitudeInMeters: -100.
	self assert: absCoord altitudeInMeters equals: -100.

	absCoord altitudeInMeters: nil.
	self assert: absCoord altitudeInMeters isNil
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAsLatLonDegreesPoint [

	| point |
	self assert: absCoord asLatLonDegreesPoint isNil.
	
	point := AbsoluteCoordinates frBrest asLatLonDegreesPoint.
	self assert: point equals: 48.3897 @ -4.48333
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAsLatLonRadiansPoint [

	| point |
	self assert: absCoord asLatLonRadiansPoint isNil.
	
	point := AbsoluteCoordinates frBrest asLatLonRadiansPoint.
	self assert: point equals: 0.8445595890523 @ -0.07824886995343737
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAsLonLatDegreesPoint [

	| point |
	self assert: absCoord asLonLatDegreesPoint isNil.
	
	point := AbsoluteCoordinates frBrest asLonLatDegreesPoint.
	self assert: point equals: -4.48333 @ 48.3897
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testAsLonLatRadiansPoint [

	| point |
	self assert: absCoord asLonLatRadiansPoint isNil.
	
	point := AbsoluteCoordinates frBrest asLonLatRadiansPoint.
	self assert: point equals: -0.07824886995343737 @ 0.8445595890523
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testDistanceBetweenKnownAbsoluteCoordinates [

	| pt1 pt2 dist az |
	pt1 := AbsoluteCoordinates frBrest.
	pt2 := AbsoluteCoordinates frStRenan.

	dist := GeodesicUtils distanceInMetersFrom: pt1 to: pt2.
	az := GeodesicUtils azimuthInRadiansFrom: pt1 to: pt2.
	az := az radiansToDegrees.
	self assert: (az - 295) abs < 5.
	self assert: (dist - 11500) abs < 1000
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testFromStringLatitudeLongitude [

	self assert: (AbsoluteCoordinates fromStringLatitude: nil longitude: nil) isNil.
	
	self assert: (AbsoluteCoordinates fromStringLatitude: '0' longitude: '0') equals: AbsoluteCoordinates zeroLatLon.

	self assert: (AbsoluteCoordinates fromStringLatitude: 'N0°0''0""' longitude: 'E0°0''0""') equals: AbsoluteCoordinates zeroLatLon.
	self assert: (AbsoluteCoordinates fromStringLatitude: 'N0°0''0''''' longitude: 'E0°0''0''''') equals: AbsoluteCoordinates zeroLatLon.
	
	self assert: (AbsoluteCoordinates fromStringLatitude: 'N0°02''0""' longitude: 'E0°0''0""') equals: (AbsoluteCoordinates latitudeInDegrees: 0.03333333333333333 longitudeInDegrees: 0).
	self assert: (AbsoluteCoordinates fromStringLatitude: 'S0°02''0''''' longitude: 'E0°0''0''''') equals: (AbsoluteCoordinates latitudeInDegrees: -0.03333333333333333 longitudeInDegrees: 0).
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testIsBelowSeaLevel [

	self deny: absCoord isBelowSeaLevel.

	absCoord altitudeInMeters: 100.
	self deny: absCoord isBelowSeaLevel.
	
	absCoord altitudeInMeters: 0.
	self deny: absCoord isBelowSeaLevel.

	absCoord altitudeInMeters: -100.
	self assert: absCoord isBelowSeaLevel.

	absCoord altitudeInMeters: nil.
	self deny: absCoord isBelowSeaLevel.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testIsLatLonZero [

	| coord |
	coord := AbsoluteCoordinates zeroLatLon.
	self assert: coord latitudeInDegrees equals: 0.
	self assert: coord longitudeInDegrees equals: 0.
	self assert: coord altitudeInMeters isNil.
	self assert: coord isLatLonZero.
	self assert: coord isZero.
	
	coord altitudeInMeters: 20.
	self assert: coord isLatLonZero.
	self deny: coord isZero.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testIsZero [

	| coord |
	coord := AbsoluteCoordinates zero.
	self assert: coord latitudeInDegrees equals: 0.
	self assert: coord longitudeInDegrees equals: 0.
	self assert: coord altitudeInMeters equals: 0.
	self assert: coord isLatLonZero.
	self assert: coord isZero.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testPrintAltitudeString [

	self
		assert: absCoord printAltitudeString
		equals: 'Not valid altitude'.
		
	self
		assert: AbsoluteCoordinates frBrest printAltitudeString
		equals: '52m'.
		
	self
		assert: AbsoluteCoordinates zero printAltitudeString
		equals: '0m'.
		
	self
		assert: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0) printAltitudeString
		equals: 'Not valid altitude'.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testPrintLatitudeString [

	self
		assert: absCoord printLatitudeString
		equals: 'Not valid latitude'.
		
	self
		assert: AbsoluteCoordinates frBrest printLatitudeString
		equals: '48°23''22"N'.
		
	self
		assert: AbsoluteCoordinates zero printLatitudeString
		equals: '00°00''00"N'.
		
	self
		assert: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0) printLatitudeString
		equals: '00°00''00"N'.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testPrintLongitudeString [

	self
		assert: absCoord printLongitudeString
		equals: 'Not valid longitude'.
		
	self
		assert: AbsoluteCoordinates frBrest printLongitudeString
		equals: '004°29''00"W'.
		
	self
		assert: AbsoluteCoordinates zero printLongitudeString
		equals: '000°00''00"E'.
		
	self
		assert: (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0) printLongitudeString
		equals: '000°00''00"E'.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testPrintOn [

	self
		assert: (String streamContents: [ :str | absCoord printOn: str ])
		equals: 'No valid coordinates'.
		
	self
		assert: (String streamContents: [ :str | AbsoluteCoordinates frBrest printOn: str ])
		equals: '48°23''22"N 004°29''00"W 52m'.
		
	self
		assert: (String streamContents: [ :str | AbsoluteCoordinates zero printOn: str ])
		equals: '00°00''00"N 000°00''00"E 0m'.
		
	self
		assert: (String streamContents: [ :str | (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0) printOn: str ])
		equals: '00°00''00"N 000°00''00"E'.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testRandom [

	| coordinates |
	coordinates := AbsoluteCoordinates random.
	self assert: coordinates isNotEmpty
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testReadLatitude [

	self assert: (AbsoluteCoordinates readLatitudeString: nil) isNil.
	
	self assert: (AbsoluteCoordinates readLatitudeString: 'N 0°0.0' ) equals: 0.0.

	self assert: (AbsoluteCoordinates readLatitudeString: 'N 1°0.0' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'S 1°0.0' ) equals: -1.0.
	
	self assert: (AbsoluteCoordinates readLatitudeString: 'N 1°0''0"' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'S 1°0''0"' ) equals: -1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'N1°0''0"' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'S1°0''0"' ) equals: -1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'N 1° 0'' 0" ' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'S 1°  0 '' 0 " ' ) equals: -1.0.
	self assert: (AbsoluteCoordinates readLatitudeString: 'N 49° 36.99') equals: 49.6165.
]

{ #category : #tests }
AbsoluteCoordinatesTest >> testReadLongitude [
	self assert: (AbsoluteCoordinates readLongitudeString: nil) isNil.
	
	self assert: (AbsoluteCoordinates readLongitudeString: 'E 0°0.0' ) equals: 0.0.

	self assert: (AbsoluteCoordinates readLongitudeString: 'E 1°0.0' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLongitudeString: 'W 1°0.0' ) equals: -1.0.
	
	self assert: (AbsoluteCoordinates readLongitudeString: 'E 1°0''0"' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLongitudeString: 'W 1°0''0"' ) equals: -1.0.
	
	self assert: (AbsoluteCoordinates readLongitudeString: 'E1°0''0"' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLongitudeString: 'W1°0''0"' ) equals: -1.0.
	self assert: (AbsoluteCoordinates readLongitudeString: 'E 1° 0'' 0" ' ) equals: 1.0.
	self assert: (AbsoluteCoordinates readLongitudeString: 'W 1°  0 '' 0 " ' ) equals: -1.0.
]
