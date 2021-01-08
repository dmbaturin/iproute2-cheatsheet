Task-centered iproute2 manual
=============================

The `ip` command from the iproute2 package is now **the** Linux network management tool. 
Not only does it combine the functionality of the old `ifconfig`, `vconfig`, `route`, 
and other commands, it also supports networking features that the old tools still 
do not support. Some examples of missing functionality are multiple addresses on the 
same interface, policy-based routing, VRFs, and more.

A major issue with the iproute2 package is its documentation.  The man pages are extremely sparse, 
only containing basic descriptions of the options and functionality, and no meaningful examples.
While for an experienced user, this level of documentation is enough, for most novice users, it is not.
Many users continue using the `ifconfig` suite of tools out of habit and familiarity, 
and ultimately miss out on the powerful advantages of the `ip` tool. 

Historically, community-maintained documentation such as http://policyrouting.org/iproute2-toc.html 
and https://www.lartc.org/howto/ have filled the documentation void. Unfortunately, most of those documents 
have not been actively expanded since early or mid 2000s and are woefully out of date. Because of this,
they are missing a plethora of valuable and exciting new features. Finally, many of these documentation projects 
were never released under a free license, which makes them almost impossible to fork and maintain in 
the event that the original maintainer loses interest.

This document aims to provide a comprehensive, easy to use, as well as free and open-source
guide to iproute2. Whether the issue is adding an IP address, network namespace, or manipulating routing tables, 
there will be simple explanations and examples. It doesn't matter if the network admin is new or has years of experience, 
is a professional or just a tinkerer, this guide should provide all the documentation needed to solve 
any problem with the `ip` command.  

Originally this was named "iproute2 cheatsheet", but was renamed to "Task-centered iproute2 manual"
as the size and scope expanded.

# Primary location and mirroring

The original and primary location of the document is https://baturin.org/docs/iproute2/

The page is bundled with all the JS and CSS it needs, so it's easy to mirror.

# Repository structure

This page is preprocessed with [soupault](https://soupault.neocities.org)
website generator to create a static ToC with section links that doesn't rely on JS.

The content source is in `site/index.md`.

To build it, simply run `soupault` in the directory. The processed page will be in `build/index.html`.

# Contributing

Patches are always welcome. If you want to fix a typo, improve grammar or wording,
or document a previously undocumented feature, please open a pull request or email me
a patch (use git format-patch please).

The document is licensed under CC-BY-SA.
