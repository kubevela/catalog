# Example FluxCD Addon

This is an example addon based [FluxCD](https://fluxcd.io/)

## Directory Structure

- metadata.yaml: contains addon metadata information.
- definitions/: contains the X-Definition yaml/cue files.
- template/:
  - `parameter.cue` to expose parameters. It will be converted to JSON schema and rendered in UI forms.
  - All other files will be rendered as KubeVela Components. It can be one of the two types:
    - YAML file that contains only one resource.
      The resource name will be the component name.
    - CUE template file that can read user input as `parameter.XXX` as defined `parameter.cue`.
      Basically the CUE template file will be combined with `parameter.cue` to render a resource.
      Note that the first level key will be used as the Component name.

