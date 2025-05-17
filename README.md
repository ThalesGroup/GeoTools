[![License](https://img.shields.io/github/license/openSmock/GeoTools.svg)](./LICENSE)
[![Pharo 11 CI](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo12CI.yml)

# GeoTools
Geographic Tools as `Coordinates`, `Kinematics` and `GeodesicUtilities`.

## Coordinates tools

Use these classes to store informations on geographical position in different coordinates system.

### Absolute coordinates

Use ```AbsoluteCoordinates``` to store an absolute coordinate.

Absolute coordinate is build by ```latitude``` (degrees or radians), ```longitude``` (degrees or radians) and ```altitude``` (meters). 

Example : create absolute coordinates.

```smalltalk
coord1 := AbsoluteCoordinates latitudeInDegrees: 48.3897 longitudeInDegrees: -4.48333 altitudeInMeters: 52. "Brest french city position"
coord2 := AbsoluteCoordinates latitudeInDegrees: 48.8667 longitudeInDegrees: 2.33333 altitudeInMeters: 79. "Paris french city position"
```

### Cartesian coordinates

Use ```CartesianCoordinates``` to store a cartesian coordinate.

Cartesian coordinate is build by ```x``` (meters), ```y``` (meters) and ```z``` (meters).

Example : create cartesian coordinates.

```smalltalk
coord := CartesianCoordinates xInMeters: 2 yInMeters: 5 zInMeters: 1.
```

### Polar coordinates

Use ```PolarCoordinates``` to store a polar coordinate.

Polar coordinate is build by ```azimuth``` (radians), ```distance``` (meters) and ```elevation``` (meters).

Example : create polar coordinates.

```smalltalk
coord := PolarCoordinates azimuthInRadians: 0 distanceInMeters: 50 elevationInMeters: 20.
```

Convert a polar coordinate into cartesian coordinates.

```smalltalk
polarCoord := PolarCoordinates zero. "This constructor create a polar coordinates initialized at zero point"
cartCoord := polarCoord asCartesianCoordinates.
```

### Common coordinates features

To know if a coordinate is valid :

```smalltalk
coord isValid.
```

To know if a coordinate is empty :

```smalltalk
coord isEmpty.
```

There are a lot of functionnaly to discover.

## Kinematics tools

Use ```Kinematics``` to store informations on ```course``` (direction in degrees or radians), ```speed``` (m/s, knots) and ```heading``` (orientation in degrees or radians).

Example : create kinematics information.

```smalltalk
kin := Kinematics new.
kin groundSpeedInMetersPerSeconds: 50.
kin courseInDegrees: 180.
kin headingInDegrees: 2.
```

## Map projection 

### Geodesic Utilities class

Use ```GeodesicUtilities``` to compute angle and distance between Geodesic (lat/long) coordinates, taking in account the earth curve.

```smalltalk
"Brest french city position"
coord1 := AbsoluteCoordinates latitudeInDegrees: 48.3897 longitudeInDegrees: -4.48333 altitudeInMeters: 52.
"Paris french city position"
coord2 := AbsoluteCoordinates latitudeInDegrees: 48.8667 longitudeInDegrees: 2.33333 altitudeInMeters: 79.

"Return an azimuth in Radians between the positions of these two cities depending Earth curve"
GeodesicUtilities convertGeodesicToAzimuthInRadiansFrom: coord1 to: coord2.
```

## Installation

To install GeoTools on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'GeoTools';
   repository: 'github://OpenSmock/GeoTools:main/src';
   load.
```

## Dependencies

- [OpenSmock - Core](https://github.com/OpenSmock/OpenSmock)
- [Units](https://github.com/zweidenker/Units)
