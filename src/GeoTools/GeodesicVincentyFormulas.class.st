"
https://en.wikipedia.org/wiki/Vincenty%27s_formulae
"
Class {
	#name : #GeodesicVincentyFormulas,
	#superclass : #GeodesicFormulas,
	#instVars : [
		'iterationsLimit',
		'precision'
	],
	#category : #'GeoTools-Geodesic'
}

{ #category : #default }
GeodesicVincentyFormulas class >> defaultIterationsLimit [

	^ 100
]

{ #category : #default }
GeodesicVincentyFormulas class >> defaultPrecision [

	^ 1e-12
]

{ #category : #tools }
GeodesicVincentyFormulas >> absoluteCoordinatesAlongGeodesicFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate atFraction: aFraction [

	| distance azimuth |
	
	(aFromAbsoluteCoordinate isValid and: [aToAbsoluteCoordinate isValid]) ifFalse: [ ^ nil ].
	(aFraction >= 1.0) ifTrue: [ ^ aToAbsoluteCoordinate copy ].
	(aFraction <= 0.0) ifTrue: [ ^ aFromAbsoluteCoordinate copy ].
	
	distance := self distanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.
	azimuth := self azimuthInRadiansFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate.

	distance := distance * aFraction.
	distance < self precision ifTrue:[ ^ aFromAbsoluteCoordinate copy ].

	^ self absoluteCoordinatesFrom: aFromAbsoluteCoordinate distanceInMeters: distance azimuthInRadians: azimuth
]

{ #category : #tools }
GeodesicVincentyFormulas >> absoluteCoordinatesFrom: anAbsoluteCoordinates distanceInMeters: aDistanceInM azimuthInRadians: anAzimuthInRadians [
	| a f b lat1 lon1 alpha1 sinAlpha1 cosAlpha1 u1 sinU1 cosU1 sigma1 sinAlpha cosSqAlpha uSq A B sigma sigmaPrev iterLimit cosSigma sinSigma lat2 deltaSigma C L lon2 lambda cos2SigmaM tmp |

    anAbsoluteCoordinates isValid ifFalse: [ ^ nil ].
    aDistanceInM = 0 ifTrue: [ ^ anAbsoluteCoordinates copy ].

    a := WGS84 semiMajorAxisInMeters.
    f := WGS84 flattening.
    b := a * (1 - f).

    lat1 := anAbsoluteCoordinates latitudeInRadians.
    lon1 := anAbsoluteCoordinates longitudeInRadians.
    alpha1 := anAzimuthInRadians.
    sinAlpha1 := alpha1 sin.
    cosAlpha1 := alpha1 cos.

    "Calcul latitude réduite U1"
    u1 := ((1 - f) * (lat1 tan)) arcTan.
    sinU1 := u1 sin.
    cosU1 := u1 cos.

    "sigma1"
    sigma1 := ((u1 tan) / cosAlpha1) arcTan.  "arcTan au lieu de arcTan2"

    sinAlpha := cosU1 * sinAlpha1.
    cosSqAlpha := 1 - (sinAlpha squared).

    uSq := (cosSqAlpha * ((a squared) - (b squared))) / (b squared).
    A := 1 + ((uSq / 16384) * (4096 + (uSq * (-768 + (uSq * (320 - (175 * uSq))))))).
    B := (uSq / 1024) * (256 + (uSq * (-128 + (uSq * (74 - (47 * uSq)))))).

    sigma := aDistanceInM / (b * A).
	 sinSigma := sigma sin.
    cosSigma := sigma cos.
	 cos2SigmaM := ((2 * sigma1) + sigma) cos.
    sigmaPrev := 0.0.
    iterLimit := self iterationsLimit copy.

    [ ((sigma - sigmaPrev) abs > self precision) and: [ iterLimit > 0 ] ] whileTrue: [
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
        sigma := (aDistanceInM / (b * A)) + deltaSigma.
        iterLimit := iterLimit - 1.
    ].

    tmp := ((sinU1 * sinSigma) - (cosU1 * cosSigma * cosAlpha1)).
    lat2 := ((sinU1 * cosSigma) + (cosU1 * sinSigma * cosAlpha1)) arcTan2: ((1 - f) * (((sinAlpha squared) + (tmp * tmp)) sqrt)).
    lambda := (sinSigma * sinAlpha1) arcTan2: ((cosU1 * cosSigma) - (sinU1 * sinSigma * cosAlpha1)).
    C := ((f / 16) * cosSqAlpha * (4 + (f * (4 - (3 * cosSqAlpha))))).
    L := lambda - ((1 - C) * f * sinAlpha1 * (sigma + (C * sinSigma * (cos2SigmaM + (C * cosSigma * (-1 + (2 * ((cos2SigmaM) squared)))))))).
    lon2 := (((lon1 + L + (3 * Float pi)) euclideanModulo: (2 * Float pi)) - Float pi).

    ^ AbsoluteCoordinates latitudeInRadians: lat2 longitudeInRadians: lon2

]

{ #category : #tools }
GeodesicVincentyFormulas >> azimuthInRadiansFrom: aFromAbsoluteCoordinates to: anToAbsoluteCoordinates [
	"Compute azimut between two Geodesic (lat/long) coordinates and return azimuth in radians"

	| d5 d6 d7 d8 d9 d10 d11 d12 d14 d13 d15 d16 d17 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 break |
	
	(aFromAbsoluteCoordinates isValid not or:[anToAbsoluteCoordinates isValid not]) ifTrue:[ ^ 0 ].
	
	(aFromAbsoluteCoordinates longitudeInRadians closeTo: anToAbsoluteCoordinates longitudeInRadians precision: 1e-7) ifTrue: 
		[ (aFromAbsoluteCoordinates latitudeInRadians closeTo: anToAbsoluteCoordinates latitudeInRadians precision: 1e-7)
			ifTrue: [^ 0].
		anToAbsoluteCoordinates latitudeInRadians >= aFromAbsoluteCoordinates latitudeInRadians 
			ifTrue: [^ 0]
			ifFalse: [^ Float pi]].
		
	d5 := ((aFromAbsoluteCoordinates latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d6 := ((anToAbsoluteCoordinates latitudeInRadians tan * WGS84 semiMinorAxisInMeters) / WGS84 semiMajorAxisInMeters) arcTan.
	d7 := d5 cos.
	d8 := d6 cos.
	d9 := d5 sin.
	d10 := d6 sin.
	d27 := WGS84 flattening / 16.
	d11 := anToAbsoluteCoordinates longitudeInRadians - aFromAbsoluteCoordinates longitudeInRadians.
	d12 := d11.
	d13 := d11.
	d14 := d12 sin.
	d15 := d12 cos.
	d28 := 0.
	break := false.
	
	[ d28 < self iterationsLimit and: [ break not ] ] whileTrue: 
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

{ #category : #incubator }
GeodesicVincentyFormulas >> azimuthInRadiansWithVincentyPreciseFrom: startAbsoluteCoordinate to: endAbsoluteCoordinate [
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

	[ d28 < self iterationsLimit and: [ break not ] ] whileTrue: [
		d16 := d8 * d14.
		d17 := d7 * d10 - (d9 * d8 * d15).
		d20 := (d16 * d16 + (d17 * d17)) sqrt.
		d21 := d9 * d10 + (d7 * d8 * d15).
		" !!! Math.atan2(y,x) => (x,y) theta "
		d22 := (d21 @ d20) theta.
		d20 = 0 ifTrue: [ ^0 ].
		d23 := d7 * d8 * d14 / d20.
		d24 := 1 - (d23 * d23).
		d25 := d24 < self precision
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
GeodesicVincentyFormulas >> distanceInMetersFrom: aFromAbsoluteCoordinate to: aToAbsoluteCoordinate [
	"Vincenty algorithm to compute distance between two Geodesic (lat/long) coordinates and return it in meter"

	"https://en.wikipedia.org/wiki/Vincenty%27s_formulae"

	| u1 u2 cosU1 cosU2 sinU1 sinU2 diffLong lambda sinLambda cosLambda d16 d17 d18 d19 lambdaP sinSigma cosSigma sigma cosSqAlpha cos2SigmaM d27 d28 d29 d30 d31 d32 l sinAlpha noIterations latDiff lonDiff |
	(aFromAbsoluteCoordinate isValid not or: [
		 aToAbsoluteCoordinate isValid not ]) ifTrue: [ ^ 0 ].

	"Early exit for very close points (use faster Haversine)"
	latDiff := (aFromAbsoluteCoordinate latitudeInRadians
	            - aToAbsoluteCoordinate latitudeInRadians) abs.
	lonDiff := (aFromAbsoluteCoordinate longitudeInRadians
	            - aToAbsoluteCoordinate longitudeInRadians) abs.
	(latDiff < self fastModeThresholdInRadians and: [
		 lonDiff < self fastModeThresholdInRadians ]) ifTrue: [
			^ self
				  fastDistanceInMetersFrom: aFromAbsoluteCoordinate
				  to: aToAbsoluteCoordinate ].

	u1 := (1 - WGS84 flattening
	       * aFromAbsoluteCoordinate latitudeInRadians tan) arcTan.
	u2 := (1 - WGS84 flattening
	       * aToAbsoluteCoordinate latitudeInRadians tan) arcTan.
	cosU1 := u1 cos.
	cosU2 := u2 cos.
	sinU1 := u1 sin.
	sinU2 := u2 sin.
	d28 := WGS84 flattening / 16.
	diffLong := aToAbsoluteCoordinate longitudeInRadians
	            - aFromAbsoluteCoordinate longitudeInRadians.
	lambda := diffLong.
	"d20 := 2 * d12."
	lambdaP := 0.0.

	noIterations := true.
	l := 1.

	[
		(lambda - lambdaP) abs >= self precision and: [
			l < self iterationsLimit ] ] whileTrue: [
			noIterations := false.
			lambdaP := lambda.
			sinLambda := lambda sin.
			cosLambda := lambda cos.
			d16 := cosU2 * sinLambda.
			d18 := cosU1 * sinU2 - (sinU1 * cosU2 * cosLambda).
			sinSigma := (d16 * d16 + (d18 * d18)) sqrt.
			sinSigma = 0 ifTrue: [ ^ 0 ].
			cosSigma := sinU1 * sinU2 + (cosU1 * cosU2 * cosLambda).
			sigma := sinSigma arcTan: cosSigma. "ok equivalent to (sinSigma @ cosSigma) theta."
			sinAlpha := cosU1 * cosU2 * sinLambda / sinSigma.
			cosSqAlpha := 1 - sinAlpha squared.
			cos2SigmaM := cosSqAlpha < self precision
				              ifTrue: [ 0 ]
				              ifFalse: [
				              cosSigma - (2 * sinU1 * sinU2 / cosSqAlpha) ].
			d27 := d28 * cosSqAlpha
			       * (4 + (WGS84 flattening * (4 - (3 * cosSqAlpha)))).
			d16 := cos2SigmaM
			       + (d27 * cosSigma * (-1 + (2 * cos2SigmaM * cos2SigmaM))).
			"d18 := (1 - d27) * WGS84 flattening * cosSqAlpha * (sigma + (d27 * sinSigma * d16))."
			d18 := 1 - d27 * WGS84 flattening * sinAlpha
			       * (sigma + (d27 * sinSigma * d16)).
			lambda := diffLong + d18.
			sinLambda := lambda sin.
			cosLambda := lambda cos.
			l := l + 1 ].

	noIterations ifTrue: [ "limit case, invoque haversine formula by default"
			^ self
				  fastDistanceInMetersFrom: aFromAbsoluteCoordinate
				  to: aToAbsoluteCoordinate ].

	d29 := cosSqAlpha * WGS84 eccentricitySquared.
	d30 := 1
	       +
	       (d29 / 16384
	        * (4096 + (d29 * (-768 + (d29 * (320 - (175 * d29))))))).
	d31 := d29 / 1024
	       * (256 + (d29 * (-128 + (d29 * (74 - (47 * d29)))))).
	d17 := cosSigma * (-1 + (2 * cos2SigmaM squared)).
	d19 := cos2SigmaM * (-3 + (4 * sinSigma squared))
	       * (-3 + (4 * cos2SigmaM squared)).
	d32 := d31 * sinSigma
	       * (cos2SigmaM + (d31 / 4 * (d17 - (d31 / 6 * d19)))).

	^ WGS84 semiMinorAxisInMeters * d30 * (sigma - d32)
]

{ #category : #accessing }
GeodesicVincentyFormulas >> iterationsLimit [

	^ iterationsLimit ifNil: [
		  iterationsLimit := self class defaultIterationsLimit ]
]

{ #category : #accessing }
GeodesicVincentyFormulas >> iterationsLimit: anObject [

	iterationsLimit := anObject
]

{ #category : #accessing }
GeodesicVincentyFormulas >> precision [
	"Return the precision of computing in meters"

	^ precision ifNil: [
		  precision := self class defaultPrecision ]
]

{ #category : #accessing }
GeodesicVincentyFormulas >> precision: aFloatInMeters [

	precision := aFloatInMeters
]
