"
A GeodesicUtilitiesTest is a test class for testing the behavior of GeodesicUtilities
"
Class {
	#name : #GeodesicUtilsTest,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #running }
GeodesicUtilsTest >> setUp [

	super setUp.

	WGS84 cleanUp
]

{ #category : #running }
GeodesicUtilsTest >> tearDown [ 

	GeodesicUtils cleanUp.

	super tearDown.
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesAlongGeodesicFromToAtFraction [

	| coordinates |
	coordinates := GeodesicUtils
		               absoluteCoordinatesAlongGeodesicFrom:
		               AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero
		               atFraction: 0.5.

	self assert: coordinates class identicalTo: AbsoluteCoordinates
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceAzimuth [
	"Déplacement vers l’Est sur 1000 m depuis l’équateur (0°, 0°) à azimut 90°"
	
    | start azimuth distance coord |
    
    start := AbsoluteCoordinates zero.
    azimuth := 90 degreesToRadians radians.
    distance := 1000 meters.

    coord := GeodesicUtils absoluteCoordinatesFrom: start distance: distance azimuth: azimuth.
    self assert: (coord latitudeInDegrees closeTo: 0).
    self assert: (coord longitudeInDegrees closeTo: 0.009013373 precision: 0.0001)
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMAzimuthInRadiansEast [

	| startCoord distance azimuth result expectedLat expectedLong tolerance |
	"Exemple : point initial à l’équateur et au méridien 0"
	startCoord := (0@0) asAbsoluteCoordinates. "latitude, longitude en radians"
	distance := 1000. "1 km"
	azimuth := 0.0. "vers le nord"
	tolerance := 1e-6.

	"--- Est (azimuth = π/2 rad) ---"
	azimuth := Float pi / 2.
	result := GeodesicUtils
		          absoluteCoordinatesFrom: startCoord
		          distanceInMeters: distance
		          azimuthInRadians: azimuth.
		
	expectedLat := 0.0.
	expectedLong := distance / WGS84 semiMajorAxisInMeters.
	
	self assert: ((result latitudeInRadians - expectedLat) abs < tolerance).
	self assert: ((result longitudeInRadians - expectedLong) abs < tolerance).
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMAzimuthInRadiansNorth [

	| startCoord distance azimuth result expectedLat expectedLong tolerance |
	"Exemple : point initial à l’équateur et au méridien 0"
	startCoord := (0@0) asAbsoluteCoordinates. "latitude, longitude en radians"
	distance := 1000. "1 km"
	azimuth := 0.0. "vers le nord"
	tolerance := 1e-6.

	"--- Nord (azimuth = 0 rad) ---"
	result := GeodesicUtils
		          absoluteCoordinatesFrom: startCoord
		          distanceInMeters: distance
		          azimuthInRadians: azimuth.

	"On attend que la latitude ait augmenté d’environ distance/rayonTerre"
	expectedLat := distance / WGS84 semiMinorAxisInMeters. "rayon terrestre moyen en m"
	expectedLong := 0.0.

	self assert: (result latitudeInRadians - expectedLat) abs < tolerance.
	self assert: (result longitudeInRadians - expectedLong) abs < tolerance
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMAzimuthInRadiansSouth [

	| startCoord distance azimuth result expectedLat expectedLong tolerance |
	"Exemple : point initial à l’équateur et au méridien 0"
	startCoord := (0@0) asAbsoluteCoordinates. "latitude, longitude en radians"
	distance := 1000. "1 km"
	azimuth := 0.0. "vers le nord"
	tolerance := 1e-6.

	"--- Sud (azimuth = π rad) ---"
	azimuth := Float pi.
	result := GeodesicUtils
		          absoluteCoordinatesFrom: startCoord
		          distanceInMeters: distance
		          azimuthInRadians: azimuth.
	
	expectedLat := (distance negated) / WGS84 semiMinorAxisInMeters.
	expectedLong := 0.0.
	
	self assert: ((result latitudeInRadians - expectedLat) abs < tolerance).
	self assert: ((result longitudeInRadians - expectedLong) abs < tolerance).
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMAzimuthInRadiansWest [

	| startCoord distance azimuth result expectedLat expectedLong tolerance |
	"Exemple : point initial à l’équateur et au méridien 0"
	startCoord := (0@0) asAbsoluteCoordinates. "latitude, longitude en radians"
	distance := 1000. "1 km"
	azimuth := 0.0. "vers le nord"
	tolerance := 1e-6.

	"--- Ouest (azimuth = 3π/2 rad) ---"
	azimuth := 3 * Float pi / 2.
	result := GeodesicUtils
		          absoluteCoordinatesFrom: startCoord
		          distanceInMeters: distance
		          azimuthInRadians: azimuth.
	
	expectedLat := 0.0.
	expectedLong := (distance negated) / WGS84 semiMajorAxisInMeters.
	
	self assert: ((result latitudeInRadians - expectedLat) abs < tolerance).
	self assert: ((result longitudeInRadians - expectedLong) abs < tolerance).
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians [
	"Déplacement vers l’Est sur 1000 m depuis l’équateur (0°, 0°) à azimut 90°"
	
    | start azimuth distanceInM coord |
    
    start := AbsoluteCoordinates zero.
    azimuth := 90 degreesToRadians.
    distanceInM := 1000.

    coord := GeodesicUtils absoluteCoordinatesFrom: start distanceInMeters: distanceInM azimuthInRadians: azimuth.
    self assert: (coord latitudeInDegrees closeTo: 0).
    self assert: (coord longitudeInDegrees closeTo: 0.009013373 precision: 0.0001)
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians2 [
	"Déplacement vers le Nord sur 1000 m depuis l’équateur (0°, 0°) à azimut 0°"
    | start azimuth distanceInM coord |
    
	start := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
   azimuth := 0 degreesToRadians.
   distanceInM := 1000.

   coord := GeodesicUtils absoluteCoordinatesFrom: start distanceInMeters: distanceInM azimuthInRadians: azimuth.
   self assert: (coord latitudeInDegrees closeTo: 0.008993216 precision: 1e-3).
   self assert: (coord longitudeInDegrees closeTo: 0.0). 
]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians3 [
    "Déplacement vers l’Est sur 1000 m depuis l’équateur (0°, 0°) à azimut 90°"
    | start azimuth distanceInM coord |

    start := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
    azimuth := 90 degreesToRadians.
    distanceInM := 1000.

    coord := GeodesicUtils absoluteCoordinatesFrom: start distanceInMeters: distanceInM azimuthInRadians: azimuth.
    self assert: (coord latitudeInDegrees closeTo: 0.0 precision: 1e-3).
    self assert: (coord longitudeInDegrees closeTo: 0.008993 precision: 1e-3).

]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians4 [
    "Déplacement vers le Sud sur 1000 m depuis l’équateur (0°, 0°) à azimut 180°"
    | start azimuth distanceInM coord |

    start := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
    azimuth := 180 degreesToRadians.
    distanceInM := 1000.

    coord := GeodesicUtils absoluteCoordinatesFrom: start distanceInMeters: distanceInM azimuthInRadians: azimuth.
    self assert: (coord latitudeInDegrees closeTo: (-0.008993) precision: 1e-3).
    self assert: (coord longitudeInDegrees closeTo: 0.0 precision: 1e-3).

]

{ #category : #tests }
GeodesicUtilsTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians5 [
    "Test d'un déplacement connu depuis Paris vers l'Est sur 1 km à azimut 90°"

    | start azimuth distance coord expectedLat expectedLon delta |
    start := AbsoluteCoordinates frParis.
    azimuth := 90 degreesToRadians.
    distance := 1000.

    coord := GeodesicUtils absoluteCoordinatesFrom: start distanceInMeters: distance azimuthInRadians: azimuth.

    expectedLat := 48.86.
    expectedLon := 2.34.
    delta := 1e-2.

    self assert: (coord latitudeInDegrees between: expectedLat - delta and: expectedLat + delta).
    self assert: (coord longitudeInDegrees between: expectedLon - delta and: expectedLon + delta).
]

{ #category : #tests }
GeodesicUtilsTest >> testAzimuthFromTo [

	| from to anAngle |
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 10 longitudeInDegrees: 0.
		
	anAngle := GeodesicUtils azimuthFrom: from to: to.
	self assert: ((anAngle convertTo: Unit deg) value closeTo: 0 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 10.
		
	anAngle := GeodesicUtils azimuthFrom: from to: to.
	self assert: ((anAngle convertTo: Unit deg) value closeTo: 90 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: -10 longitudeInDegrees: 0.
		
	anAngle := GeodesicUtils azimuthFrom: from to: to.
	self assert: ((anAngle convertTo: Unit deg) value closeTo: 180 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: -10.
		
	anAngle := GeodesicUtils azimuthFrom: from to: to.
	self assert: ((anAngle convertTo: Unit deg) value closeTo: 270 precision: 1e-10).
]

{ #category : #tests }
GeodesicUtilsTest >> testAzimuthInRadiansFromTo [

	| from to angleInRadians |
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 10 longitudeInDegrees: 0.
		
	angleInRadians := GeodesicUtils azimuthInRadiansFrom: from to: to.
	self assert: (angleInRadians radiansToDegrees closeTo: 0 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 10.
		
	angleInRadians := GeodesicUtils azimuthInRadiansFrom: from to: to.
	self assert: (angleInRadians radiansToDegrees closeTo: 90 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: -10 longitudeInDegrees: 0.
		
	angleInRadians := GeodesicUtils azimuthInRadiansFrom: from to: to.
	self assert: (angleInRadians radiansToDegrees closeTo: 180 precision: 1e-10).
	
	from := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0.
	to := AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: -10.
		
	angleInRadians := GeodesicUtils azimuthInRadiansFrom: from to: to.
	self assert: (angleInRadians radiansToDegrees closeTo: 270 precision: 1e-10).
]

{ #category : #tests }
GeodesicUtilsTest >> testAzimuthInRadiansFromTo2 [

	| originPointAbsCoord endPointAbsCoord azRad|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.28275 longitudeInDegrees: -4.70553.
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.32676 longitudeInDegrees: -4.68284.

	azRad := GeodesicUtils 	azimuthInRadiansFrom: originPointAbsCoord to: endPointAbsCoord.
		
	self assert: (azRad radiansToDegrees closeTo: 18.9726921431 precision: 1e-10) equals: true.
	
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.29603 longitudeInDegrees: -4.62295.

	azRad := GeodesicUtils azimuthInRadiansFrom: originPointAbsCoord to: endPointAbsCoord.
		
	self assert: (azRad radiansToDegrees closeTo: 76.42078534394 precision: 1e-10) equals: true. 
]

{ #category : #tests }
GeodesicUtilsTest >> testAzimuthInRadiansFromTo3 [

	| originPointAbsCoord endPointAbsCoord azRad|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48 longitudeInDegrees: -4.
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48 longitudeInDegrees: 4.

	azRad := GeodesicUtils 	azimuthInRadiansFrom: originPointAbsCoord to: endPointAbsCoord.
	self assert: (azRad radiansToDegrees closeTo: 87.03 precision: 1e-2) equals: true.
	
]

{ #category : #tests }
GeodesicUtilsTest >> testDistanceFromTo [
	| originPoint endPoint distance |
	
	originPoint := AbsoluteCoordinates latitudeInDegrees: 50.06638889 longitudeInDegrees: -5.71472222.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 58.64388889 longitudeInDegrees: -3.07.
	distance := GeodesicUtils distanceFrom: originPoint to: endPoint.
	self assert: ((distance convertTo: Unit meter) value closeTo: 969918.64 precision: 1e-1).

	"0 distance"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 42.0 longitudeInDegrees: 3.0.
	self assert: (GeodesicUtils distanceFrom: originPoint to: originPoint) equals: 0.
	
	"meridian line"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 10.0 longitudeInDegrees: 0.0.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 20.0 longitudeInDegrees: 0.0.
	distance := GeodesicUtils distanceFrom: originPoint to: endPoint.
	self assert: ((distance convertTo: Unit meter) value closeTo: 1.1131949079327355e6 precision: 1e-6). "Approx. 1111949.266 m between latitudes of 10°"
	
	"equatorial line"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 0.0.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 1.0.
	distance := GeodesicUtils distanceFrom: originPoint to: endPoint.
	self assert: ((distance convertTo: Unit meter) value closeTo: 111319.5 precision: 1e-1). "Approx. 111319.5 m"
]

{ #category : #tests }
GeodesicUtilsTest >> testDistanceInMetersFromTo [
	| originPoint endPoint distanceInM |
	
	originPoint := AbsoluteCoordinates latitudeInDegrees: 50.06638889 longitudeInDegrees: -5.71472222.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 58.64388889 longitudeInDegrees: -3.07.
	distanceInM := GeodesicUtils distanceInMetersFrom: originPoint to: endPoint.
	self assert: (distanceInM closeTo: 969918.64 precision: 1e-1).

	"0 distance"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 42.0 longitudeInDegrees: 3.0.
	self assert: (GeodesicUtils distanceInMetersFrom: originPoint to: originPoint) equals: 0.
	
	"meridian line"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 10.0 longitudeInDegrees: 0.0.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 20.0 longitudeInDegrees: 0.0.
	distanceInM := GeodesicUtils distanceInMetersFrom: originPoint to: endPoint.
	self assert: (distanceInM closeTo: 1.1131949079327355e6 precision: 1e-6). "Approx. 1111949.266 m between latitudes of 10°"
	
	"equatorial line"
	originPoint := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 0.0.
	endPoint := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 1.0.
	distanceInM := GeodesicUtils distanceInMetersFrom: originPoint to: endPoint.
	self assert: (distanceInM closeTo: 111319.5 precision: 1e-1). "Approx. 111319.5 m"
]

{ #category : #tests }
GeodesicUtilsTest >> testDistanceInMetersFromTo2 [

	| origin end dist |
	"classic"
	origin := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 0.0.
	end := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 1.0.
	dist := GeodesicUtils distanceInMetersFrom: origin to: end.
	self assert: (dist closeTo: 111319.4907932736 precision: 1e-3).
	
	"equator to north-east"
	origin := AbsoluteCoordinates latitudeInDegrees: 0.0 longitudeInDegrees: 0.0.
	end := AbsoluteCoordinates latitudeInDegrees: 1.0 longitudeInDegrees: 1.0.
	dist := GeodesicUtils distanceInMetersFrom: origin to: end.
	self assert: (dist closeTo: 156899.5 precision: 1e-1).
	
	"near points - precision errors"
	origin := AbsoluteCoordinates latitudeInDegrees: 48.0 longitudeInDegrees: 2.0.
	end := AbsoluteCoordinates latitudeInDegrees: 48.00001 longitudeInDegrees: 2.00001.
	dist := GeodesicUtils distanceInMetersFrom: origin to: end.
	self assert: (dist closeTo: 1.33909 precision: 1e-3).
]

{ #category : #tests }
GeodesicUtilsTest >> testFormulas [

	self
		assert: GeodesicUtils formulas class
		equals: GeodesicVincentyFormulas
]

{ #category : #tests }
GeodesicUtilsTest >> testIsAzimuthTowardsAreaFromAzimuthInDegreesArea [

	| originPointAbsCoord isAzTowardsArea listPointsArea headingInDegree |
	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.28275
		                       longitudeInDegrees: -4.70553.

	listPointsArea := OrderedCollection new.
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.32676
			 longitudeInDegrees: -4.68284).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.33995
			 longitudeInDegrees: -4.65976).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.3117
			 longitudeInDegrees: -4.60466).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.29603
			 longitudeInDegrees: -4.62295).

	headingInDegree := 45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord latitudeInDegrees: 48.29603.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	headingInDegree := -45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self deny: isAzTowardsArea.

	headingInDegree := 90.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.34
		                       longitudeInDegrees: -4.62.
	headingInDegree := 225.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.
	self assert: isAzTowardsArea.

	headingInDegree := 180.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.01
		                       longitudeInDegrees: -4.62.
	headingInDegree := 45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self deny: isAzTowardsArea
]

{ #category : #tests }
GeodesicUtilsTest >> testIsAzimuthTowardsAreaFromAzimuthInRadiansArea [

	| originPointAbsCoord isAzTowardsArea listPointsArea headingInDegree |
	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.28275
		                       longitudeInDegrees: -4.70553.

	listPointsArea := OrderedCollection new.
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.32676
			 longitudeInDegrees: -4.68284).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.33995
			 longitudeInDegrees: -4.65976).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.3117
			 longitudeInDegrees: -4.60466).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.29603
			 longitudeInDegrees: -4.62295).

	headingInDegree := 45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians 
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord latitudeInDegrees: 48.29603.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	headingInDegree := -45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self deny: isAzTowardsArea.

	headingInDegree := 90.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.34
		                       longitudeInDegrees: -4.62.
	headingInDegree := 225.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	headingInDegree := 180.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self assert: isAzTowardsArea.

	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.01
		                       longitudeInDegrees: -4.62.
	headingInDegree := 45.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInRadians: headingInDegree degreesToRadians
		                   area: listPointsArea.

	self deny: isAzTowardsArea
]

{ #category : #tests }
GeodesicUtilsTest >> testIsAzimuthTowardsRectangleArea [

	| originPointAbsCoord isAzTowardsArea listPointsArea headingInDegree |
	originPointAbsCoord := AbsoluteCoordinates
		                       latitudeInDegrees: 48.20146040354154
		                       longitudeInDegrees: -4.492.

	listPointsArea := OrderedCollection new.
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.20998
			 longitudeInDegrees: -4.493).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.20998
			 longitudeInDegrees: -4.491).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.208
			 longitudeInDegrees: -4.491).
	listPointsArea add: (AbsoluteCoordinates
			 latitudeInDegrees: 48.208
			 longitudeInDegrees: -4.493).

	headingInDegree := 0.

	isAzTowardsArea := GeodesicUtils
		                   isAzimuthTowardsAreaFrom: originPointAbsCoord
		                   azimuthInDegrees: headingInDegree
		                   area: listPointsArea.

	self assert: isAzTowardsArea
]
