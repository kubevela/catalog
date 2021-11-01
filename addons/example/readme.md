# Example FluxCD Addon

This is an example addon based [FluxCD](https://fluxcd.io/)

## Directory Structure

- metadata.yaml: file that contains addon metadata information.
- definitions/: contains the x-definitions yaml/cue files.
- template/:
  - `parameter.cue` to expose parameters. This will be converted to JSON schema and rendered in UI forms.
  - Other CUE template files that can read `parameters.XXX`.
  - Other YAML files not using any parameters and will be applied directly.

