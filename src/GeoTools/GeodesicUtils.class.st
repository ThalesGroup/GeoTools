"
GeodesicUtils provide some tools to compute geodesics easily. 
Please use this class ponctually, if you need several/chained processing reuse an instance of GeodesicFormulas.
"
Class {
	#name : #GeodesicUtils,
	#superclass : #Object,
	#category : #'GeoTools-Geodesic'
}

{ #category : #utilities }
GeodesicUtils class >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [
	"Return a point at fraction t (0 <= t <= 1) along the geodesic from 'from' to 'to'.
	Uses Vincenty inverse to get initial azimuth and distance, then Vincenty direct."

	^ GeodesicVincentyFormulas new absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction
]

{ #category : #'to remove as soon as possible' }
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

{ #category : #'to remove as soon as possible' }
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

{ #category : #utilities }
GeodesicUtils class >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	"default using Vincenty"

	^ GeodesicVincentyFormulas new
		  absoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInMeters: aDistanceInM
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #'to remove as soon as possible' }
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

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> absoluteCoordinatesWithVincentyFrom: anAbsoluteCoordinates distanceInM: distance azimuthInRadians: azimuth [
    | a f b lat1 lon1 alpha1 sinAlpha1 cosAlpha1 u1 sinU1 cosU1 sigma1 sinAlpha cosSqAlpha uSq A B sigma sigmaPrev iterLimit cosSigma sinSigma lat2 deltaSigma C L lon2 lambda cos2SigmaM tmp |

    anAbsoluteCoordinates isValid ifFalse: [ ^ nil ].
    distance = 0 ifTrue: [ ^ anAbsoluteCoordinates copy ].

    a := WGS84 semiMajorAxisInMeters.
    f := WGS84 flattening.
    b := a * (1 - f).

    lat1 := anAbsoluteCoordinates latitudeInRadians.
    lon1 := anAbsoluteCoordinates longitudeInRadians.
    alpha1 := azimuth.
    sinAlpha1 := alpha1 sin.
    cosAlpha1 := alpha1 cos.

    "Calcul latitude réduite U1"
    u1 := ((1 - f) * (lat1 tan)) arcTan.
    sinU1 := u1 sin.
    cosU1 := u1 cos.

    Transcript
        show: 'u1 (rad): ', u1 printString; cr;
        show: 'sinU1: ', sinU1 printString; cr;
        show: 'cosU1: ', cosU1 printString; cr.

    "sigma1"
    sigma1 := ((u1 tan) / cosAlpha1) arcTan.  "arcTan au lieu de arcTan2"
    Transcript
        show: 'sigma1 (rad): ', sigma1 printString; cr.

    sinAlpha := cosU1 * sinAlpha1.
    cosSqAlpha := 1 - (sinAlpha squared).

    uSq := (cosSqAlpha * ((a squared) - (b squared))) / (b squared).
    A := 1 + ((uSq / 16384) * (4096 + (uSq * (-768 + (uSq * (320 - (175 * uSq))))))).
    B := (uSq / 1024) * (256 + (uSq * (-128 + (uSq * (74 - (47 * uSq)))))).

    sigma := distance / (b * A).
    sigmaPrev := 0.0.
    iterLimit := 100.

    [ ((sigma - sigmaPrev) abs > 1e-12) and: [ iterLimit > 0 ] ] whileTrue: [
        cos2SigmaM := ((2 * sigma1) + sigma) cos.
        sinSigma := sigma sin.
        cosSigma := sigma cos.

        deltaSigma := (B * sinSigma) * (
            (cos2SigmaM) + (((B) / 4) * (
                ((cosSigma) * (-1 + (2 * ((cos2SigmaM) squared)))) -
                ((((B) / 6) * (cos2SigmaM)) * (-3 + (4 * ((sinSigma) squared))) * (-3 + (4 * ((cos2SigmaM) squared))))
            ))
        ).

        sigmaPrev := sigma.
        sigma := (distance / (b * A)) + deltaSigma.
        iterLimit := iterLimit - 1.

        Transcript
            show: 'sigma: ', sigma printString; cr.
    ].

    tmp := ((sinU1 * sinSigma) - (cosU1 * cosSigma * cosAlpha1)).
    lat2 := ((sinU1 * cosSigma) + (cosU1 * sinSigma * cosAlpha1)) arcTan2: ((1 - f) * (((sinAlpha squared) + (tmp * tmp)) sqrt)).
    lambda := (sinSigma * sinAlpha1) arcTan2: ((cosU1 * cosSigma) - (sinU1 * sinSigma * cosAlpha1)).
    C := ((f / 16) * cosSqAlpha * (4 + (f * (4 - (3 * cosSqAlpha))))).
    L := lambda - ((1 - C) * f * sinAlpha1 * (sigma + (C * sinSigma * (cos2SigmaM + (C * cosSigma * (-1 + (2 * ((cos2SigmaM) squared)))))))).
    lon2 := (((lon1 + L + (3 * Float pi)) euclideanModulo: (2 * Float pi)) - Float pi).

    Transcript
        show: 'lat2 (rad): ', lat2 printString; cr;
        show: 'lon2 (rad): ', lon2 printString; cr.

    ^ AbsoluteCoordinates latitudeInRadians: lat2 longitudeInRadians: lon2


]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees [

	self deprecated:'use formulas'.

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distance: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInDegrees degreesToRadians
]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuthInRadians: anAzimuthInRadians [

	self deprecated:'use formulas'.

	^ self
		  approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates
		  distanceInNM: (aDistanceInM / 1000 / 1.852)
		  azimuthInRadians: anAzimuthInRadians
]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distanceInM: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	"Approximates a geographic position (latitude, longitude) from a starting point, a distance (in meters), and an azimuth (in radians), assuming a spherical Earth with radius equal to the WGS84 semi-major axis."

	| r δ φ1 λ1 φ2 λ2 x y |

	self deprecated:'use formulas'.
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

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distanceInNM: aDistanceInNM azimuthInRadians: anAzimuthInRadians [ 
	"Formule de transformation tirée du livre de traité de navigation, c'est pourquoi elle fonctionne avec des NM"
	| absoluteCoordinates deltaLat latArr div deltaLong longArr |

	self deprecated:'use formulas'.
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

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> approximateProjectedRadiusInMCenter: anAbsoluteCoordinates radius: aDistanceInM azimuth: anAzimuthInDegrees projection: aMapProjection [
	"Estimates the radius in projected meters by projecting two geographic points—one at the center and one at a given distance and azimuth—into Cartesian coordinates, then measuring their planar distance."

	| cartesianCoordinates1 extPt cartesianCoordinates2 radiusInM |
	self deprecated:'transfered into GeoView project => GeoViewProjectionUtils projectedCartesianRadiusFromCenter: anAbsoluteCoordinates radiusInMeters: aDistanceInM azimuthInDegrees: anAzimuthInDegrees projection: aMapProjection'.
	cartesianCoordinates1 := aMapProjection projLatLonToCart: anAbsoluteCoordinates.
	extPt := self approximateAbsoluteCoordinatesFrom: anAbsoluteCoordinates distance: aDistanceInM azimuth: anAzimuthInDegrees.
	cartesianCoordinates2 := aMapProjection projLatLonToCart: extPt.

	radiusInM := (cartesianCoordinates1 asPoint - cartesianCoordinates2 asPoint) r abs.
	^ radiusInM
]

{ #category : #utilities }
GeodesicUtils class >> azimuthInRadiansFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [

	^ GeodesicVincentyFormulas new
		  azimuthInRadiansFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #'to remove as soon as possible' }
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

	[ d28 < 100 and: [ break not ] ] whileTrue: [
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

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> checkAngle: anAngleInRadians isBetween: aStartAngleInRadians and: anEndAngleInRadians [
	"check if anAngleInRad is between startAngle and endAngle. Deal with the 0 :
	self checkAngle: 0 isBetween: 355 and: 5 => true
	while (0 between: 355 and: 5) => false"

	self deprecated:'Use directly Number extension'.

	^ anAngleInRadians
		  isAngleInRadiansBetween: aStartAngleInRadians
		  and: anEndAngleInRadians
]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> computeECEFXYZ: anOriginAbsoluteCoordinates fromLocalXYZ: aLocalCartesianCoordinates [

	self deprecated:'use directly absolute coordinates converting'.

	^ anOriginAbsoluteCoordinates localToECEFCartesianCoordinates:
		  aLocalCartesianCoordinates
]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> computeECEFXYZFromLgLatAlt: anAbsoluteCoordinates [

	self deprecated:'use directly absolute coordinates converting'.

	^ anAbsoluteCoordinates asECEFCartesianCoordinates 
]

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> computeLgLatAltFromECEFXYZ: aCartesianCoordinates [

	self deprecated:'use directly cartesian coordinates converting'.

	^ aCartesianCoordinates asECEFtoAbsoluteCoordinates
]

{ #category : #'to remove as soon as possible' }
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

{ #category : #'to remove as soon as possible' }
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

{ #category : #utilities }
GeodesicUtils class >> distanceInMetersFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [

	^ GeodesicVincentyFormulas new
		  distanceInMetersFrom: startAbsoluteCoordinate
		  to: endAbsoluteCoordinate
]

{ #category : #utilities }
GeodesicUtils class >> isAzimuthTowardsAreaFrom: anAbsCoordOrigin azimuth: anAzimuthInDegree area: aListOfAbsoluteCoords [

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

{ #category : #'to remove as soon as possible' }
GeodesicUtils class >> localPolar: aPolarCoordinates toGeodesicFrom: anOriginAbsoluteCoordinates [
	"Compute the geodesic position of a specified line end, knowing its azimuth, elevation, length and start geodesic position. Warning: that method doesn't take in account the earth curve as orthodromic2geodesic does.
 But that method takes in account the altitude in the calculus."

	self deprecated:'Use polar coordinates converting'.

	^ aPolarCoordinates localToAbsoluteCoordinates:
		  anOriginAbsoluteCoordinates
]

{ #category : #'to remove as soon as possible' }
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

{ #category : #'to remove as soon as possible' }
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
