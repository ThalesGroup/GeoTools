Extension { #name : #Number }

{ #category : #'*GeoTools' }
Number >> arcTan2: x [
    "Calcule atan2(self, x) en radians"
    | angle |
    (self = 0 and: [x = 0])
        ifTrue: [^ 0].  "Indéfini, on choisit 0"
    (x = 0)
        ifTrue: [^ self > 0
                ifTrue: [Float pi / 2]
                ifFalse: [Float pi / -2]].
    angle := (self / x) arcTan.
    (x > 0)
        ifTrue: [^ angle].
    (self >= 0)
        ifTrue: [^ angle + Float pi].
    ^ angle - Float pi.
]

{ #category : #'*GeoTools' }
Number >> asAzimuthAngle [

	^ 90 - self \\ 360
]

{ #category : #'*GeoTools' }
Number >> asTrigonometricAngle [

	^ self + 270 \\ 360
]

{ #category : #'*GeoTools' }
Number >> euclideanModulo: aNumber [
	"Retourne le modulo euclidien de self par aNumber, toujours positif entre 0 et aNumber."

	| r |
	r := self \\ aNumber. "Reste natif Smalltalk, peut être négatif"
	^ r < 0
		  ifTrue: [ r + aNumber ]
		  ifFalse: [ r ]
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
