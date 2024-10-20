"
An AbsoluteCoordinatesTest is a test class for testing the behavior of AbsoluteCoordinates
"
Class {
	#name : #AbsoluteCoordinatesTest,
	#superclass : #TestCase,
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #tests }
AbsoluteCoordinatesTest >> testDistanceBetweenKnownAbsoluteCoordinates [

	| pt1 pt2 dist az |
	pt1 := AbsoluteCoordinates frBrest.
	pt2 := AbsoluteCoordinates frStRenan.

	dist := GeodesicUtilities
		        convertGeodesicToDistanceInMeterFrom: pt1
		        to: pt2.
	az := GeodesicUtilities
		      convertGeodesicToAzimuthInRadiansFrom: pt1
		      to: pt2.
	az := az radiansToDegrees.
	self assert: (az - 295) abs < 5 .
	self assert: (dist - 11500) abs < 1000 .

]
