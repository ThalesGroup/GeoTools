Class {
	#name : #DMSAbsoluteCoordinatesPrinterTest,
	#superclass : #AbstractAbsoluteCoordinatesPrinterTest,
	#category : #'GeoTools-Tests-Coordinates'
}

{ #category : #accessing }
DMSAbsoluteCoordinatesPrinterTest >> printerClass [

	^ DMSAbsoluteCoordinatesPrinter 
]

{ #category : #tests }
DMSAbsoluteCoordinatesPrinterTest >> testCharacterWest [
	"Test changing west character, i.e. using french language"

	| stream |
	printer characterWest: $O.
	self assert: printer characterWest equals: $O.
	
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates frBrest on: stream.
	self assert: stream contents equals: '48°23''22"N 004°29''00"O 52m'.
]

{ #category : #tests }
DMSAbsoluteCoordinatesPrinterTest >> testPrintAbsoluteCoordinatesOn2 [

	| stream |
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates frBrest on: stream.
	self assert: stream contents equals: '48°23''22"N 004°29''00"W 52m'.
	
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates zero on: stream.
	self assert: stream contents equals: '00°00''00"N 000°00''00"E 0m'.
	
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates new on: stream.
	self assert: stream contents equals: ''

	
	
]

{ #category : #tests }
DMSAbsoluteCoordinatesPrinterTest >> testReset [

	printer reset
]

{ #category : #tests }
DMSAbsoluteCoordinatesPrinterTest >> testWithSpaces [

	| stream |
	self deny: printer withSpaces.

	printer withSpaces: true.
	self assert: printer withSpaces.
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates frBrest on: stream.
	self assert: stream contents equals: '48° 23'' 22" N   004° 29'' 00" W  52m'.
	
	printer withSpaces: false.
	self deny: printer withSpaces.
	stream := String new writeStream.
	printer printAbsoluteCoordinates: AbsoluteCoordinates frBrest on: stream.
	self assert: stream contents equals: '48°23''22"N 004°29''00"W 52m'.
]
