"
I am position of a GeoObject.
"
Class {
	#name : #AbsoluteCoordinates,
	#superclass : #SmockAbstractCoordinates,
	#instVars : [
		'latitudeInDegrees',
		'longitudeInDegrees',
		'altitudeInMeters'
	],
	#category : #'GeoTools-Coordinates'
}

{ #category : #cities }
AbsoluteCoordinates class >> ausSydney [

	^ AbsoluteCoordinates 
		latitudeInDegrees: -33.8678500
		longitudeInDegrees: 151.2073200
		altitudeInMeters: 58
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> charDegree [

	^Character value: 16rB0
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> charMinute [
	^(Character value: 16r27)
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> charPoint [
	^$.
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> charSecond [
	^(Character value: 16r22)
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> cleanLatitudeString: aString [
	"clean latitude string from parsing file characters"

	| _cleanString |
	_cleanString := aString.
	_cleanString notNil ifTrue:[
		(_cleanString at: 1) = $" ifTrue: 
			[_cleanString := _cleanString copyFrom: 2 to: _cleanString size - 1.
			_cleanString := _cleanString copyReplaceAll: '""' with: '"'].
	].

	^_cleanString
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> createFromLatString: latitudeString lonString: longitudeString [

	| _lat _lon |

	(latitudeString isNil or:[latitudeString isEmpty]) ifTrue:[^nil].
	(longitudeString isNil or:[longitudeString isEmpty]) ifTrue:[^nil].

	_lat := self readLatitudeString: latitudeString.
	_lon := self readLongitudeString: longitudeString.

	(_lat isNil or:[_lon isNil]) ifTrue:[^nil].

	^self new latitudeInDegrees: _lat; longitudeInDegrees: _lon; yourself.
]

{ #category : #cities }
AbsoluteCoordinates class >> frBordeaux [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 44.8378
		longitudeInDegrees: -0.594
		altitudeInMeters: 22
]

{ #category : #cities }
AbsoluteCoordinates class >> frBrest [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.3897
		longitudeInDegrees: -4.48333
		altitudeInMeters: 52
]

{ #category : #cities }
AbsoluteCoordinates class >> frElancourt [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.7839
		longitudeInDegrees:  1.95806
		altitudeInMeters: 138 
]

{ #category : #cities }
AbsoluteCoordinates class >> frLyon [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 45.7589
		longitudeInDegrees: 4.84139
		altitudeInMeters: 237 
]

{ #category : #cities }
AbsoluteCoordinates class >> frMarseille [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 43.2967
		longitudeInDegrees: 5.37639
		altitudeInMeters: 320
]

{ #category : #cities }
AbsoluteCoordinates class >> frNevers [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 46.9925
		longitudeInDegrees:  3.15667
		altitudeInMeters: 203 
]

{ #category : #cities }
AbsoluteCoordinates class >> frParis [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 48.8667
		longitudeInDegrees: 2.33333
		altitudeInMeters: 79 
]

{ #category : #cities }
AbsoluteCoordinates class >> frStRenan [

	^ AbsoluteCoordinates 
    latitudeInDegrees: 48.4328
    longitudeInDegrees: -4.6219
    altitudeInMeters: 60
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> geoStringFormat: aString [
	"read a geo string and return the format"

	| _number |
	(self isStringMatchingDMC: aString) ifTrue:[^#DMD].
	(self isStringMatchingDMS: aString) ifTrue:[^#DMS].
	(aString matchesRegex:'[0-9]*\.?[0-9]*') ifTrue: [^#DMS].
	(aString matchesRegex: '.*[0-9]* [0-9]* [0-9]*.*') ifTrue:[^#DMS].
	(aString matchesRegex: '.*[0-9]* *° *[0-9]* *'' *[0-9]* *".*') ifTrue:[^#DMS].
	_number := aString asNumber.
	_number notNil ifTrue:[
		_number printString = aString ifTrue:[^#Decimal].
	].

	^nil
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> in: aString removeChar: aChar [

| rs ws |
	rs := aString readStream.
	ws := WriteStream on: String new.
	[ rs atEnd ] whileFalse: [
		| str |
		str := rs upTo: aChar.
		ws nextPutAll: str ].
	rs close.
	ws close.
	^ ws contents
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> in: aString removeFirstChar: aChar [

	| rs ws str |
	rs := aString readStream.
	ws := WriteStream on: String new.
	str := rs upTo: aChar.
	ws nextPutAll: str.
	str := rs upToEnd.
	ws nextPutAll: str.
	rs close.
	ws close.
	^ ws contents
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> isStringMatchingDMC: aString [
	"self isStringMatchingDMC:  '[Point] X°X.X'' [Point]"

	| _pattern |
	_pattern := String new writeStream.
	_pattern nextPutAll: '*'.
	_pattern nextPutAll: self charDegree asSymbol asText.
	_pattern nextPutAll: '*'.
	_pattern nextPutAll: self charPoint asSymbol asText.
	_pattern nextPutAll: '*'.
	"_pattern nextPutAll: self charMinute asSymbol asText.
	_pattern nextPutAll: '*'."

	^_pattern contents match: aString
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> isStringMatchingDMS: aString [
	"self isStringMatchingDMS: '000°00''00''''N'	"

	| _pattern |
	_pattern := String new writeStream.
	_pattern nextPutAll: '*'.
	_pattern nextPutAll: self charDegree asSymbol asText.
	_pattern nextPutAll: '*'.
	_pattern nextPutAll: self charMinute asSymbol asText.
	_pattern nextPutAll: '*'.
	_pattern nextPutAll: self charSecond asSymbol asText.
	_pattern nextPutAll: '*'.

	^_pattern contents match: aString
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees [

	| coordinates |
	coordinates := self latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees altitudeInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInDegrees: aLatitudeInDegrees longitudeInDegrees: aLongitudeInDegrees altitudeInMeters: anAltitudeInMeters [

	| coordinates |
	coordinates := self new.
	coordinates latitudeInDegrees: aLatitudeInDegrees.
	coordinates longitudeInDegrees: aLongitudeInDegrees.
	coordinates altitudeInMeters: anAltitudeInMeters.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians [

	| coordinates |
	coordinates := self latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians altitudeInMeters: nil.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> latitudeInRadians: aLatitudeInRadians longitudeInRadians: aLongitudeInRadians altitudeInMeters: anAltitudeInMeters [

	| coordinates |
	coordinates := self new.
	coordinates latitudeInRadians: aLatitudeInRadians.
	coordinates longitudeInRadians: aLongitudeInRadians.
	coordinates altitudeInMeters: anAltitudeInMeters.
	^coordinates
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> random [
	<script: 'self random inspect'>

	| random |
	random := Random new.
	^ self
		  latitudeInDegrees: random next * 90 * (random next > 0.5
				   ifTrue: [ 1 ]
				   ifFalse: [ 1 negated ])
		  longitudeInDegrees: random next * 180 * (random next > 0.5
				   ifTrue: [ 1 ]
				   ifFalse: [ 1 negated ])
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readDMCString: aString [ 
	"Degree Minute Centième de minute"
	"N 49°36.99'"
	
	^self readDMMString: aString
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readDMDString: aString [ 
	"Degree Minute en décimal"
	"	N 49°36.999 	"
	
	| _string rs degree minute sign m d |
	aString isString ifFalse: [^aString].
	_string := aString.

	(('*S*' match: _string) or:[('*W*' match: _string) or:[('*O*' match: _string)]]) ifTrue:[sign := -1] ifFalse:[sign := 1].

	_string := _string removeChar: $N.
	_string := _string removeChar: $S.
	_string := _string removeChar: $E.
	_string := _string removeChar: $W.
	_string := _string removeChar: $O.

	rs := ReadStream on: _string.
	degree := (rs upTo: self charDegree) asNumber.
	minute := (rs upToEnd) asNumber.

	"conversion"
	m := (minute ) / 60.
	d := degree + m.
	^d * sign asFloat
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readDMMString: aString [ 
	"Degree Minute Millième de minute"
	"	N 49°36.999'	"
	
	^self readDMDString: aString
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readDMSString: aString [ 
	"Degree Minute Second"

	| rs degree minute second sign s m d _string |
	aString isString ifFalse: [^aString].
	_string := aString.

	(('*S*' match: _string) or:[('*W*' match: _string) or:[('*O*' match: _string)]]) ifTrue:[sign := -1] ifFalse:[sign := 1].

	_string := _string removeChar: $N.
	_string := _string removeChar: $S.
	_string := _string removeChar: $E.
	_string := _string removeChar: $W.
	_string := _string removeChar: $O.

	rs := ReadStream on: _string.
	degree := (rs upTo: self charDegree) asNumber.
	minute := (rs upTo: self charMinute) asNumber. 
	second := (rs upTo: self charSecond) asNumber.

	"conversion"
	s := second / 60.
	m := (minute + s) / 60.
	d := degree + m. 
	^d * sign asFloat
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readLatitudeString: aString [
	"read a latitude string and return the latitude value"

	| _format _string |
	(aString isNil or:[aString isString not]) ifTrue:[^nil].
	aString isEmpty ifTrue:[^nil].
	_string := self cleanLatitudeString: aString.

	_format := self geoStringFormat: _string.
	_format isNil ifFalse:[
		_format = #DMD ifTrue:[^self readDMDString: _string].
		_format = #DMS ifTrue:[
			(_string matchesRegex: '.*[0-9]+ [0-9]+ [0-9]+.*') ifTrue:[^self readSpacedDMSString: _string].
			^self readDMSString: _string
		].
		_format = #Decimal ifTrue:[^_string asNumber].
	].

	^nil
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readLongitudeString: aString [
	"read a longitude string and return the longitude value"

 	^self readLatitudeString: aString
]

{ #category : #'reading tools' }
AbsoluteCoordinates class >> readSpacedDMSString: aString [
	"Degree Minute Second"

	| rs degree minute second sign s m d _string |
	aString isString ifFalse: [ ^ aString ].
	_string := aString.
	sign := 1.
	_string regex: '[N|n|E|e].*' matchesDo: [ :str |
		sign := 1.
		_string := self in: _string removeChar: $N.
		_string := self in: _string removeChar: $E ].
	_string regex: '[S|s|W|w|O|o].*' matchesDo: [ :str |
		sign := -1.
		_string := self in: _string removeChar: $S.
		_string := self in: _string removeChar: $W.
		_string := self in: _string removeChar: $O ].
	(_string matchesRegex: ' [0-9].*') ifTrue: [
		_string := self in: _string removeFirstChar: Character space ].

	rs := ReadStream on: _string.
	degree := (rs upTo: Character space) asNumber.
	minute := (rs upTo: Character space) asNumber.
	second := (rs upTo: Character space) asNumber.

	"conversion"
	s := second / 60.
	m := minute + s / 60.
	d := degree + m.
	^ d * sign asFloat
]

{ #category : #cities }
AbsoluteCoordinates class >> usaLosAngeles [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 34.0522300
		longitudeInDegrees: -118.2436800
		altitudeInMeters: 96
]

{ #category : #cities }
AbsoluteCoordinates class >> usaNewYork [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 40.7142700
		longitudeInDegrees: -74.0059700
		altitudeInMeters: 57 
]

{ #category : #cities }
AbsoluteCoordinates class >> usaSeattle [

	^ AbsoluteCoordinates 
		latitudeInDegrees: 47.6062100
		longitudeInDegrees: -122.3320700
		altitudeInMeters: 56
]

{ #category : #'instance creation' }
AbsoluteCoordinates class >> zero [

	^ self latitudeInDegrees: 0 longitudeInDegrees: 0 altitudeInMeters: 0
]

{ #category : #comparing }
AbsoluteCoordinates >> = anAbsoluteCoordinates [

	anAbsoluteCoordinates ifNil:[ ^ false ].

	^ self latitudeInDegrees = anAbsoluteCoordinates latitudeInDegrees 
		and: [ self longitudeInDegrees = anAbsoluteCoordinates longitudeInDegrees
		and: [ self altitudeInMeters = anAbsoluteCoordinates altitudeInMeters ]]
]

{ #category : #accessing }
AbsoluteCoordinates >> altitude [

	self altitudeInMeters ifNil: [ ^ nil ].
	^ self altitudeInMeters units: #meters
]

{ #category : #accessing }
AbsoluteCoordinates >> altitudeInMeters [

	^ altitudeInMeters
]

{ #category : #accessing }
AbsoluteCoordinates >> altitudeInMeters: aNumber [

	altitudeInMeters := aNumber
]

{ #category : #converting }
AbsoluteCoordinates >> asECEFCartesianCoordinates [ 
	"Return Earth-Centered, Earth-Fixed cartesian coordinates corresponding to self"

	| coslat coslat2 sinlat sinlon coslon h v n |
	self isValid ifFalse:[ ^ nil ].
	
	coslat := self latitudeInRadians cos.
	coslat2 := coslat * coslat.
	sinlat := self latitudeInRadians sin.
	sinlon := self longitudeInRadians sin.
	coslon := self longitudeInRadians cos.
	h := self altitudeInMeters ifNil:[ 0 ].
	
	v := ((WGS84 secondEccentricitySquared * coslat) + 1) sqrt.
	n := WGS84 poleCurveRadius / v.
	
	^ CartesianCoordinates 
		xInMeters: (n + h) * coslat * coslon
		yInMeters: (n + h) * coslat * sinlon
		zInMeters: ((n * (1 - WGS84 eccentricitySquared)) + h) * sinlat
]

{ #category : #converting }
AbsoluteCoordinates >> asGeometryPoint [

	| coord |
	coord := G2DCoordinates new.
	coord x: self longitudeInDegrees.
	coord y: self latitudeInDegrees.
	^ GPoint coordinates: coord
]

{ #category : #converting }
AbsoluteCoordinates >> asLatLonDegreesPoint [

	self isValid ifFalse: [ ^ nil ].
	^ self latitudeInDegrees @ self longitudeInDegrees
]

{ #category : #converting }
AbsoluteCoordinates >> asLatLonRadiansPoint [

	self isValid ifFalse: [ ^ nil ].
	^ self latitudeInRadians @ self longitudeInRadians
]

{ #category : #converting }
AbsoluteCoordinates >> asLonLatDegreesPoint [

	self isValid ifFalse: [ ^ nil ].
	^ self longitudeInDegrees @ self latitudeInDegrees
]

{ #category : #converting }
AbsoluteCoordinates >> asLonLatRadiansPoint [

	self isValid ifFalse: [ ^ nil ].
	^ self longitudeInRadians @ self latitudeInRadians
]

{ #category : #converting }
AbsoluteCoordinates >> asPoint [

	^ self asLatLonDegreesPoint
]

{ #category : #copying }
AbsoluteCoordinates >> copy [

	| copy |
	copy := super copy.
	copy altitudeInMeters: self altitudeInMeters.		
	copy latitudeInDegrees: self latitudeInDegrees.		
	copy longitudeInDegrees: self longitudeInDegrees.		
	^copy
]

{ #category : #accessing }
AbsoluteCoordinates >> isEmpty [

	^ self latitudeInDegrees isNil and: [ self longitudeInDegrees isNil and: [ self altitudeInMeters isNil ] ]
]

{ #category : #accessing }
AbsoluteCoordinates >> isValid [

	^ self latitudeInDegrees notNil and: [ self longitudeInDegrees notNil ]
]

{ #category : #accessing }
AbsoluteCoordinates >> latitude [

	self latitudeInDegrees ifNil: [ ^ nil ].
	^ self latitudeInDegrees units: #arcdegree
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInDegrees [

	^ latitudeInDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInDegrees: anObject [

	latitudeInDegrees := self normalizeLatitudeInDegrees: anObject
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInRadians [

	^ latitudeInDegrees ifNotNil:[ :e | e degreesToRadians ]
]

{ #category : #accessing }
AbsoluteCoordinates >> latitudeInRadians: anObject [

	anObject ifNil:[ latitudeInDegrees := nil. ^ self ].
	self latitudeInDegrees: anObject radiansToDegrees
]

{ #category : #converting }
AbsoluteCoordinates >> localToECEFCartesianCoordinates: aLocalCartesianCoordinates [
	"Convert a local cartesian coordinates to an Earth-Centered, Earth-Fixed cartesian coordinates using self as referential"
	
	| xor yor zor lon lat slon slat clon clat clonclat clonslat slonslat slonclat ecefCartesianCoordinates |
	
	self isValid ifFalse:[ ^ nil ].
	aLocalCartesianCoordinates isValid ifFalse:[ ^ nil ].
	
	ecefCartesianCoordinates := self asECEFCartesianCoordinates.
	
	xor := ecefCartesianCoordinates xInMeters.
	yor := ecefCartesianCoordinates yInMeters.
	zor := ecefCartesianCoordinates zInMeters.
	
	lon := self longitudeInRadians.
	lat := self latitudeInRadians.
	
	slon := lon sin.
	clon := lon cos.
	slat := lat sin.
	clat := lat cos.
	
	clonclat := clon * clat.
	clonslat := clon * slat.
	slonclat := slon * clat.
	slonslat := slon * slat.
	
	^ CartesianCoordinates new
		xInMeters: xor + 
			(slon negated 		* aLocalCartesianCoordinates xInMeters) +
			(clonclat negated 	* aLocalCartesianCoordinates yInMeters) +
			(clonclat 			* aLocalCartesianCoordinates zInMeters)
		yInMeters: yor +
			(clon 			 		* aLocalCartesianCoordinates xInMeters) +
			(slonslat negated 	* aLocalCartesianCoordinates yInMeters) +
			(slonclat 			* aLocalCartesianCoordinates zInMeters)
		zInMeters: zor +
			(clat 			 		* aLocalCartesianCoordinates yInMeters) +
			(slat 				 	* aLocalCartesianCoordinates zInMeters)
]

{ #category : #accessing }
AbsoluteCoordinates >> longitude [

	self longitudeInDegrees ifNil: [ ^ nil ].
	^ self longitudeInDegrees units: #arcdegree
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInDegrees [

	^ longitudeInDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInDegrees: anObject [

	longitudeInDegrees := self wrapLongitude: anObject
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInRadians [

	^ longitudeInDegrees ifNotNil:[ :e | e degreesToRadians ]
]

{ #category : #accessing }
AbsoluteCoordinates >> longitudeInRadians: anObject [

	anObject ifNil:[ longitudeInDegrees := nil. ^ self ].
	self longitudeInDegrees: anObject radiansToDegrees
]

{ #category : #accessing }
AbsoluteCoordinates >> normalizeLatitudeInDegrees: aValueInDegrees [

	aValueInDegrees ifNil: [ ^aValueInDegrees ].
	aValueInDegrees > 90 ifTrue: [ ^ 90 ].
	aValueInDegrees < -90 ifTrue: [ ^ -90 ].
	^ aValueInDegrees
]

{ #category : #printing }
AbsoluteCoordinates >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' lat ', (self latitudeInDegrees ifNil:['--']) asString,'°';
		nextPutAll: ' lon ', (self longitudeInDegrees ifNil:['--']) asString,'°';
		nextPutAll: ' alt ', (self altitudeInMeters ifNil:['--']) asString,'m'
]

{ #category : #accessing }
AbsoluteCoordinates >> wrapLongitude: aValueInDegrees [

	| result |
	aValueInDegrees ifNil: [ ^aValueInDegrees ].
	result := aValueInDegrees.
	(result < -180 or: [ result > 180 ]) ifTrue:
		[ result := result + 180.
		result := result \\ 360.
	 	result := result < 0
			ifTrue: [ 180 + result ]
			ifFalse: [ -180 + result ]].
	^ result
]
