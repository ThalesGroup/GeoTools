[![License](https://img.shields.io/github/license/openSmock/GeoTools.svg)](./LICENSE)
[![Pharo 11 CI](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/GeoTools/actions/workflows/Pharo12CI.yml)

# GeoTools
Geographic Tools as Coordinates &amp; Kinematics.

## Installation

To install GeoTools on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'GeoTools';
   repository: 'github://OpenSmock/GeoTools:main';
   load.
```

## Dependencies

- [Units](https://github.com/zweidenker/Units)
