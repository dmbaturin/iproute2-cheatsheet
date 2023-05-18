Task-centered iproute2 user guide
=================================

The `iproute2` package that contains `ip`, `bridge`, `tc`, and `ss` is now **the** Linux network management toolkit.
Not only does it combine the functionality of the old `ifconfig`, `vconfig`, `route`, 
and other commands, it also supports networking features that the old tools still
do not support. Some examples of missing functionality are multiple addresses on the 
same interface, policy-based routing, VRFs, network namespaces, and more.

A major issue with the iproute2 package is its documentation. Its man pages are extremely terse:
only basic descriptions of the options and almost no examples.
While for an experienced user, this level of documentation is enough, for most novice users, it is not.
Many users continue using `ifconfig` out of habit and familiarity
and ultimately miss out on the powerful features of the new tools.

Historically, community-maintained documentation such as http://policyrouting.org/iproute2-toc.html 
and https://www.lartc.org/howto/ filled the documentation void.
Unfortunately, those classic documents were written in the early to mid-2000s and haven't been updated ever since.
They are still good for learning how to use old features but don't cover any new functionality.
Worse yet, those documents aren't under free-culture licenses, so it's impossible to fork them
and make updated versions without their original maintainers' consent.

This document aims to provide a comprehensive, easy-to-use, free (as in freedom) guide to iproute2 —
at least its `ip` and `bridge` commands (documenting `tc` in this style would be a separate big project).

Originally this guide was named "iproute2 cheatsheet", but it has long outgrown the scope and size
of a mere cheatsheet, so now it's named a "Task-centered iproute2 user guide".

# Primary location and mirroring

The original and primary location of the document is https://baturin.org/docs/iproute2/

The page is bundled with all the JS, CSS, and images, so it's easy to mirror or save for local use.

# Contributing

Patches are always welcome. If you want to fix a typo, improve grammar or wording,
or document a previously undocumented feature, please open a pull request or email me
a patch (use `git format-patch` please!).

The content source is in `site/index.md`.

The licenses under CC-BY-SA 4.0.

## Contributing guidelines

Please use HTML headings with `id` attributes. Do not use Markdown headings.
In other words, use `<h3 id="ip-link-frobnicate">Frobnicate a link</h3>`
rather than `### Frobnicate a link`.

That allows section links to stay the same even if their wording changes or they are moved around the document.
People _are_ sharing deep links to sections of this document page, so let's keep those links permanent.

# Building

The manual page is built with [soupault](https://www.soupault.app) website generator/HTML processor.

This is how to build the page:

* Install git — it's also used in the build process to generate the "last modified" timestamp.
* Install soupault and [cmark](https://github.com/commonmark/cmark) on your system.
* Run `soupault` in the project directory.
* Find the generated page in `build/index.html`

This is what happens during the build process:

* `site/index.md` is converted to HTML and inserted in the `<main>` element of `templates/main.html`.
* A table of contents is generated from the page headings (soupault's built-in functionality).
* The table of contents `<ul>` is converted to a foldable "tree" of HTML5 `<details>` elements using the `plugins/collapsible-list.lua` plugin.
* CSS stylesheet and images are inlined using the `plugins/inline-assets.lua` plugin.
* Last modification date is extracted from the git commit history and inserted into the page, using the `plugins/git-timestamp.lua` plugin.
