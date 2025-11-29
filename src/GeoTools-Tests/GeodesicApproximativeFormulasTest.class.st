"
A GeodesicVincentyFormulasTest is a test class for testing the behavior of GeodesicVincentyFormulas
"
Class {
	#name : #GeodesicApproximativeFormulasTest,
	#superclass : #GeodesicFormulasTest,
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #testing }
GeodesicApproximativeFormulasTest class >> isDeprecated [ 

	^ true
]

{ #category : #accessing }
GeodesicApproximativeFormulasTest >> geodesicFormulasClass [

	^ GeodesicApproximativeFormulas 
]
