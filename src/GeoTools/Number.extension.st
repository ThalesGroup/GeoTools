Extension { #name : #Number }

{ #category : #'*GeoTools' }
Number >> asAzimuthAngle [

	^ 90 - self \\ 360
]

{ #category : #'*GeoTools' }
Number >> asTrigonometricAngle [

	^ self + 270 \\ 360
]

{ #category : #'*GeoTools' }
Number >> isAngleInRadiansBetween: aStartAngleInRadians and: anEndAngleInRadians [ 
	"check if anAngleInRad is between startAngle and endAngle. Deal with the 0 :
	self checkAngle: 0 isBetween: 355 and: 5 => true
	while (0 between: 355 and: 5) => false"
	
	| interval middle | 
	
	(self closeTo: aStartAngleInRadians precision: 1e-7) ifTrue:[ ^ true ].
	
	interval := anEndAngleInRadians - aStartAngleInRadians.
	interval negative ifTrue:[ interval := interval + (2*Float pi)].

	middle := self - aStartAngleInRadians.
	middle negative ifTrue:[ middle := middle + (2*Float pi)].	
	
	^ middle <= interval
]
