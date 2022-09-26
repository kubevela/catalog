<!--
Thank you for contributing to KubeVela Addons!

A new addon added in this repo should be put in as an experimental one unless you have test for a long time in your product environment and be approved by most maintainers.

An experimental addon must meet some conditions to be promoted as a verified one.

-->

### Description of your changes

<!--
Briefly describe what this pull request does. Be sure to direct your reviewers'
attention to anything that needs special consideration.

We love pull requests that resolve an open issue. If yours does, you
can uncomment the below line to indicate which issue your PR fixes, for example
"Fixes #500":

Fixes #
-->

### How has this code been tested?

<!--
Before reviewers can be confident in the correctness of a pull request,
it needs to tested and shown to be correct. In this section, briefly
describe the testing that has already been done or which is planned.
-->

### Checklist

<!--
Please run through the below readiness checklist. 
-->

I have:

- [ ] Title of the PR starts with type (e.g. `[Addon]` , `[example]` or `[Doc]`).
- [ ] Updated/Added any relevant [documentation](https://kubevela.io/docs/reference/addons/overview) and [examples](https://github.com/kubevela/catalog/tree/master/examples).
- [ ] New addon should be put in [experimental](https://github.com/kubevela/catalog/tree/master/experimental/addons).
- [ ] Update addon should modify the `version` in `metadata.yaml` to generate a new version.

####  Verified Addon promotion rules

If this pr wants to promote an experimental addon to verified, you must check whether meet these conditions too:
  - [ ] This addon must be tested by addon's [e2e-test](./test/e2e-test/addon-test) to guarantee this addon can be enabled successfully.
  - This addon must have some basic but necessary information.
    - [ ] An accessible icon url and source url defined in addon's `metadata.yaml`.
    - [ ] A detail introduction include a basic example about how to use and what's the benefit of this addon in `README.md`.
    - [ ] Also provide an introduction in KubeVela [documentation](https://kubevela.net/docs/reference/addons/overview).
    - [ ] It's more likely to be accepted if useful examples provided in example [dir](examples/).