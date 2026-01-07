"
An AbstractAbsoluteCoordinatesPrinterTest is a test class for testing the behavior of AbstractAbsoluteCoordinatesPrinter
"
Class {
	#name : #AbstractAbsoluteCoordinatesPrinterTest,
	#superclass : #TestCase,
	#instVars : [
		'printer'
	],
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #testing }
AbstractAbsoluteCoordinatesPrinterTest class >> isAbstract [ 

	^ self == AbstractAbsoluteCoordinatesPrinterTest
]

{ #category : #private }
AbstractAbsoluteCoordinatesPrinterTest >> coordinatesList [

	^ {
		  AbsoluteCoordinates frBrest.
		  AbsoluteCoordinates ausSydney.
		  AbsoluteCoordinates usaNewYork.
		  AbsoluteCoordinates zero.
		  (AbsoluteCoordinates latitudeInDegrees: 0 longitudeInDegrees: 0).
		  AbsoluteCoordinates new }
]

{ #category : #accessing }
AbstractAbsoluteCoordinatesPrinterTest >> printerClass [

	self subclassResponsibility 
]

{ #category : #running }
AbstractAbsoluteCoordinatesPrinterTest >> setUp [

	super setUp.

	printer := self printerClass new
]

{ #category : #tests }
AbstractAbsoluteCoordinatesPrinterTest >> testPrintAbsoluteCoordinatesOn [

	self coordinatesList do: [ :c |
			| stream |
			stream := String new writeStream.
			printer printAbsoluteCoordinates: c on: stream.
			self assert: stream contents isString ]
]

{ #category : #tests }
AbstractAbsoluteCoordinatesPrinterTest >> testPrintAltitudeOn [

	self coordinatesList do: [ :c |
			| stream |
			stream := String new writeStream.
			printer printAltitude: c altitude on: stream.
			self assert: stream contents isString ]
]

{ #category : #tests }
AbstractAbsoluteCoordinatesPrinterTest >> testPrintLatitudeOn [

	self coordinatesList do: [ :c |
			| stream |
			stream := String new writeStream.
			printer printLatitude: c latitude on: stream.
			self assert: stream contents isString ]
]

{ #category : #tests }
AbstractAbsoluteCoordinatesPrinterTest >> testPrintLongitudeOn [

	self coordinatesList do: [ :c |
			| stream |
			stream := String new writeStream.
			printer printLongitude: c longitude on: stream.
			self assert: stream contents isString ]
]
