---
title: Guide
sidebar_position: 20
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/sample/versions.json';

<AddonVersion data={versions} current="1.0.0" page="guide" />

<!-- From docs/index.md in kubevela/catalog at release/sample/1.0.0. Edit it there. -->
# Sample

## Run it

Enable it, then deploy a component:

```yaml
components:
  - name: app
    type: sample-app
    properties:
      image: sample:1.0
```

See [Addons](/addons/catalog/) for the rest.
