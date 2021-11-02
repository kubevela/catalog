# Example FluxCD Addon

This is an example addon based [FluxCD](https://fluxcd.io/)

## Directory Structure

- metadata.yaml: contains addon metadata information.
- definitions/: contains the X-Definition yaml/cue files.
- template/:
  - `parameter.cue` to expose parameters. It will be converted to JSON schema and rendered in UI forms.
  - YAML files not using any parameters and to be applied directly.
  - CUE template files that can read `parameter.XXX` in `parameter.cue`.
    Basically the CUE template file will be combined with `parameter.cue` to render a resource.
    Note that the first level key will be used as the Component name.

