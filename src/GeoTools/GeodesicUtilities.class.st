"
I am Geodetic calculus : 

• local to geodetic: cartesian to lat/lon conversion, that works with a planar approximation of the earth, but altitude is taken in account in the calculus 
• orthodromic to geodetic: cartesian to lat/lon conversion, that works with a elipsoidal WGS84 earth model, but altitude is NOT taken in account in the calculus 
• geocetric to geodetic: earth centered cartesian to lat/lon
"
Class {
	#name : #GeodesicUtilities,
	#superclass : #Object,
	#classInstVars : [
		'poleCurveRadius',
		'squaredExcentricity',
		'squaredReducedExcentricity'
	],
	#category : #'GeoTools-MapProjection'
}

{ #category : #tools }
GeodesicUtilities class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees [

	^ self
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distance: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInDegrees degreesToRadians
]

{ #category : #tools }
GeodesicUtilities class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	^ self
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInNM: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #tools }
GeodesicUtilities class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInNM: aDistanceInNM azimuthInRadians: anAzimuthInRadians [ 
	"Formule de transformation tirée du livre de traité de navigation, c'est pourquoi elle fonctionne avec des NM"
	| absoluteCoordinates deltaLat latArr div deltaLong longArr |

	deltaLat := anAzimuthInRadians cos * aDistanceInNM / 60.0.
	latArr := anAbsoluteCoordinates latitudeInDegrees  + deltaLat.
	
	div := ((latArr + anAbsoluteCoordinates latitudeInDegrees) degreesToRadians / 2.0) cos.
	deltaLong := ((div = 0)
		ifFalse:[(anAzimuthInRadians sin / (div) abs * aDistanceInNM / 60.0)] 
		ifTrue:[0]).

	longArr := anAbsoluteCoordinates longitudeInDegrees + deltaLong.	
		
	absoluteCoordinates := AbsoluteCoordinates latitudeInDegrees: latArr longitudeInDegrees: longArr.
	(absoluteCoordinates longitudeInDegrees < -360 or:[absoluteCoordinates longitudeInDegrees > 360]) ifTrue:[^AbsoluteCoordinates zero].
	(absoluteCoordinates latitudeInDegrees < -360 or:[absoluteCoordinates latitudeInDegrees > 360]) ifTrue:[^AbsoluteCoordinates zero].

	^ absoluteCoordinates
]

{ #category : #tools }
GeodesicUtilities class >> checkAngle: anAngleInRad isBetween: aStartValueInRad and: anEndValueInRad [ 
	"check if anAngleInRad is between startAngle and endAngle. Deal with the 0 :
	self checkAngle: 0 isBetween: 355 and: 5 => true
	while (0 between: 355 and: 5) => false  
	 "
	| end middle |
	
	(anAngleInRad closeTo: aStartValueInRad precision: 1e-7) ifTrue:[^true].
	
	end := anEndValueInRad - aStartValueInRad.
	end negative ifTrue:[ end := end + (2*Float pi)].

	middle := anAngleInRad - aStartValueInRad.
	middle negative ifTrue:[ middle := middle + (2*Float pi)].	
	
	^middle <= end
]

{ #category : #cleanup }
GeodesicUtilities class >> cleanUp [

	poleCurveRadius := nil.
	squaredExcentricity := nil.
	squaredReducedExcentricity := nil
]

{ #category : #private }
GeodesicUtilities class >> computeECEFXYZ: anOriginAbsoluteCoordinates fromLocalXYZ: aLocalCartesianCoordinates [

	| xor yor zor lon lat slon slat clon clat clonclat clonslat slonslat slonclat ECEFXYZOrigin |
	ECEFXYZOrigin := self computeECEFXYZFromLgLatAlt: anOriginAbsoluteCoordinates.
	
	xor := ECEFXYZOrigin xInMeters.
	yor := ECEFXYZOrigin yInMeters.
	zor := ECEFXYZOrigin zInMeters.
	
	lon := anOriginAbsoluteCoordinates longitudeInRadians.
	lat := anOriginAbsoluteCoordinates latitudeInRadians.
	
	slon := lon sin.
	clon := lon cos.
	slat := lat sin.
	clat := lat cos.
	
	clonclat := clon * clat.
	clonslat := clon * slat.
	slonclat := slon * clat.
	slonslat := slon * slat.
	
	^ CartesianCoordinates new
		xInMeters: xor + 
			(slon negated 		* aLocalCartesianCoordinates xInMeters) +
			(clonclat negated 	* aLocalCartesianCoordinates yInMeters) +
			(clonclat 			* aLocalCartesianCoordinates zInMeters)
		yInMeters: yor +
			(clon 			 		* aLocalCartesianCoordinates xInMeters) +
			(slonslat negated 	* aLocalCartesianCoordinates yInMeters) +
			(slonclat 			* aLocalCartesianCoordinates zInMeters)
		zInMeters: zor +
			(clat 			 		* aLocalCartesianCoordinates yInMeters) +
			(slat 				 	* aLocalCartesianCoordinates zInMeters)
]

{ #category : #private }
GeodesicUtilities class >> computeECEFXYZFromLgLatAlt: anAbsoluteCoordinates [

	| coslat coslat2 sinlat sinlon coslon h V N |
	
	coslat := anAbsoluteCoordinates latitudeInRadians cos.
	coslat2 := coslat * coslat.
	sinlat := anAbsoluteCoordinates latitudeInRadians sin.
	sinlon := anAbsoluteCoordinates longitudeInRadians sin.
	coslon := anAbsoluteCoordinates longitudeInRadians cos.
	h := anAbsoluteCoordinates altitudeInMeters.
	
	V := ((self squaredReducedExcentricity * coslat) + 1) sqrt.
	N := self poleCurveRadius / V.
	
	^ CartesianCoordinates 
		xInMeters: (N + h) * coslat * coslon
		yInMeters: (N + h) * coslat * sinlon
		zInMeters: ((N * (1 - self squaredExcentricity)) + h) * sinlat
]

{ #category : #private }
GeodesicUtilities class >> computeLgLatAltFromECEFXYZ: aCartesianCoordinates [

	| z x2 y2 d2 dh lat coslat V N absoluteCoordinates |
	
	absoluteCoordinates := AbsoluteCoordinates new.
	absoluteCoordinates longitudeInRadians: (aCartesianCoordinates yInMeters @ aCartesianCoordinates xInMeters) theta.
	
	z := aCartesianCoordinates zInMeters.
	x2 := aCartesianCoordinates xInMeters * aCartesianCoordinates xInMeters.
	y2 := aCartesianCoordinates yInMeters * aCartesianCoordinates yInMeters.
	d2 := x2 + y2.
	dh := d2 sqrt.
	
	1 to: 4 do: [ :i |
		lat := (z @ dh) theta.
		coslat := lat cos.
		V := ((self squaredReducedExcentricity * coslat * coslat) + 1) sqrt.
		N := self poleCurveRadius / V.
		z := aCartesianCoordinates zInMeters + (N * self squaredExcentricity * lat sin) ].
	
	absoluteCoordinates latitudeInRadians: (z @ dh) theta.
	absoluteCoordinates altitudeInMeters: (d2 + (z * z) - N) sqrt.	
	^ absoluteCoordinates
]

{ #category : #converting }
GeodesicUtilities class >> convertGeodesicToAzimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d13 d15 d16 d17 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 break |
	
	(startAbsoluteCoordinate longitudeInRadians closeTo: endAbsoluteCoordinate longitudeInRadians precision: 1e-7) ifTrue: 
		[ (startAbsoluteCoordinate latitudeInRadians closeTo: endAbsoluteCoordinate latitudeInRadians precision: 1e-7)
			ifTrue: [^ 0].
		endAbsoluteCoordinate latitudeInRadians >= startAbsoluteCoordinate latitudeInRadians 
			ifTrue: [^ 0]
			ifFalse: [^ Float pi]].
		
	d5 := ((startAbsoluteCoordinate latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d6 := ((endAbsoluteCoordinate latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d7 := d5 cos.
	d8 := d6 cos.
	d9 := d5 sin.
	d10 := d6 sin.
	d27 := WGS84 flattening / 16.
	d11 := endAbsoluteCoordinate longitudeInRadians - startAbsoluteCoordinate longitudeInRadians.
	d12 := d11.
	d13 := d11.
	d14 := d12 sin.
	d15 := d12 cos.
	d28 := 0.
	break := false.
	
	[ d28 < 4 and: [ break not ] ] whileTrue: 
		[ d16 := d8 * d14.
		d17 := (d7 * d10) - (d9 * d8 * d15).
		d20 := ((d16 * d16) + (d17 * d17)) sqrt.
		d21 := (d9 * d10) + (d7 * d8 * d15).
		" !!! Math.atan2(y,x) => (x,y) theta "
		d22 := (d21 @ d20) theta.
		d23 := (d7 * d8 * d14) / d20.
		d24 := 1 - (d23 * d23).
		d25 := d24 < 1e-14
			ifTrue: [ 0 ]
			ifFalse: [ d21 - ((2 * d9 * d10) / d24) ].
		d26 := d27 * d24 * (4 + (WGS84 flattening * (4 - (3 * d24)))).
		d19 := d12.
		d16 := d25 + (d26 * d21 * (-1 + (2 * d25 * d25))).
		d17 := (1 - d26) * WGS84 flattening * d23 * (d22 + (d26 * d20 * d16)).
		d12 := d13 + d17.
		d14 := d12 sin.
		d15 := d12 cos.
		break := (d12 - d19) abs < 1e-10.
		break ifFalse:[d28 := d28 + 1 ]
		].
	
	d28 := ( ((d7 * d10) - (d9 * d8 * d15)) @ (d8 * d14)) theta.
	^ d28 negative 
		ifTrue: [ d28 + (2 * Float pi) ]
		ifFalse: [ d28 ]
	
]

{ #category : #converting }
GeodesicUtilities class >> convertGeodesicToDistanceInMeterFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute distance between two Geodesic (lat/long) coordinates and return in meter"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30 d31 d32 xxx l |

	(startAbsoluteCoordinate longitudeInRadians closeTo: endAbsoluteCoordinate longitudeInRadians precision: 1e-7) ifTrue: 
		[ (startAbsoluteCoordinate latitudeInRadians closeTo: endAbsoluteCoordinate latitudeInRadians precision: 1e-7)
			ifTrue: [^ 0]
	].
	
	d5 := ((startAbsoluteCoordinate latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d6 := ((endAbsoluteCoordinate latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d7 := d5 cos.
	d8 := d6 cos.
	d9 := d5 sin.
	d10 := d6 sin.
	d28 := WGS84 flattening / 16.
	d11 := endAbsoluteCoordinate longitudeInRadians - startAbsoluteCoordinate longitudeInRadians.
	d12 := d11.
	d20 := 2 * d12.
	d14 := d12 sin.
	d15 := d12 cos.
	
	l := 1.
	xxx := 1.
	[(xxx >= 1e-10 and: [ l < 4 ])] whileTrue:
		[ xxx := (d12 - d20) abs.
		d16 := d8 * d14.
		d18 := (d7 * d10) - (d9 * d8 * d15).
		d21 := ((d16 * d16) + (d18 * d18)) sqrt.
		d22 := (d9 * d10) + (d7 * d8 * d15).
		" !!! Math.atan2(y,x) => (x,y) theta "
		d23 := (d22 @ d21) theta.
		d24 := (d7 * d8 * d14) / d21.
		d25 := 1 - (d24 * d24).
		d26 := d25 < 1e-14
			ifTrue: [ 0 ]
			ifFalse: [ d22 - ((2 * d9 * d10) / d25) ].
		d27 := d28 * d25 * (4 + (WGS84 flattening * (4 - (3 * d25)))).
		d20 := d12.
		d16 := d26 + (d27 * d22 * (-1 + (2 * d26 * d26))).
		d18 := (1 - d27) * WGS84 flattening * d24 * (d23 + (d27 * d21 * d16)).
		d12 := d11 + d18.
		d14 := d12 sin.
		d15 := d12 cos.
		l := l + 1. ].
	
	d29 := d25 * WGS84 eminorSquare.
	d30 := 1 + ((d29 / 16384) * (4096 + (d29 * (-768 + (d29 * (320 - (175 * d29))))))).
	d31 := (d29 / 1024) * (256 + (d29 * (-128 + (d29 * (74 - (47 * d29)))))).
	d17 := d22 * (-1 + (2 * (d26 * d26))).
	d19 := d26 * (-3 + (4 * d21 * d21)) * (-3 + (4 * d26 * d26)).
	d32 := d31 * d21 * (d26 + ((d31 / 4) * (d17 - ((d31 / 6) * d19)))).
	^ WGS84 semiMinorAxisInMeters * d30 * (d23 - d32)
]

{ #category : #tools }
GeodesicUtilities class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuth: anAzimuthInDegree area: aListOfAbsoluteCoords [

	^ self
		  isAzimuthTowardsAreaFrom: anAbsCoordOrigin
		  azimuthInRadians: anAzimuthInDegree degreesToRadians
		  area: aListOfAbsoluteCoords
]

{ #category : #tools }
GeodesicUtilities class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuthInRadians: anAzimuthInRadians area: aListOfAbsoluteCoords [

	| listAngles isPointingArea azRad |
	isPointingArea := false.

	aListOfAbsoluteCoords isEmptyOrNil ifTrue: [ ^ isPointingArea ].

	"Compute angles between origin position and vertices of area"
	listAngles := (aListOfAbsoluteCoords collect: [ :absCoord |
		               self convertGeodesicToAzimuthInRadiansFrom: anAbsCoordOrigin to: absCoord ]) asOrderedCollection.
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
				ifTrue: [ isPointingArea or: [ self checkAngle: azRad isBetween: a and: nextAngle ] ]
				ifFalse: [ isPointingArea or: [ self checkAngle: azRad isBetween: nextAngle and: a  ] 
			].
			isPointingArea := isPointingArea or: [ azRad closeTo: nextAngle precision: 1e-3 ] 
		] 
	].

	^ isPointingArea
]

{ #category : #tools }
GeodesicUtilities class >> localPolar: aPolarCoordinates toGeodesicFrom: anOriginAbsoluteCoordinates [
	"Compute the geodesic position of a specified line end, knowing its azimuth, elevation, length and start geodesic position. Warning: that method doesn't take in account the earth curve as orthodromic2geodesic does.
 But that method takes in account the altitude in the calculus."
	"Return an AbsoluteCoordinates"

	| cartesianCoordinates geocentric |
	cartesianCoordinates := aPolarCoordinates asCartesianCoordinates.
	geocentric := self computeECEFXYZ: anOriginAbsoluteCoordinates fromLocalXYZ: cartesianCoordinates.
	^ self computeLgLatAltFromECEFXYZ: geocentric.
	
]

{ #category : #constants }
GeodesicUtilities class >> poleCurveRadius [

	poleCurveRadius ifNil: [
		poleCurveRadius := WGS84 semiMajorAxisInMeters
		                   * WGS84 semiMajorAxisInMeters
		                   / WGS84 semiMinorAxisInMeters ].

	^ poleCurveRadius
]

{ #category : #converting }
GeodesicUtilities class >> preciseConvertGeodesicToAzimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d13 d15 d16 d17 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 break |
	
	d5 := (startAbsoluteCoordinate latitudeInRadians tan
	       * WGS84 semiMinorAxisInMeters / WGS84 semiMajorAxisInMeters)
		      arcTan.
	d6 := (endAbsoluteCoordinate latitudeInRadians tan
	       * WGS84 semiMinorAxisInMeters / WGS84 semiMajorAxisInMeters)
		      arcTan.
	d7 := d5 cos.
	d8 := d6 cos.
	d9 := d5 sin.
	d10 := d6 sin.
	d27 := WGS84 flattening / 16.
	d11 := endAbsoluteCoordinate longitudeInRadians
	       - startAbsoluteCoordinate longitudeInRadians.
	d12 := d11.
	d13 := d11.
	d14 := d12 sin.
	d15 := d12 cos.
	d28 := 0.
	break := false.

	[ d28 < 4 and: [ break not ] ] whileTrue: [
		d16 := d8 * d14.
		d17 := d7 * d10 - (d9 * d8 * d15).
		d20 := (d16 * d16 + (d17 * d17)) sqrt.
		d21 := d9 * d10 + (d7 * d8 * d15).
		" !!! Math.atan2(y,x) => (x,y) theta "
		d22 := (d21 @ d20) theta.
		d20 = 0 ifTrue: [ ^0 ].
		d23 := d7 * d8 * d14 / d20.
		d24 := 1 - (d23 * d23).
		d25 := d24 < 1e-14
			       ifTrue: [ 0 ]
			       ifFalse: [ d21 - (2 * d9 * d10 / d24) ].
		d26 := d27 * d24 * (4 + (WGS84 flattening * (4 - (3 * d24)))).
		d19 := d12.
		d16 := d25 + (d26 * d21 * (-1 + (2 * d25 * d25))).
		d17 := 1 - d26 * WGS84 flattening * d23 * (d22 + (d26 * d20 * d16)).
		d12 := d13 + d17.
		d14 := d12 sin.
		d15 := d12 cos.
		break := (d12 - d19) abs < 1e-10.
		break ifFalse: [ d28 := d28 + 1 ] ].

	d28 := (d7 * d10 - (d9 * d8 * d15) @ (d8 * d14)) theta.
	^ d28 negative
		  ifTrue: [ d28 + (2 * Float pi) ]
		  ifFalse: [ d28 ]
]

{ #category : #tools }
GeodesicUtilities class >> projectedRadiusInMCenter: anAbsoluteCoordinates radius: aDistanceInM azimuth: anAzimuthInDegrees projection: aMapProjection [

	| cartesianCoordinates1 extPt cartesianCoordinates2 radiusInM |
	
	cartesianCoordinates1 := aMapProjection projLatLonToCart: anAbsoluteCoordinates.
	extPt := self absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees.
	cartesianCoordinates2 := aMapProjection projLatLonToCart: extPt.

	radiusInM := (cartesianCoordinates1 asPoint - cartesianCoordinates2 asPoint) r abs.
	^ radiusInM
]

{ #category : #constants }
GeodesicUtilities class >> squaredExcentricity [

	squaredExcentricity ifNil: [
		squaredExcentricity := WGS84 semiMajorAxisInMeters
		                       * WGS84 semiMajorAxisInMeters
		                       -
		                       (WGS84 semiMinorAxisInMeters
		                        * WGS84 semiMinorAxisInMeters)
		                       /
		                       (WGS84 semiMajorAxisInMeters
		                        * WGS84 semiMajorAxisInMeters) ].

	^ squaredExcentricity
]

{ #category : #constants }
GeodesicUtilities class >> squaredReducedExcentricity [

	squaredReducedExcentricity ifNil: [
		squaredReducedExcentricity := WGS84 semiMajorAxisInMeters
		                              * WGS84 semiMajorAxisInMeters
		                              -
		                              (WGS84 semiMinorAxisInMeters
		                               * WGS84 semiMinorAxisInMeters)
		                              /
		                              (WGS84 semiMinorAxisInMeters
		                               * WGS84 semiMinorAxisInMeters) ].

	^ squaredReducedExcentricity
]
