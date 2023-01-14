---
template: blog.html
title: Release 0.1.0
author: Daniel Baker
author_gh_user: djacu
read_time: 2 min
publish_date: January 1, 2023
---

## Overview

- This blog!

- Versioned releases

- A new matrix space

- A new name

- A(nother) new UI

### Blog and versioned releases

In the past year, we have made lots of changes. We have talked about using a
blog to communicate when major things change and also having releases as part
of that.

### Community

We want to foster a growing community around jupyenv but there is not a space
for users to directly communicate with each other and us. So we have created a
 new [Matrix space](https://matrix.to/#/#jupyenv:matrix.org).

### Name

We have changed the project name to `jupyenv`. Along with that is the new site,
[jupyenv.io](https://jupyenv.io).

### UI

We made changes to the UI when we switched the primary branch to `main` in
October 2022. That brought consistency and ease to configuring and maintaining
the kernels. We are making another change to further improve the UX of jupyenv.
As of this release, there will be a new NixOS module system for configuring
JupyterLab and all the kernels.

- [garbas](https://github.com/garbas) worked on creating a [new module
  system](https://github.com/tweag/jupyenv/pull/376) to configure
  JupyterLab and all the kernels.

- [djacu](https://github.com/djacu) worked on creating a [navigable
  documentation page](https://github.com/tweag/jupyenv/pull/389) for the
  [new options](https://jupyterwith.tweag.io/options).
