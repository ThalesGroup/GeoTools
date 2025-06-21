"
I am Geodetic calculus : 

• local to geodetic: cartesian to lat/lon conversion, that works with a planar approximation of the earth, but altitude is taken in account in the calculus 
• orthodromic to geodetic: cartesian to lat/lon conversion, that works with a elipsoidal WGS84 earth model, but altitude is NOT taken in account in the calculus 
• geocetric to geodetic: earth centered cartesian to lat/lon
"
Class {
	#name : #GeodesicUtils,
	#superclass : #Object,
	#category : #'GeoTools-Geodesic'
}

{ #category : #tools }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees [

	self
		deprecated: 'Deprecated method name'
		transformWith: '`@rcv absoluteCoordinatesFrom: @anAbsoluteCoordinates distance: @aDistanceInM azimuth: @anAzimuthInDegrees'
			-> '`@rcv approximateAbsoluteCoordinatesFrom: @anAbsoluteCoordinates distance: @aDistanceInM azimuth: @anAzimuthInDegrees'.

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distance: aDistanceInM
		  azimuth: anAzimuthInDegrees
]

{ #category : #tools }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	self
		deprecated: 'Deprecated method name'
		transformWith: '`@rcv absoluteCoordinatesFrom: @anAbsoluteCoordinates distance: @aDistanceInM azimuthInRadians: @anAzimuthInRadians'
			-> '`@rcv approximateAbsoluteCoordinatesFrom: @anAbsoluteCoordinates distance: @aDistanceInM azimuthInRadians: @anAzimuthInRadians'.

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distance: aDistanceInM
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #tools }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInM: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	"default using Vincenty"
	^ self absoluteCoordinatesWithVincentyFrom: anAbsoluteCoordinates distanceInM: aDistanceInM azimuthInRadians: anAzimuthInRadians
]

{ #category : #tools }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInNM: aDistanceInNM azimuthInRadians: anAzimuthInRadians [

	self
		deprecated: 'Deprecated method name'
		transformWith: '`@rcv absoluteCoordinatesFrom: @anAbsoluteCoordinates distanceInNM: @aDistanceInNM azimuthInRadians:: @anAzimuthInRadians'
			-> '`@rcv approximateAbsoluteCoordinatesFrom: @anAbsoluteCoordinates distanceInNM: @aDistanceInNM azimuthInRadians: @anAzimuthInRadians'.

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInNM: aDistanceInNM
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #'private - calculating' }
GeodesicUtils class >> absoluteCoordinatesWithVincentyFrom: anAbsoluteCoordinates distanceInM: distance azimuthInRadians: azimuth [
	"https://en.wikipedia.org/wiki/Vincenty%27s_formulae"

    | a f b lat1 lon1 alpha1 sinAlpha1 cosAlpha1 u1 sinU1 cosU1 sigma1 sinα cosSqAlpha uSq A B σ σPrev iterLimit cosσ sinσ lat2 Δσ C L lon2 lambda cos2σm tmp |
	 a := WGS84 semiMajorAxisInMeters.
    f := WGS84 flattening.
    b := a * (1 - f).
 
    lat1 := anAbsoluteCoordinates latitudeInRadians.
    lon1 := anAbsoluteCoordinates longitudeInRadians.
	 alpha1 := azimuth.
    sinAlpha1 := alpha1 sin. 
    cosAlpha1 := alpha1 cos. 

	 u1 := ((1 - f) * ((lat1) tan)) arcTan.
    sinU1 := u1 sin.
    cosU1 := u1 cos.

	 sigma1 := sinU1 arcTan: (cosU1 * cosAlpha1). 
    sinα := cosU1 * sinAlpha1.
    cosSqAlpha := 1 - (sinα squared).

	 uSq := (cosSqAlpha * ((a squared) - (b squared))) / (b squared).
    A := 1 + ((uSq / 16384) * (4096 + (uSq * (-768 + (uSq * (320 - (175 * uSq))))))).
    B := (uSq / 1024) * (256 + (uSq * (-128 + (uSq * (74 - (47 * uSq)))))).

	 σ := distance / (b * A).
    σPrev := 0.0.
    iterLimit := 100.

	"Itération pour converger sur σ"
	[ (σ - σPrev) abs > 1e-12 and: [ iterLimit > 0 ] ] whileTrue: [
		cos2σm := ((2 * sigma1) + σ) cos.
      sinσ := σ sin.
      cosσ := σ cos.
	
		Δσ := (B * sinσ) * (
    		(cos2σm) + (((B) / 4) * (
        		((cosσ) * (-1 + (2 * ((cos2σm) squared)))) -
        		((((B) / 6) * (cos2σm)) * (-3 + (4 * ((sinσ) squared))) * (-3 + (4 * ((cos2σm) squared))))
   			))
		).
 
		σPrev := σ.
      σ := (distance / (b * A)) + Δσ.
      iterLimit := iterLimit - 1.
	].

	tmp := (sinU1 * sinσ) - (cosU1 * cosσ * cosAlpha1).
	lat2 := ((sinU1 * cosσ) + (cosU1 * sinσ * cosAlpha1)) arcTan: ((1 - f) * ((sinAlpha1 squared) + (tmp * tmp)) sqrt).
	lambda := (sinσ * sinAlpha1) arcTan: ((cosU1 * cosσ) - (sinU1 * sinσ * cosAlpha1)).
	C := (f / 16) * cosSqAlpha * (4 + (f * (4 - (3 * cosSqAlpha)))).
	L := lambda - ((1 - C) * f * sinAlpha1 * (σ + (C * sinσ * (cos2σm + (C * cosσ * (-1 + (2 * (cos2σm squared)))))))).
	lon2 := (((lon1 + L + (3 * Float pi)) \\ (2 * Float pi)) - Float pi).

    ^ AbsoluteCoordinates latitudeInRadians: lat2 longitudeInRadians: lon2
]

{ #category : #'tools - approximation' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees [

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distance: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInDegrees degreesToRadians
]

{ #category : #'tools - approximation' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInNM: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #'tools - approximation' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distanceInM: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	"Approximates a geographic position (latitude, longitude) from a starting point, a distance (in meters), and an azimuth (in radians), assuming a spherical Earth with radius equal to the WGS84 semi-major axis."

	| r δ φ1 λ1 φ2 λ2 x y |
	anAbsoluteCoordinates isValid ifFalse:[ ^ nil ].
	
	r := WGS84 semiMajorAxisInMeters.
	δ := aDistanceInM / r.

	φ1 := anAbsoluteCoordinates latitudeInRadians.
	λ1 := anAbsoluteCoordinates longitudeInRadians.

	φ2 := (φ1 sin * δ cos + (φ1 cos * δ sin * anAzimuthInRadians cos)) arcSin.
	φ2 := (φ2 max: (Float halfPi negated)) min: Float halfPi.

	x := δ cos - (φ1 sin * φ2 sin).
	y := anAzimuthInRadians sin * δ * φ1 cos.

	λ2 := λ1 + (y arcTan: x).
	λ2 := ((λ2 + Float pi) \\ (2 * Float pi)) - Float pi.

	^ AbsoluteCoordinates
		  latitudeInDegrees: φ2 radiansToDegrees
		  longitudeInDegrees: λ2 radiansToDegrees
		  altitudeInMeters: anAbsoluteCoordinates altitudeInMeters
]

{ #category : #'tools - approximation' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distanceInNM: aDistanceInNM azimuthInRadians: anAzimuthInRadians [ 
	"Formule de transformation tirée du livre de traité de navigation, c'est pourquoi elle fonctionne avec des NM"
	| absoluteCoordinates deltaLat latArr div deltaLong longArr |

	anAbsoluteCoordinates isValid ifFalse:[ ^ nil ].
	
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

{ #category : #'tools - approximation' }
GeodesicUtils class >> approximateProjectedRadiusInMCenter: anAbsoluteCoordinates radius: aDistanceInM azimuth: anAzimuthInDegrees projection: aMapProjection [
	"Estimates the radius in projected meters by projecting two geographic points—one at the center and one at a given distance and azimuth—into Cartesian coordinates, then measuring their planar distance."

	| cartesianCoordinates1 extPt cartesianCoordinates2 radiusInM |
	
	cartesianCoordinates1 := aMapProjection projLatLonToCart: anAbsoluteCoordinates.
	extPt := self approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees.
	cartesianCoordinates2 := aMapProjection projLatLonToCart: extPt.

	radiusInM := (cartesianCoordinates1 asPoint - cartesianCoordinates2 asPoint) r abs.
	^ radiusInM
]

{ #category : #calculating }
GeodesicUtils class >> azimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	^ self
		  azimuthInRadiansWithVincentyFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #'private - calculating' }
GeodesicUtils class >> azimuthInRadiansWithVincentyFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d13 d15 d16 d17 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 break |
	
	(startAbsoluteCoordinate isValid not or:[endAbsoluteCoordinate isValid not]) ifTrue:[ ^ 0 ].
	
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

{ #category : #'private - calculating' }
GeodesicUtils class >> azimuthInRadiansWithVincentyPreciseFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d13 d15 d16 d17 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 break |
	
	(startAbsoluteCoordinate isValid not or:[endAbsoluteCoordinate isValid not]) ifTrue:[ ^ 0 ].
	
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
GeodesicUtils class >> checkAngle: anAngleInRadians isBetween: aStartAngleInRadians and: anEndAngleInRadians [
	"check if anAngleInRad is between startAngle and endAngle. Deal with the 0 :
	self checkAngle: 0 isBetween: 355 and: 5 => true
	while (0 between: 355 and: 5) => false"

	self deprecated:'Use directly Number extension'.

	^ anAngleInRadians
		  isAngleInRadiansBetween: aStartAngleInRadians
		  and: anEndAngleInRadians
]

{ #category : #private }
GeodesicUtils class >> computeECEFXYZ: anOriginAbsoluteCoordinates fromLocalXYZ: aLocalCartesianCoordinates [

	self deprecated:'use directly absolute coordinates converting'.

	^ anOriginAbsoluteCoordinates localToECEFCartesianCoordinates:
		  aLocalCartesianCoordinates
]

{ #category : #private }
GeodesicUtils class >> computeECEFXYZFromLgLatAlt: anAbsoluteCoordinates [

	self deprecated:'use directly absolute coordinates converting'.

	^ anAbsoluteCoordinates asECEFCartesianCoordinates 
]

{ #category : #private }
GeodesicUtils class >> computeLgLatAltFromECEFXYZ: aCartesianCoordinates [

	self deprecated:'use directly cartesian coordinates converting'.

	^ aCartesianCoordinates asECEFtoAbsoluteCoordinates
]

{ #category : #calculating }
GeodesicUtils class >> convertGeodesicToAzimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	self
		deprecated: 'Deprecated method name'
		transformWith:
			'`@rcv convertGeodesicToAzimuthInRadiansFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'
			->
			'`@rcv azimuthInRadiansFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'.

	^ self
		  azimuthInRadiansFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #calculating }
GeodesicUtils class >> convertGeodesicToDistanceInMeterFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Vincenty algorithm to compute distance between two Geodesic (lat/long) coordinates and return it in meter"

	self
		deprecated: 'Deprecated method name'
		transformWith:
			'`@rcv convertGeodesicToDistanceInMeterFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'
			->
			'`@rcv distanceInMetersFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'.

	^ self
		  distanceInMetersFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #'private - calculating' }
GeodesicUtils class >> distanceInMeterWithVincentyFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate maxIterations: anIterationQuantity [
	"Vincenty algorithm to compute distance between two Geodesic (lat/long) coordinates and return it in meter"
	"https://en.wikipedia.org/wiki/Vincenty%27s_formulae"

	| u1 u2 cosU1 cosU2 sinU1 sinU2 diffLong lambda sinLambda cosLambda d16 d17 d18 d19 lambdaP sinSigma cosSigma sigma cosSqAlpha cos2SigmaM d27 d28 d29 d30 d31 d32 l sinAlpha |

	(startAbsoluteCoordinate isValid not or:[endAbsoluteCoordinate isValid not]) ifTrue:[ ^ 0 ].

	(startAbsoluteCoordinate longitudeInRadians closeTo: endAbsoluteCoordinate longitudeInRadians precision: 1e-7) ifTrue: 
		[ (startAbsoluteCoordinate latitudeInRadians closeTo: endAbsoluteCoordinate latitudeInRadians precision: 1e-7)
			ifTrue: [ ^ 0 ]
	].
	 
	u1 := ((1 - WGS84 flattening) * (startAbsoluteCoordinate latitudeInRadians tan)) arcTan.
	u2 := ((1 - WGS84 flattening) * (endAbsoluteCoordinate latitudeInRadians tan)) arcTan.
	cosU1 := u1 cos.
	cosU2 := u2 cos.
	sinU1 := u1 sin.
	sinU2 := u2 sin.
	d28 := WGS84 flattening / 16.
	diffLong := endAbsoluteCoordinate longitudeInRadians - startAbsoluteCoordinate longitudeInRadians.
	lambda := diffLong.
	"d20 := 2 * d12."
	lambdaP := 0.0.
	
	l := 1.
	[((lambda - lambdaP) abs >= 1e-12 and: [ l < (anIterationQuantity ifNil:[ 100 ]) ])] whileTrue: [ 
		lambdaP := lambda.
		sinLambda := lambda sin.
		cosLambda := lambda cos.
		d16 := cosU2 * sinLambda.
		d18 := (cosU1 * sinU2) - (sinU1 * cosU2 * cosLambda).
		sinSigma := ((d16 * d16) + (d18 * d18)) sqrt.
		sinSigma = 0 ifTrue: [ ^ 0 ].
		cosSigma := (sinU1 * sinU2) + (cosU1 * cosU2 * cosLambda).
		sigma := sinSigma arcTan: cosSigma. "ok equivalent to (sinSigma @ cosSigma) theta."
		sinAlpha := (cosU1 * cosU2 * sinLambda) / sinSigma.
		cosSqAlpha := 1 - (sinAlpha squared).
		cos2SigmaM := cosSqAlpha < 1e-14
			ifTrue: [ 0 ]
			ifFalse: [ cosSigma - ((2 * sinU1 * sinU2) / cosSqAlpha) ].
		d27 := d28 * cosSqAlpha * (4 + (WGS84 flattening * (4 - (3 * cosSqAlpha)))).
		d16 := cos2SigmaM + (d27 * cosSigma * (-1 + (2 * cos2SigmaM * cos2SigmaM))).
		"d18 := (1 - d27) * WGS84 flattening * cosSqAlpha * (sigma + (d27 * sinSigma * d16))."
		d18 := (1 - d27) * WGS84 flattening * sinAlpha * (sigma + (d27 * sinSigma * d16)).
		lambda := diffLong + d18.
		sinLambda := lambda sin.
		cosLambda := lambda cos.
		l := l + 1. 
	].
	
	d29 := cosSqAlpha * WGS84 eccentricitySquared.
	d30 := 1 + ((d29 / 16384) * (4096 + (d29 * (-768 + (d29 * (320 - (175 * d29))))))).
	d31 := (d29 / 1024) * (256 + (d29 * (-128 + (d29 * (74 - (47 * d29)))))).
	d17 := cosSigma * (-1 + (2 * (cos2SigmaM * cos2SigmaM))).
	d19 := cos2SigmaM * (-3 + (4 * sinSigma * sinSigma)) * (-3 + (4 * cos2SigmaM * cos2SigmaM)).
	d32 := d31 * sinSigma * (cos2SigmaM + ((d31 / 4) * (d17 - ((d31 / 6) * d19)))).
	
	^ WGS84 semiMinorAxisInMeters * d30 * (sigma - d32)
]

{ #category : #calculating }
GeodesicUtils class >> distanceInMetersFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [

	^ self
		  distanceInMeterWithVincentyFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
		  maxIterations: 100
]

{ #category : #'tools - zones' }
GeodesicUtils class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuth: anAzimuthInDegree area: aListOfAbsoluteCoords [

	^ self
		  isAzimuthTowardsAreaFrom: anAbsCoordOrigin
		  azimuthInRadians: anAzimuthInDegree degreesToRadians
		  area: aListOfAbsoluteCoords
]

{ #category : #'tools - zones' }
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

{ #category : #'tools - approximation' }
GeodesicUtils class >> localPolar: aPolarCoordinates toGeodesicFrom: anOriginAbsoluteCoordinates [
	"Compute the geodesic position of a specified line end, knowing its azimuth, elevation, length and start geodesic position. Warning: that method doesn't take in account the earth curve as orthodromic2geodesic does.
 But that method takes in account the altitude in the calculus."

	self deprecated:'Use polar coordinates converting'.

	^ aPolarCoordinates localToAbsoluteCoordinates:
		  anOriginAbsoluteCoordinates
]

{ #category : #'private - calculating' }
GeodesicUtils class >> preciseConvertGeodesicToAzimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	self
		deprecated: 'Deprecated method name'
		transformWith:
			'`@rcv preciseConvertGeodesicToAzimuthInRadiansFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'
			->
			'`@rcv azimuthInRadiansWithVincentyPreciseFrom: @startAbsoluteCoordinate to: @endAbsoluteCoordinate'.

	^ self azimuthInRadiansWithVincentyPreciseFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate
]

{ #category : #'tools - approximation' }
GeodesicUtils class >> projectedRadiusInMCenter: anAbsoluteCoordinates radius: aDistanceInM azimuth: anAzimuthInDegrees projection: aMapProjection [
	
	self
		deprecated: 'Deprecated method name'
		transformWith: '`@rcv projectedRadiusInMCenter: @anAbsoluteCoordinates radius: @aDistanceInM azimuth: @anAzimuthInDegrees projection: @aMapProjection'
			-> '`@rcv approximateProjectedRadiusInMCenter: @anAbsoluteCoordinates radius: @aDistanceInM azimuth: @anAzimuthInDegrees projection: @aMapProjection'.

	^ self
		  approximateProjectedRadiusInMCenter: anAbsoluteCoordinates
		  radius: aDistanceInM
		  azimuth: anAzimuthInDegrees
		  projection: aMapProjection
]

{ #category : #'see class side' }
GeodesicUtils >> seeClassSide [ 
]
