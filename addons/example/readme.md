# Example FluxCD Addon

This is an example addon based [FluxCD](https://fluxcd.io/)

## Directory Structure

- metadata.yaml: contains addon metadata information.
- definitions/: contains the X-Definition yaml/cue files.
- template/:
  - `parameter.cue` to expose parameters. This will be converted to JSON schema and rendered in UI forms.
  - Other CUE template files that can read `parameters.XXX` in `parameter.cue`.
    Note that the first level key must be unique to avoid conflict.
    Anything under that should be rendered into applicable resources, e.g. Application.
  - Other YAML files not using any parameters and to be applied directly.

